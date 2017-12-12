require 'thor'

module Catlass
  class Cli < Thor
    class_option :file, aliases: '-f', desc: 'Job definication file', type: :string, default: 'CAfile'
    class_option :color, desc: 'Disable colorize', type: :boolean, default: $stdout.tty?

    def initialize(*args)
      @actions = Catlass::Actions.new(
        Catlass::Client.new,
        Catlass::Converter.new
      )
      super(*args)
    end

    desc "export", "Export the job definication"
    option :write, desc: 'Write the job definication to the file', type: :boolean, default: false
    option :split, desc: 'Split file by the jobs', type: :boolean, default: false
    def export
      @actions.export(options)
    end

    desc "apply", "Apply the job definication"
    option :dry_run, desc: 'Dry run (Only output the difference)', type: :boolean, default: false
    def apply
      @actions.apply(options)
    end

  end
end
