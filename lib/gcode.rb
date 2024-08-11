
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

File.readlines(fn).each do |line|

  line = line.rstrip
  if (
    line == '' ||
    line.match(/^\s*;/)
  ) then
    puts line
  else
  end
end

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

# G1     This is the command for a linear move.
# E0.3   This is specifying the amount to extrude. It's instructing the
#        extruder to push 0.3 units of filament.
# F1500  This sets the feed rate, or the speed of the movement. Here, it's
#        set to 1500 units per minute.

