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

  module Has
    def self.call(input, config, pipes)
      if input.is_a?(Array) && config.is_a?(Integer)
        if config < 0
          ['ok', false]
        else
          ['ok', config < input.size]
        end
      else
        ['error', nil]
      end
    end
  end

  module Map
    def self.call(input, config, pipes)
      if input.is_a?(Array) && config.is_a?(Array)
        ['ok', input.map do |val|
          way, result = ::Kotolang::Runner.(['ok', val], config, pipes)
          return [way, result] if way != 'ok'
          result
        end]
      else
        ['error', nil]
      end
    end
  end
end