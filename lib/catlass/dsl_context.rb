require 'hashie'

module Catlass
  class DSLContext
    def initialize
      @jobs = []
      @templates = {}
      @context = Hashie::Mash.new()
    end

    def eval_dsl(dsl_file)
      @_dsl_file = dsl_file
      instance_eval(File.read(dsl_file), dsl_file)
      @jobs
    end

    def method_missing(method_name, *args, &block)
      if [:Job].include?(method_name)
        hash = dslh_eval(block)
        hash['attributes']['name'] = args[0]
        @jobs << hash
      else
        super
      end
    end

    def template(name, &block)
      @templates[name.to_s] = block
    end

    def context
      @context
    end

    def require(file)
      jobfile = (file =~ %r|\A/|) ? file : File.expand_path(File.join(File.dirname(@_dsl_file), file))

      if File.exist?(jobfile)
        instance_eval(File.read(jobfile), jobfile)
      elsif File.exist?(jobfile + '.rb')
        instance_eval(File.read(jobfile + '.rb'), jobfile + '.rb')
      else
        Kernel.require(file)
      end
    end

    def dslh_eval(block)
      scope_hook = proc do |scope|
        scope.instance_eval(<<-'EOS')
          def include_template(template_name, context = {})
            tmplt = @templates[template_name.to_s]

            unless tmplt
              raise "Template '#{template_name}' is not defined"
            end

            context_orig = @context
            @context = @context.merge(context)
            instance_eval(&tmplt)
            @context = context_orig
          end

          def context
            @context
          end

          def __dsl(&block)
            @__hash__ = JSON.generate(Dslh::ScopeBlock.nest(binding, 'block'))
          end

          def __script(str)
            str.split(/\R/)
          end

          def __script_file(file)
            File.read(file).split(/\R/)
          end
        EOS
      end

      scope_vars = {templates: @templates, context: @context}

      Dslh.eval(allow_empty_args: true, scope_hook: scope_hook, scope_vars: scope_vars, &block)
    end
  end
end
