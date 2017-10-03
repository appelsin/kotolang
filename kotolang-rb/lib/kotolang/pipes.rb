module Kotolang
  PIPES = {
    'bypass' => Bypass,
    'mock' => Mock,
    'std:mock' => Mock,
    'std:bypass' => Bypass,
    'std:obj:get' => Obj::Get,
    'std:obj:set' => Obj::Set,
    'std:arr:get' => Arr::Get,
    'std:arr:set' => Arr::Set,
    'std:str:eq' => Str::Eq,
    'std:way:set' => Std::Way::Set,
    'std:way:get' => Std::Way::Get,
    'std:run' => Std::Run,
    'std:way:call' => Std::Way::Call,
    'std:if' => Std::If,
    'std:type' => Std::Type,
    'std:call' => Std::Call,
    'std:get' => [
        ['ok', 'std:way:call', [
          ['ok', 'std:arr:get', 0],
          ['ok', 'std:type', nil]
        ]],
        ['array', 'std:call', 'std:arr:get'],
        ['object', 'std:call', 'std:obj:get'],
        # ['string', 'std:str:get', config],
        # ['boolean', 'std::get', config],
        # ['integer', 'std::get', config],
        # ['float', 'std::get', config],
        # ['null', 'std::get', config],
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
    ],
    'debug' => -> (input, config, pipes) do
      puts config if config
      puts input
      input
    end
  }.freeze
end