require 'yaml'
require 'json'

module Catlass
  class Actions
    include Catlass::Logger::Helper

    def initialize(client, converter)
      @client = client
      @converter = converter
    end

    def export(options)
      Catlass::TermColor.color = options['color']
      jobs = @client.get_jobs

      if options['write']
        if options['split']
          content = ''
          jobs.each do |job|
            name = @converter.filename(job['attributes']['name'])
            _export_dsl_file(@converter.to_dsl(job), "#{name}.rb")
            content << "require #{name.inspect}\n"
          end
          _export_dsl_file(content, options['file'])
        else
          _export_dsl_file(@converter.to_dsl_all(jobs), options['file'])
        end
      else
        Catlass::Utils.print_ruby(@converter.to_dsl_all(jobs), color: options['color'])
      end
    end

    def apply(options)
      Catlass::TermColor.color = options['color']
      dry_run = options['dry_run'] ? '[Dry run] ' : ''
      local = @converter.dslfile_to_h(options['file'])
      remote = @client.get_jobs

      _apply_jobs(local, remote, dry_run, options)
    end

    def _apply_jobs(local, remote, dry_run, options)
      local.each do |l|
        r = _choice_by_name(remote, l)
        job_name = l['attributes']['name']

        if r.nil?
          info("#{dry_run}Create the new job #{job_name.inspect}")
          @client.create_job(l) if dry_run.empty?
        else
          job_id = r['id']
          diff = Catlass::Utils.diff(@converter, r, l, options['color'])

          if diff == "\n" or diff.empty?
            info("#{dry_run}No changes '#{job_name}'")
          else
            warn("#{dry_run}Update the job #{job_name.inspect}")
            STDERR.puts diff
            @client.update_job(job_id, l) if dry_run.empty?
          end
        end

      end

      remote.each do |r|
        if _choice_by_name(local, r).nil?
          job_name = r['attributes']['name']
          warn("#{dry_run}Delete the job #{job_name.inspect}")
          @client.delete_job(r['id']) if dry_run.empty?
        end
      end
    end

    def _choice_by_name(jobs, target)
      jobs.each do |d|
        return d if d['attributes']['name'] == target['attributes']['name']
      end
      nil
    end

    def _export_dsl_file(dsl, filename)
      dsl = <<-EOS
#! /usr/bin/env ruby

#{dsl}
EOS
      _export_file(dsl, filename)
    end

    def _export_file(dsl, filename)
      File.write(filename, dsl)
      info("Write #{filename.inspect}")
    end
  end
end
