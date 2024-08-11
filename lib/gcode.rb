
#
# gcode.rb
#
# ruby gcode.rb tile0.gcode > tile0b.gcode

# Copyright (C) 2024 John Mettraux jmettraux@gmail.com
#
# This work is licensed under the
# Creative Commons Attribution 4.0 International License.
#
# https://creativecommons.org/licenses/by/4.0/

fn = ARGV.find { |a| a.match(/^[^-].+\.gcode$/) }

fail "no .gcode filename provided" unless fn

after_layer_change = false

LAYER_CHANGES = {
  4.4 => :magnets,
  5.2 => :sea,
  5.8 => :plain,
  6.0 => :hill,
  6.4 => :mountain,
  7.6 => :top }

COLORS = {
  sea: '#0000FF',
  plain: '#D2B48C',
  hill: '#A89070',
  mountain: '#707070',
  top: '#F5F5DC' }

lines = File.readlines(fn)

loop do

  line = lines.shift; break unless line
  line = line.rstrip

  if line == ';AFTER_LAYER_CHANGE'

    puts line

    alt_line = lines.shift
    puts alt_line
    alt = alt_line[1..-1].to_f

    change = LAYER_CHANGES[alt]
    color = COLORS[change]

    if change == :magnets
      puts ';PAUSE_PRINT'
      puts 'M117 place fmplanet magnets...'
      puts 'M601'
      puts lines.shift
      ## M73 C34
      ## M73 D38
        # `M73 C34`: sets remaining time for the current layer to 34'
        # `M73 D38`: sets the total remaining time for the print to 38'
      # continue...
    elsif color
      loop do
        l = lines.shift
        if l.match(/^G1 E\.\d+ F\d+$/)
          puts 'G1 E0.3 F1500 ; prime after color change'
          break
        end
        puts l
      end
      puts ";COLOR_CHANGE,T0,#{color}"
      puts 'M600'
    end
  else
    puts line
  end
end

puts "\n;\n; /fpmplanet.scad"

### ;AFTER_LAYER_CHANGE
### ;5.2
### ; printing object tile1.stl id:0 copy 0
### G1 Z5.4
### G1 X83.772 Y127.629 F12000
### G1 Z5.2 F720
### G1 E.8 F1500
### ;TYPE:Perimeter

#######################

#  ;AFTER_LAYER_CHANGE
#  ;5.4
#  G1 X103.872 Y152.053
#  G1 Z5.4 F720
## G1 E.7 F1500
#  ;TYPE:Perimeter
#  ;WIDTH:0.449999

#  ;AFTER_LAYER_CHANGE
#  ;5.4
#  G1 X103.872 Y152.053
#  G1 Z5.4 F720
## ;COLOR_CHANGE,T0,#5DB022
## M600
## G1 E0.3 F1500 ; prime after color change
#  ;TYPE:Perimeter
#  ;WIDTH:0.449999

#######################

#  ;AFTER_LAYER_CHANGE
#  ;4.4
#  G1 X125.923 Y93.806
#  G1 Z4.4 F720
#  G1 E.7 F1500
#  ;TYPE:Perimeter
#  ;WIDTH:0.449999

#  ;AFTER_LAYER_CHANGE
#  ;4.4
## ;PAUSE_PRINT
## M117 place magnets...
## M601
#  G1 X125.923 Y93.806
## M73 C34
## M73 D38
#  G1 Z4.4 F720
#  G1 E.7 F1500
#  ;TYPE:Perimeter
#  ;WIDTH:0.449999

#######################

# G1     This is the command for a linear move.
# E0.3   This is specifying the amount to extrude. It's instructing the
#        extruder to push 0.3 units of filament.
# F1500  This sets the feed rate, or the speed of the movement. Here, it's
#        set to 1500 units per minute.

