# frozen_string_literal: true

require_relative './kotolang/version'
require_relative './kotolang/runner'
require_relative './kotolang/arr'
require_relative './kotolang/bool'
require_relative './kotolang/obj'
require_relative './kotolang/str'
require_relative './kotolang/std'
require_relative './kotolang/json'

module Tee
  def self.call(input, config, pipes)
    ['ok', input]
  end
end

module Mock
  def self.call(input, config, pipes)
    ['ok', config]
  end
end

require_relative './kotolang/pipes'