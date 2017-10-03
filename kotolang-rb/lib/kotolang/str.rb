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