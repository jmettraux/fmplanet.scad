
#
# tile_scad.rb

# Copyright (C) 2024 John Mettraux jmettraux@gmail.com
#
# This work is licensed under the
# Creative Commons Attribution 4.0 International License.
#
# https://creativecommons.org/licenses/by/4.0/

require 'stringio'

$: << '.'
require 'lib/tile'


class Hex

  IXS = %i[ a b c d e f g ].freeze

  def translate

    ix = IXS.index(x)

    tx = "#{ix} * dx - #{y} * dx2"
    ty = "-#{y} * dy"

    "[ #{tx}, #{ty}, 0 ]"
  end

  def to_scad

    e = (y == 0) || (y == 6) || (x == :a) || (x == :g)

    #"/* #{key} */ " +
    "translate(#{translate}) #{type}_hex(\"#{key}\", #{e});"
  end
end

class Tile

  def to_scad

    s = StringIO.new

    s << "\n\n// .scad\n"
    s << File.read('lib/head.scad')
    s << "\n\n// " << "-" * 78
    s << "\n"
    s << "/*\n"
    s << to_s
    s << "\n*/\n\n"

    hexes.each do |k, h|
      s << h.to_scad << "\n"
#break if k == 'd0'
    end

    s << "\n"

    s.string
  end
end


if $0 == __FILE__

  t = Tile.new

  t.fill(
    :snakes,
    a0: :sea, f4: :plain, d6: :plain,
    sea: [ :sea, :sea, :reef ],
    reef: [ :reef, :reef, :sea, :sea, :swamp ],
    swamp: [ :swamp, :swamp, :plain, :mountain ],
    plain: [ :plain, :plain, :plain, :swamp, :mountain ],
    mountain: [ :mountain, :mountain, :mountain, :plain, :plain ],
    default: [ :reef, :swamp ])
  puts t.to_s

  File.open('out.scad', 'wb') { |f| f.write(t.to_scad) }
end

