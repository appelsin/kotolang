require "minitest/autorun"
require "json"

require_relative "../lib/kotolang.rb"

pipes = {
  'bypass' => BypassPipe,
  'mock' => MockPipe,
  'obj:get' => Obj::Get,
  'obj:set' => Obj::Set,
  'arr:get' => Arr::Get,
  'arr:set' => Arr::Set,
  'std:way' => Std::Way,
  'std:call' => Std::Call,
  'std:wayflow' => Std::WayFlow,
  #'copy' => CopyPipe,
  #'get' => GetPipe,
  #'move' => MovePipe,
  # 'set' => SetPipe
}

Dir.glob(
  File.join(
    File.dirname(__FILE__),
    '..', '..', 'spec', '*.spec.json'
  )
).each do |spec_file_name|
  f = File.read(spec_file_name)
          .gsub(/^(\s+)\/\/.+$/, '') # comments in json
  specs = JSON.parse(f)

  Class.new(Minitest::Test) do
    specs['specs'].each do |spec|
      define_method :"test_#{spec['title']}" do
        assert_equal spec['expected'], Kotolang.(spec['input'], spec['flow'], pipes)
      end
    end
  end
end