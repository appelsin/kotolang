module KotoHelpers
  def self.safeHashDig(hash, path)
    path.reduce(hash) do |memo, val|
      memo.is_a?(Hash) ? memo[val] : nil
    end
  end
end

module MockPipe
  def self.call(input, config)
    ['ok', config]
  end
end

module BypassPipe
  def self.call(input, config)
    ['ok', input]
  end
end

class Kotolang
  def self.call(input, flow, pipes)
    # input = ['error', {'errors' => [{'title' => 'Input validation failed'}]}]
    flow = [] unless flow.is_a?(Array)
    flow.reduce(input) do |memo, step|
      input_way, input = memo
      step_way, pipe, config = step
      pipes[pipe].(input, config)
    end
  end
end