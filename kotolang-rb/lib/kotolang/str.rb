# frozen_string_literal: true

module Str
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