require 'kotolang'

class Kotoplay
  class DSL
    class Rec
      def initialize(way, paw, args, &block)
        if block_given?
          dsl = DSL.new
          dsl.instance_eval &block
          flow = dsl.flow
          if args[0].is_a?(String) || args[0].is_a?(Symbol) 
            result = { args[0].to_s => flow }
            result = result.merge(args[1]) if args[1].is_a?(Hash)
            @args = [result]
          else
            @args = [flow]
          end
        else
          @args = args
        end
        @way, @paw = way, paw
      end

      def method_missing(name, *args, &block)
        Rec.new(@way, @paw + ':' + name.to_s, args, &block)
      end

      def to_ary
        [@way, @paw, *(@args.empty? ? [nil] : @args)]
      end
    end

    def initialize()
      @flow = []
    end

    attr_reader :flow

    def on(way, step)
      step_way, step_paw, *step_data = step
      @flow << [way.to_s, step_paw.to_s, *step_data]
    end

    def ok(step, &block)
      on :ok, step
    end

    def error(step)
      on :error, step
    end

    def method_missing(name, *args, &block)
      Rec.new('ok', name.to_s, args, &block)
    end
  end

  def call(&block)
    dsl = DSL.new
    dsl.instance_eval &block
    dsl.flow
  end
end