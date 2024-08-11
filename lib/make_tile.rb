
#
# make_tile.rb

# Copyright (C) 2024 John Mettraux jmettraux@gmail.com
#
# This work is licensed under the
# Creative Commons Attribution 4.0 International License.
#
# https://creativecommons.org/licenses/by/4.0/

$: << '.'
require 'lib/tile_scad'


t = Tile.new

#t.fill(
#  :snakes,
#  f4: :plain, d6: :plain,
#  sea: [ :sea, :sea, :reef ],
#  reef: [ :reef, :reef, :sea, :sea, :swamp ],
#  swamp: [ :swamp, :swamp, :plain, :mountain ],
#  plain: [ :plain, :plain, :plain, :swamp, :mountain ],
#  mountain: [ :mountain, :mountain, :mountain, :plain, :plain ],
#  default: [ :reef, :swamp ])
#t.fill(:all, type: [ :plain, :plain, :plain, :plain, :plain, :swamp ])
#t.fill(:all, type: :sea)
#t.parse(%{
#     - o - -
#    - - o - -
#   - - - o o o
#  : - - - o - o
#   : : - - o -
#    _ : - - o
#     : - - -
#  })
t.parse(%{
     - o - -
    ^ - o - -
   - ^ - o o o
  : - ^ ^ o - o
   : : - - ^ o
    _ : - - o
     : - - -
  })

puts t.to_s

fn = 'out.scad'
File.open(fn, 'wb') { |f| f.write(t.to_scad) }
puts "wrote to #{fn}\n\n"

