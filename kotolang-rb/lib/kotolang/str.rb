# frozen_string_literal: true

module Str
  module Get
    def self.call(input, config, pipes)
      if input.is_a?(String) && config.is_a?(Integer)
        if config >= 0
          ['ok', input[config]]
        else
          ['ok', nil]
        end
      else
        ['error', nil]
      end
    end
  end

  module Set
    def self.call(input, config, pipes)
      if input.is_a?(String) && config.is_a?(Array) && config.length == 2 &&
            config[0].is_a?(Integer) &&
            config[1].is_a?(String) && config[1].length == 1
        result = input.dup
        result[config[0]] = config[1]
        ['ok', result.freeze]
      else
        ['error', nil]
      end
    end
  end

  module Eq
    def self.call(input, config, pipes)
      if input.is_a?(String) && config.is_a?(String)
        ['ok', input == config]
      else
        ['error', nil]
      end
    end
  end
end