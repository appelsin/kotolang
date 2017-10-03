# frozen_string_literal: true

module Std
  module Way
    module Call
      def self.call(input, config, pipes)
        way, result = ::Std::Run.(input, config, pipes)
        if 'ok' == way
          [result, input]
        else
          ['error', nil]
        end
      end
    end

    module Get
      def self.call_with_way(input_way, input, config, pipes)
        ['ok', input_way]
      end
    end

    module Set
      def self.call(input, config, pipes)
        if config.is_a?(String)
          [config, input]
        else
          ['error', nil]
        end
      end
    end
  end

  module Call
    def self.call(input, config, pipes)
      pipe_input = input[0]
      pipe_config = input[1]

      ::Kotolang::Runner.(['ok', pipe_input], [
        ['ok', config, pipe_config]
      ], pipes)
    end
  end

  module Run
    def self.call(input, config, pipes)
      if config.is_a?(Array)
        ::Kotolang::Runner.(['ok', input], config, pipes)
      else
        ['error', nil]
      end
    end
  end

  module If
    def self.call_with_way(input_way, input, config, pipes)
      expr_flow = config[0]

      expr_flow_result = ::Kotolang::Runner.(
        [input_way, input],
        expr_flow,
        pipes
      )

      if expr_flow_result[0] == 'error'
        expr_flow_result
      elsif expr_flow_result[0] != 'ok'
        ['error', ['Expression result is not ok', "way: #{expr_flow_result[0]}", expr_flow_result]]
      elsif expr_flow_result == ['ok', true]
        then_flow = config[1]
        if then_flow.nil?
          ['ok', nil]
        else
          ::Kotolang::Runner.(
            [input_way, input],
            then_flow,
            pipes
          )
        end
      elsif expr_flow_result == ['ok', false]
        else_flow = config[2]
        if else_flow.nil?
          ['ok', nil]
        else
          ::Kotolang::Runner.(
            [input_way, input],
            else_flow,
            pipes
          )
        end
      else
        ['error', ['Expression result is not boolean']]
      end
    end
  end

  module Switch
    def self.call(input, config, pipes)
      expr_flow = config['flow']

      expr_flow_result = Call.(
        input,
        expr_flow,
        pipes
      )

      if expr_flow_result == ['ok', true]
        then_flow = config['then']
        if then_flow.nil?
          ['ok', nil]
        else
          Call.(
            input,
            then_flow,
            pipes
          )
        end
      elsif expr_flow_result == ['ok', false]
        else_flow = config['else']
        if else_flow.nil?
          ['ok', nil]
        else
          Call.(
            input,
            else_flow,
            pipes
          )
        end
      else
        ['error', ['Flow result is not boolean']]
      end
    end
  end
  # module Switch
  #   def self.call(input, config, pipes)
  #     flow = config['flow']
  #     return nil unless flow.is_a?(Array)

  #     flow = Call.(
  #       input,
  #       config,
  #       pipes
  #     )
  #   end
  # end

  module Type
    def self.call(input, config, pipes)
      if input.nil?
        ['ok', 'null']
      elsif input.is_a?(TrueClass) || input.is_a?(FalseClass)
        ['ok', 'boolean']
      elsif input.is_a?(Array)
        ['ok', 'array']
      elsif input.is_a?(Hash)
        ['ok', 'object']
      elsif input.is_a?(String)
        ['ok', 'string']
      elsif input.is_a?(Integer)
        ['ok', 'integer']
      elsif input.is_a?(Float)
        ['ok', 'float']
      else
        ['error', nil]
      end
    end
  end
end