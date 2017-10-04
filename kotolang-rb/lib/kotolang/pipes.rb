require 'json'

module Kotolang
  class Paw
    def initialize(flow:)
      @flow = flow
    end

    attr_reader :flow

    def call(input, config, pipes)
      Kotolang::Runner.(['ok', [input, config]], @flow, pipes)
    end
  end

  def self.load(*args)
    filename = File.join(*[PAW_DIR, *args])
    data = JSON.parse(File.read(filename))
    Paw.new(flow: data['flow'])
  end

  PAW_DIR = File.join(File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))), 'paws')

  PIPES = {
    'tee' => Tee,
    'mock' => Mock,
    'json:parse' => Json::Parse,
    'json:dump' => Json::Dump,
    'std:mock' => Mock,
    'std:obj:get' => Obj::Get,
    'std:obj:set' => Obj::Set,
    'std:arr:get' => Arr::Get,
    'std:arr:set' => Arr::Set,
    'std:arr:has' => Arr::Has,
    'std:arr:map' => Arr::Map,
    'std:bool:not' => Bool::Not,
    'std:str:get' => Str::Get,
    'std:str:set' => Str::Set,
    'std:str:eq' => Str::Eq,
    'std:way:set' => Std::Way::Set,
    'std:way:get' => Std::Way::Get,
    'std:run' => Std::Run,
    'std:way:call' => Std::Way::Call,
    'std:if' => Std::If,
    'std:type' => Std::Type,
    'std:call' => Std::Call,
    'std:get' => load('std', 'get.paw.json'),
    'std:set' => load('std', 'set.paw.json'),
    'debug' => -> (input, config, pipes) do
      puts config if config
      puts input
      input
    end
  }.freeze
end