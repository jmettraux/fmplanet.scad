
#
# tile.rb

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

# P Plain
# S Sea
# M Mountain
# R Reef
# W sWamp

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

  class << self

    def to_k(x, y)

      y == nil ? x.to_s : "#{x}#{y}"
    end

    def to_xy(k)

      [ k[0, 1], k[1, 1].to_i ]
    end
  end
end


class Tile

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
end

t = Tile.new
#p t['a0'].key
#p t[:a1].key
#p t.typed_hexes
#p t.untyped_hexes

h = t[:b3]
p h.key
p h.nw.key
p h.sw.key

