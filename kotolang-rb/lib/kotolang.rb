# frozen_string_literal: true

module KotoHelpers
  def self.safe_dig(input, path)
    array_path = path.is_a?(Array) ? path : [path]
    array_path.reduce(input) do |memo, key|
      if memo.is_a?(Hash)
        memo[key]
      elsif memo.is_a?(Array) && key.is_a?(Integer)
        memo[key]
      else
        nil
      end
    end
  end

  # def self.safe_deep_set(input, path, value)
  #   array_path = path.is_a?(Array) ? path.dup : [path]
  #   key = array_path.shift
  #   if array_path.empty?

  #   else
  #     if memo.is_a?(Hash) || (memo.is_a?(Array) && key.is_a?(Integer))
  #       new_input = input[key]
  #     else
  #       new_input = nil
  #     end

  #     unless new_input.nil?
  #       safe_deep_set(input, array_path, value)
  #     end
  #   end
  # end

  def self.safe_dup(value)
    value.nil? ? value : value.dup
  end

  def self.error(input, title, detail)
    output = input.is_a?(Hash) ? input.dup : {}
    output['errors']||= []
    output['errors']+= [{'title' => title, 'detail' => detail, 'debug' => {'input' => input}}]
    ['error', output]
  end
end

module BypassPipe
  def self.call(input, config, pipes)
    ['ok', input]
  end
end

module Arr
  module Get
    def self.call(input, config, pipes)
      if input.is_a?(Array) && config.is_a?(Integer)
        ['ok', input[config]]
      else
        ['error', nil]
      end
    end
  end

  module Set
    def self.call(input, config, pipes)
      if input.is_a?(Array) && config.is_a?(Array) && config.length == 2 && config[0].is_a?(Integer)
        result = input.dup
        result[config[0]] = config[1]
        ['ok', result]
      else
        ['error', nil]
      end
    end
  end
end

module Obj
  module Get
    def self.call(input, config, pipes)
      if input.is_a?(Hash) && config.is_a?(String)
        ['ok', input[config]]
      else
        ['error', nil]
      end
    end
  end

  module Set
    def self.call(input, config, pipes)
      if input.is_a?(Hash) && config.is_a?(Array) && config.length == 2 && config[0].is_a?(String)
        result = input.dup
        result[config[0]] = config[1]
        ['ok', result]
      else
        ['error', nil]
      end
    end
  end
end

module GetPipe
  def self.call(input, config, pipes)
    if (input.is_a?(Hash) || input.is_a?(Array))
      path = config['path']
      if path
        ['ok', KotoHelpers.safe_dig(input, path)]
      else
        KotoHelpers.error(input, '"get" wrong config', "#{JSON.dump config}")
      end
    else
      KotoHelpers.error(input, '"get" wrong input type', "Input type: #{input.class}")
    end
  end
end

# module SetPipe
#   def self.call(input, config)
#     if (input.is_a?(Hash) || input.is_a?(Array))
#       value = config['value']
#       if value
#         ['ok', KotoHelpers.safe_deep_set(input, path, value)]
#       else
#         KotoHelpers.error(input, '"set" wrong config', "#{JSON.dump config}")
#       end
#     else
#       KotoHelpers.error(input, '"set" wrong input type', "Input type: #{input.class}")
#     end
#   end
# end

module CopyPipe
  def self.call(input, config, pipes)
    if input.is_a?(Hash)
      from, to = config['from'], config['to']
      value = KotoHelpers.safe_dup(input[from])
      if to.nil?
        ['ok', value]
      else
        output = KotoHelpers.safe_dup(input)
        output[to] = value
        ['ok', output]
      end
    else
      KotoHelpers.error(input, '"copy" expects object input', "Input type: #{input.class}")
    end
  end
end

module MockPipe
  def self.call(input, config, pipes)
    ['ok', config]
  end
end

module MovePipe
  def self.call(input, config, pipes)
    if input.is_a?(Hash)
      from, to = config['from'], config['to']
      output = KotoHelpers.safe_dup(input)
      value = output.delete(from)
      output[to] = value
      ['ok', output]
    else
      KotoHelpers.error(input, '"move" expects object input', "Input type: #{input.class}")
    end
  end
end

class Kotolang
  def self.call(input, flow, pipes)
    # input = ['error', {'errors' => [{'title' => 'Input validation failed'}]}]
    flow = [] unless flow.is_a?(Array)
    flow.reduce(input) do |memo, step|
      input_way, input = memo
      step_way, pipe, config = step
      if input_way == step_way
        pipes[pipe].(input, config, pipes)
      else
        memo # bypass
      end
    end
  end
end

module Std
  module Way
    def self.call(input, config, pipes)
      if config.is_a?(String)
        [config, input]
      else
        ['error', nil]
      end
    end
  end

  module Call
    def self.call(input, config, pipes)
      if config.is_a?(Array)
        ::Kotolang.(['ok', input], config, pipes)
      else
        ['error', nil]
      end
    end
  end

  module WayFlow
    def self.call(input, config, pipes)
      way, result = Call.(input, config, pipes)
      if 'ok' == way
        [result, input]
      else
        ['error', nil]
      end
    end
  end

  # module Switch
  #   def self.call(input, config, pipes)
  #     Call.(
  #       input,
  #     )
  #   end
  # end
end