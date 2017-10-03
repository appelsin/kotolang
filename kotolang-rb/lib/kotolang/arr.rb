# frozen_string_literal: true

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
        ['ok', result.freeze]
      else
        ['error', nil]
      end
    end
  end
end