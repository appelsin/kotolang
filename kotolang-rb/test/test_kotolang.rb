require "minitest/autorun"
require "json"

require_relative "../lib/kotolang.rb"

# pipe(:std) do
#   way.call do
#     arr.get 0
#     type
#   end
#   on :array, call(arr.get)
# end


pipes = Kotolang::PIPES

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