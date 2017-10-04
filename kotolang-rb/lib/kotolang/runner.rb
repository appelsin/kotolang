# frozen_string_literal: true

module Kotolang
  module Runner
    def self.call(input, flow, pipes)
      # input = ['error', {'errors' => [{'title' => 'Input validation failed'}]}]
      flow = [] unless flow.is_a?(Array)
      flow.reduce(input) do |memo, step|
        input_way, input = memo
        step_way, pipe, config = step
        if step_way.nil? || input_way == step_way
          callable = pipes[pipe]
          if callable.respond_to?(:call_with_way)
            callable.call_with_way(input_way, input, config, pipes)
          elsif callable.respond_to?(:call)
            callable.(input, config, pipes)
          elsif callable.nil?
            ['error', ['Function not found', "Unknown function #{pipe}"]]
          else
            ['error', ['Function not found', "Function #{pipe} has unknown definition type"]]
          end
        else
          memo # bypass
        end
      end
    end
  end
end