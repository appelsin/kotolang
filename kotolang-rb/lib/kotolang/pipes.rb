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
    'std:get' => Paw.new(flow: [
        ['ok', 'std:way:call', [
          ['ok', 'std:arr:get', 0],
          ['ok', 'std:type', nil]
        ]],
        ['array', 'std:call', 'std:arr:get'],
        ['object', 'std:call', 'std:obj:get'],
        ['string', 'std:call', 'std:str:get'],
        [nil, 'std:if', [
          [
            [nil, 'std:way:get', nil],
            ['ok', 'std:str:eq', 'ok']
          ],
          [],
          [
            [nil, 'std:mock', ['Function is not implemented for input type', 'If is not implemented']],
            ['ok', 'std:way:set', 'error']
          ]
        ]],
    ]),
    'std:set' => Paw.new(flow: [
        ['ok', 'std:way:call', [
          ['ok', 'std:arr:get', 0],
          ['ok', 'std:type', nil]
        ]],
        ['array', 'std:call', 'std:arr:set'],
        ['object', 'std:call', 'std:obj:set'],
        ['string', 'std:call', 'std:str:set'],
        [nil, 'std:if', [
          [
            [nil, 'std:way:get', nil],
            ['ok', 'std:str:eq', 'ok']
          ],
          [],
          [
            [nil, 'std:mock', ['Function is not implemented for input type', 'If is not implemented']],
            ['ok', 'std:way:set', 'error']
          ]
        ]],
    ]),
    'debug' => -> (input, config, pipes) do
      puts config if config
      puts input
      input
    end
  }.freeze
end