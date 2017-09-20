require "minitest/autorun"
require "json"

require_relative "../lib/kotolang.rb"

pipes = {
  'mock' => MockPipe,
  'bypass' => BypassPipe
}

Dir.glob(
  File.join(
    File.dirname(__FILE__),
    '..', '..', 'spec', '*.spec.json'
  )
).each do |spec_file_name|
  f = File.read(spec_file_name)
  specs = JSON.parse(f)

  Class.new(Minitest::Test) do
    specs['specs'].each do |spec|
      define_method :"test_#{spec['title']}" do
        assert_equal spec['expected'], Kotolang.(spec['input'], spec['flow'], pipes)
      end
    end
  end
end