require 'dslh'

module Catlass
  class Converter

    def set_options(options)
      @options = options
    end

    def to_dsl_all(docs)
      dsls = []
      docs.each do |doc|
        dsls << to_dsl(doc)
      end
      dsls.join("\n")
    end

    def to_dsl(job)
      exclude_key = proc do |k|
        false
      end

      key_conv = proc do |k|
        k = k.to_s
        if k !~ /\A[_a-z]\w+\Z/i
          "_(#{k.inspect})"
        else
          k
        end

      end

      name = job['attributes']['name']
      hash = convert_attributes(job)

      dsl = Dslh.deval(
        hash,
        exclude_key: exclude_key,
        use_heredoc_for_multi_line: true,
        key_conv: key_conv,
        initial_depth: 1
      )
<<-EOS
Job #{name.inspect} do
#{dsl}
end
EOS
    end

    def dslfile_to_h(dsl_file)
      context = DSLContext.new
      context.eval_dsl(dsl_file)
    end

    def filename(name)
      name.gsub!(/\W+/, '_')
    end

    def convert_attributes(hash)
      hash.delete('id')
      hash['attributes'].delete('name')
      hash['attributes'].delete('created_at')
      hash['attributes'].delete('updated_at')
      hash['attributes']['rule_value'].delete('next_occurrence')
      if hash['attributes']['rule_value']['weekly_schedule'].is_a?(String)
       hash['attributes']['rule_value']['weekly_schedule'] = eval(hash['attributes']['rule_value']['weekly_schedule'])
      end
      hash
    end

  end
end
