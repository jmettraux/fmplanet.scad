
#
# tile.rb



class String

  MINUSES = {
    'b' => 'a', 'c' => 'b', 'd' => 'c', 'e' => 'd', 'f' => 'd', 'g' => 'f' }
  PLUSES = MINUSES
    .inject({}) { |h, (k, v)| h[v] = k; h }

  def -(i); MINUSES[self]; end
  def +(i); PLUSES[self]; end
end

class Hex

  attr_reader :tile
  attr_reader :key
  attr_accessor :type

  def initialize(tile, key, type=nil)

    @tile = tile
    @key = key
    @type = type
  end

  def x; Hex.to_xy(@key)[0]; end
  def y; Hex.to_xy(@key)[1]; end

  def nw; @tile[x - 1, y - 1]; end
  def ne; @tile[x, y - 1]; end
  def w; @tile[x - 1, y]; end
  def e; @tile[x + 1, y]; end
  def sw; @tile[x, y + 1]; end
  def se; @tile[x + 1, y + 1]; end

  def surroundings

    [ e, se, sw, w, nw, ne ]
  end

  def neighbours

    surroundings.compact
  end

  def untyped_neighbours

    neighbours.select { |h| h.type == nil }
  end

  class << self

    def to_k(x, y=nil)

      y == nil ? x.to_s : "#{x}#{y}"
    end

    def to_xy(k)

      [ k[0, 1], k[1, 1].to_i ]
    end
  end
end


class Tile

  KEYS =
    %w{
          a0  b0  c0  d0

        a1  b1  c1  d1  e1

      a2  b2  c2  d2  e2  f2

    a3  b3  c3  d3  e3  f3  g3

      b4  c4  d4  e4  f4  g4

        c5  d5  e5  f5  g5

          d6  e6  f6  g6
    }

  TYPES = {
    '-' => :plain,
    '_' => :sea,
    '^' => :mountain,
    ':' => :reef,
    'o' => :swamp}
      .inject({}) { |h, (k, v)| h[k] = v; h[v] = k; h[v.to_s] = k; h }

  attr_reader :hexes

  def initialize

    @hexes = KEYS.inject({}) { |h, k| h[k] = Hex.new(self, k); h }
  end

  def [](x, y=nil)

    @hexes[Hex.to_k(x, y)]
  end

  def typed_hexes

    @hexes.values.select { |h| h.type }
  end

  def untyped_hexes

    @hexes.values.select { |h| ! h.type }
  end

  def to_s

    t = lambda { |k| TYPES[@hexes[Hex.to_k(k)].type] || '?' }

    "
     #{t[:a0]} #{t[:b0]} #{t[:c0]} #{t[:d0]}
    #{t[:a1]} #{t[:b1]} #{t[:c1]} #{t[:d1]} #{t[:e1]}
   #{t[:a2]} #{t[:b2]} #{t[:c2]} #{t[:d2]} #{t[:e2]} #{t[:f2]}
  #{t[:a3]} #{t[:b3]} #{t[:c3]} #{t[:d3]} #{t[:e3]} #{t[:f3]} #{t[:g3]}
   #{t[:b4]} #{t[:c4]} #{t[:d4]} #{t[:e4]} #{t[:f4]} #{t[:g4]}
    #{t[:c5]} #{t[:d5]} #{t[:e5]} #{t[:f5]} #{t[:g5]}
     #{t[:d6]} #{t[:e6]} #{t[:f6]} #{t[:g6]}
    "
  end

  def unfill

    @hexes.values.each { |h| h.type = nil }
  end

  def fill(strategy_name, opts={})

    send("fill_#{strategy_name}", opts)
  end

  protected

  def fill_all(opts)

    t = opts[:type] || :plain

    @hexes.values.each { |h| h.type = t }
  end

  def fill_snakes(opts)

    unfill

    heads = []

    opts.each { |k, v|
      next unless TYPES[v]
      h = self[k]; next unless h
      heads << h
      h.type = v }

    while heads.any?

      h = heads.sample
      heads.delete(h)
      h1 = h.untyped_neighbours.sample

      next if h1.nil?

      h1.type = h.type
      heads << h1
    end

    untyped_hexes.each do |h|

      h.type = opts[:default] || :plain
    end
  end

  class << self

    def parse(s)

      t = Tile.new

      ts = s.strip.split(/\s+/).collect { |t| TYPES[t] }
      t.hexes.values.each_with_index { |h, i| h.type = ts[i] }

      t
    end
  end
end

t = Tile.new
#p t['a0'].key
#p t[:a1].key
#p t.typed_hexes
#p t.untyped_hexes

#h = t[:b3]
#p h.key
#p h.nw.key
#p h.sw.key

t = Tile.parse(%{
    - - - -
   ^ ^ - _ _
  ^ ^ - o o :
 _ o o - _ : :
  _ - - _ _ :
   _ - ^ _ _
    _ _ _ _
})

#pp t.hexes.inject({}) { |h, (k, v)| h[k] = v.type; h }
puts t.to_s

t.fill(:all, type: :plain)
puts t.to_s

t.fill(:snakes, a0: :sea, f4: :plain, d6: :mountain, default: :reef)
puts t.to_s

