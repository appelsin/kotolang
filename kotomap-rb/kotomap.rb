class Kotomap
  def self.call(input, mapping)

  end

  # def self.parse(input, path, symbol: false, indifferent: false)
  #   list = []
  #   current = ''
  #   state = :inc
  #   path.each_char do |char|
  #     if :escape == state
  #       current+= char
  #       state = :inc
  #     elsif :array_opened == state && ']' == char
        
  #     elsif '\\' == char
  #       state = :escape
  #     elsif '[' == char
  #       state = :array_opened
  #     elsif '.' == char
  #       list << current
  #       current = ''
  #     else
  #       current+= char
  #     end
  #     prev = char
  #   end
  #   list << current
  #   list
  # end

  def self.extract(m, v, symbol: false, indifferent: false)
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

  def self.v2(input, path, symbol: false, indifferent: false)
    path.split(/(?<!\\)\[\]\./).reduce([input]) do |m, v|
      x = m.map do |m2|
        value(m2, v, symbol: symbol, indifferent: indifferent)
      end
      p 'xc' => x
      x
    end
  end

  def self.value(input, path, symbol: false, indifferent: false)
    path.split(/(?<!\\)[\[\.]/).reduce(input) do |m, v|
      if ']' == v
        x = m.map do |input2|
          value(input2, 'id', symbol: symbol, indifferent: indifferent)
        end
        p x
        {'id' => x}
      else
        extract(m, v, symbol: symbol, indifferent: indifferent)
      end
    end
  end
end

struct = {
  'a' => { 
    'b' => [
      {'id' => 1},
      {'id' => 2},
      {'x' => 3}
    ]
  }
}

# p Kotomap.value(struct['a'][1], 'id')

p Kotomap.v2(struct, 'a.b[].id')
p Kotomap.value(struct, 'a.b[].id')

# struct = {
#   'a' => {
#     'x' => 'v',
#     'd' => {
#       't' => [1,3,{'a' => 4}]
#     },
#     'd.t' => 'dt'
#   },
#   :a => {
#     :x => 'sym'
#   }
# }


# # p Kotomap.parse(struct, 'a.x')

# p Kotomap.value(struct, 'a.x')
# p Kotomap.value(struct, 'a.y')
# p Kotomap.value(struct, 'b.x')
# p Kotomap.value(struct, 'a.d.t.2.a')

# p ['dt', Kotomap.value(struct, 'a.d\.t')]
# p 'a.d_.t'.split(/(?<!\\)\./)

# p Kotomap.value(struct, 'a.x', symbol: true)
# p Kotomap.value(struct, 'a.x', indifferent: true)

# 'ads'.each_char do |x|
#   p x
# end