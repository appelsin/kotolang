require "minitest/autorun"
require "json"

require_relative "../lib/kotolang.rb"

pipes = {
  'bypass' => Bypass,
  'mock' => Mock,
  'std:obj:get' => Obj::Get,
  'std:obj:set' => Obj::Set,
  'std:arr:get' => Arr::Get,
  'std:arr:set' => Arr::Set,
  'std:str:eq' => Str::Eq,
  'std:way' => Std::Way,
  'std:call' => Std::Call,
  'std:way:call' => Std::Way::Call,
  'std:if' => Std::If,
  'std:type' => Std::Type,
  'get' => -> (input, config, pipes) do
    ::Kotolang::Runner.(['ok', [input, config]], [
      ['ok', 'std:arr:get', 0],
      ['ok', 'std:way:call', [
        ['ok', 'std:type', nil]
      ]],
      ['array', 'std:arr:get', config],
      ['object', 'std:obj:get', config]
      # ['string', 'std:str:get', config],
      # ['boolean', 'std::get', config],
      # ['integer', 'std::get', config],
      # ['float', 'std::get', config],
      # ['null', 'std::get', config],
    ], pipes)
  end,
  'debug' => -> (input, config) do
    puts [input, config]
  end
}.freeze

test_root = File.join(
  File.dirname(__FILE__),
  '..', '..', 'spec'
)

Dir.glob(
  File.join(test_root, '**', '*.spec.json')
).each do |spec_file_name|
  f = File.read(spec_file_name)
          .gsub(/^(\s+)\/\/.+$/, '') # comments in json
  specs = JSON.parse(f)

  Class.new(Minitest::Test) do
    define_singleton_method :to_s do
      spec_file_name
    end

    specs['specs'].each do |spec|
      define_method :"test_#{spec['title']}" do
        assert_equal spec['expected'], ::Kotolang::Runner.(
          spec['input'].freeze,
          spec['flow'].freeze,
          pipes
        )
      end
    end
  end
end