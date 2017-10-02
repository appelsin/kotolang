require 'pp'

class SplitComs
  def self.call(str)
    result = []
    fin = str.each_char.reduce(['.', '']) do |memo, ch|
      case ch
        when '.'
          result << memo
          ['.', '']
        when '['
          result << memo
          ['[', nil]
        when ']'
          if '[' == memo[0]
            ['[]', '']
          end
        else
          memo[1] << ch
          memo
      end
    end
    result << fin
    result
  end
end

class Extract
  def self.call(m, v, symbol: false, indifferent: false)
    if m.is_a?(Hash)
      v = v.gsub('\\', '')
      if indifferent
        m.has_key?(v) ? m[v] : m[v.to_sym]
      else
        m[symbol ? v.to_sym : v]
      end
    elsif m.is_a?(Array) && v =~ /^(\d)+$/
      m[v.to_i]
    else
      nil
    end
  end
end

# p SplitComs.('as.fd.wqw')
# p SplitComs.('as.fd[]wqw')

class Dig
  def self.call(hash, chain)
    chain = chain.dup
    memo = hash
    loop do
      break if chain.empty?
      step = chain.shift
      com, key = step
      memo = case com
        when '.'
          Extract.(memo, key)
        when '[]'
          memo = memo.map {|val| Dig.(val, chain)}
          memo = memo.flatten if '+' == key
          memo = memo.flatten(key.to_i) if /\A(\d+)\z/ =~ key
          memo = memo.compact if '?' == key
          break
        else
          nil
      end
    end
    memo
  end
end

p Dig.(
  {
    'aa' => {
      'bb' => [
        {'c' => 3},
        {'c' => 4},
        {'x' => 1},
      ] 
    }
  },
  SplitComs.('aa.bb[]?.c')
  # [
  #   ['.', 'aa'],
  #   ['.', 'bb'],
  #   ['[]', '?'],
  #   ['.', 'c'],
  # ]
)

struct = {
  'aa' => {
    'bb' => [
        {'c' => [{'x' => 2}, {'x' => 4}], 'y' => {'z' => 1}},
        {'c' => [{'x' => 3}]},
        {'c' => [{'x' => 4}]},
    ] 
  }
}

# p Dig.(
#   struct,
#   SplitComs.('aa.bb[]1.c[].x')
# )

# p({
#   'ces' => [
#     {
#       'y' => Dig.(struct, SplitComs.('aa.bb[].y')),
#       'x' => Dig.(struct, SplitComs.('aa.bb[].c[].x')),
#     }
#   ],
#   # 'orig' => struct
# })

# p('ces' => [
#   {
#     'y' => Dig.(struct, [['.', 'aa'],['.','bb'],['[]',''],['.','y']]),
#     'x' => Dig.(struct, [['.', 'aa'],['.','bb'],['[]',''],['.','c'],['.','0'],['.','x']])
#   }
# ])

# 'ces' => arr('aa.bb', {

def arr(hash)
  hash
end

p('ces' => arr({
  'y' => Dig.(struct, SplitComs.('aa.bb[].y.z')),
  'x' => Dig.(struct, SplitComs.('aa.bb[].c.0.x'))
}))

'ces' => 'aa.bb[y.z%default]'