require "minitest/autorun"
require "json"

require_relative "../lib/kotolang.rb"

pipes = {
  'bypass' => BypassPipe,
  'copy' => CopyPipe,
  'get' => GetPipe,
  'mock' => MockPipe,
  'move' => MovePipe,
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