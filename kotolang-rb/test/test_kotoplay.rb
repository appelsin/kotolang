require "minitest/autorun"
require "json"

require_relative "../lib/kotoplay.rb"

class KotoplayTest < Minitest::Test
  def test_on
    result = Kotoplay.new().call do
      on :ok, [nil, 'test', nil]
    end
    assert_equal [['ok', 'test', nil]], result
  end

  def test_multiple_on
    result = Kotoplay.new().call do
      on :ok, [nil, 'test', nil]
      on :error, [nil, 'error_handle', {}]
    end
    assert_equal [['ok', 'test', nil], ['error', 'error_handle', {}]], result
  end

  def test_on_symbol
    result = Kotoplay.new().call do
      on :ok, [nil, :test, nil]
    end
    assert_equal [['ok', 'test', nil]], result
  end

  def test_ok_error
    result = Kotoplay.new().call do
      ok [nil, 'test', nil]
      error [nil, 'error_handle', {}]
    end
    assert_equal [['ok', 'test', nil], ['error', 'error_handle', {}]], result
  end

  def test_paws
    result = Kotoplay.new().call do
      ok paw
      error other_paw 'paw' => 'data'
    end
    assert_equal [
      ['ok', 'paw', nil],
      ['error', 'other_paw', {'paw' => 'data'}]
    ], result
  end

  def test_paws_namespeces
    result = Kotoplay.new().call do
      ok paw.get
      error std.paw.set 'paw' => 'data'
    end
    assert_equal [
      ['ok', 'paw:get', nil],
      ['error', 'std:paw:set', {'paw' => 'data'}]
    ], result
  end

  def test_paws_block
    result = Kotoplay.new().call do
      ok paw.eval {
        ok std.paw.set 'paw' => 'data'
      }
    end
    assert_equal [
      ['ok', 'paw:eval', [
        ['ok', 'std:paw:set', {'paw' => 'data'}]
      ]]
    ], result
  end

  def test_paws_block_key
    result = Kotoplay.new().call do
      ok paw.eval(:flow) {
        ok std.paw.set 'paw' => 'data'
      }
    end
    assert_equal [
      ['ok', 'paw:eval', {
        'flow' => [['ok', 'std:paw:set', {'paw' => 'data'}]]
      }]
    ], result
  end

  def test_paws_block_key_and_args
    result = Kotoplay.new().call do
      ok paw.eval(:flow, 'some' => 'data') {
        ok std.paw.set 'paw' => 'data'
      }
    end
    assert_equal [
      ['ok', 'paw:eval', {
        'flow' => [['ok', 'std:paw:set', {'paw' => 'data'}]],
        'some' => 'data'
      }]
    ], result
  end
end