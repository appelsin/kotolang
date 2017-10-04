# frozen_string_literal: true

module Bool
  module Not
    def self.call(input, config, pipes)
      if input === true
        ['ok', false]
      elsif input === false
        ['ok', true]
      else
        ['error', nil]
      end
    end
  end
end