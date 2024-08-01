
#
# tile_scad.rb

# Copyright (C) 2024 John Mettraux jmettraux@gmail.com
#
# This work is licensed under the
# Creative Commons Attribution 4.0 International License.
#
# https://creativecommons.org/licenses/by/4.0/

SCAD = File.read('lib/head.scad')
VARIANT_COUNT = 12
R = Kernel.eval(SCAD.match(/^r = ([^;]+);/)[1])
D = R.to_f * 2.0
D2 = D / 2.0
D4 = D / 4.0

require 'stringio'

$: << '.'
require 'lib/tile'


class Range

  def sample; to_a.sample; end
end

class Array

  def to_scad
    s = StringIO.new
    s << "[ "
    s << collect { |e|
      case e
      when Float then "%.3f" % e
      when Array then e.to_scad
      else e.inspect; end }.join(', ')
    s << " ]"
    s.string
  end
end


class Hex

  IXS = %i[ a b c d e f g ].freeze

  def translate

    ix = IXS.index(x)

    tx = "#{ix} * dx - #{y} * dx2"
    ty = "-#{y} * dy"

    "[ #{tx}, #{ty}, 0 ]"
  end

  def to_scad

    s = StringIO.new

    e =
      y == 0 || y == 6 || x == :a || x == :g ||
      key == :b4 || key == :c5 ||
      key == :e1 || key == :f2
    suff =
      type == :sea ? '' :
      "_#{(0..(VARIANT_COUNT - 1)).sample}"

    s << "/* #{key} */  "
    s << "translate(#{translate}) { "
    s << "#{type}_hex#{suff}(\"#{key}\", #{e}); "

    s << "}"

    s.string
  end
end

class Tile

  def to_scad

    s = StringIO.new

    s << "\n\n// .scad\n"
    s << SCAD
    s << "\n" << "/" * 80
    s << "\n"

    s << "\n/*" << to_s.rstrip << "\n*/\n\n"

    s << reef_scad << "\n"
    s << swamp_scad << "\n"
    s << plain_scad << "\n"
    s << mountain_scad << "\n"

    s << "translate([ -3 * dx + 3 * dx2, 3 * dy, 0 ]) {\n\n"

    hexes.each do |k, h|
      s << '  ' << h.to_scad << "\n"
    end

    s << "}\n"

    s.string
  end

  protected

  def rnd_xyr
    [ -D2 + rand * D, -D2 + rand * D,
      rand * D4 * 0.6 ]
  end

  def next_xyr(xyr0)
    [ xyr0[0] + - D4 + rand * D2, xyr0[1] - D4 + rand * D2,
    rand * D4 * 0.6 ]
  end

  def xyr_chain(len)
    a = [ rnd_xyr ]
    while a.length < len
      a << next_xyr(a.last)
    end
    a
  end

  def reef_scad
    s = StringIO.new
    VARIANT_COUNT.times.each do |i|
      s << "module reef_hex_#{i}(key, edge) { "
      s << "  sea_hex(key, edge);\n"
      (4..9).sample.times do |bi|
        ps = xyr_chain((1 + rand * 3).to_i)
        s << "  blob(#{ps.to_scad}, o2 * 2, o2 + o2 * 0.5, \"circle\");\n"
      end
      s << "}\n"
    end
    s.string
  end

  def plain_scad
    s = StringIO.new
    VARIANT_COUNT.times.each do |i|
      s << "module plain_hex_#{i}(key, edge) {}\n"
    end
    s.string
  end

  def swamp_scad
    s = StringIO.new
    VARIANT_COUNT.times.each do |i|
      s << "module swamp_hex_#{i}(key, edge) {}\n"
    end
    s.string
  end

  def mountain_scad
    s = StringIO.new
    VARIANT_COUNT.times.each do |i|
      s << "module mountain_hex_#{i}(key, edge) {}\n"
    end
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
  #t.fill(:all, type: :sea)

  puts t.to_s

  File.open('out.scad', 'wb') { |f| f.write(t.to_scad) }
end

