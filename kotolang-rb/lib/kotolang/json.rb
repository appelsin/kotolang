# frozen_string_literal: true

require 'json'

module Kotolang
  module Json
    module Parse
      def self.call(input, config, pipes)
        ['ok', JSON.parse(input)]
      rescue JSON::ParserError => exc
        ["error", ["JSON parse error"]]
      end
    end

    module Dump
      def self.call(input, config, pipes)
        ['ok', JSON.dump(input)]
      end
    end
  end
end