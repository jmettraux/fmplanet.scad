
//
// head.scad

// Copyright (C) 2024 John Mettraux jmettraux@gmail.com
//
// This work is licensed under the
// Creative Commons Attribution 4.0 International License.
//
// https://creativecommons.org/licenses/by/4.0/


h = 5; // height unit, 5mm
br = 1.7; // magnet ball radius
o2 = 0.2; // some kind of step

r = 20 / 2;
t = r / cos(30);
rr = r / 10;
//echo("r", r, "t", t);

module sphe() { sphere(r=rr, $fn=12); }
module balcyl() { cylinder(r=br + 2 * o2, h=br * 2 + o2, center=true, $fn=36); }

module hex(key, edge=false) {

  difference() {

    translate([ 0, 0, h * -0.5 ])
      hull()
        for (a = [ 0 : 60 : 300 ]) {
          rotate([ 0, 0, a ]) {
            translate([ 0, t - rr, h - rr ]) sphe();
            translate([ 0, t - rr, rr ]) sphe();
          }
        }

    if (edge) for (a = [ 30 : 60 : 330 ]) {
      #rotate([ 0, 0, a ]) translate([ 0, r - br - 4 * o2, 0 ]) balcyl();
    }
  }

  // TODO write key when debug
}

//hex(true);
//translate([ 2 * r, 0, 0 ]) hex(true);

module sea_hex(key, edge) {
  hex(key, edge);
}
module reef_hex(key, edge) {
  hex(key, edge);
}
module plain_hex(key, edge) {
  hex(key, edge);
}
module swamp_hex(key, edge) {
  hex(key, edge);
}
module mountain_hex(key, edge) {
  hex(key, edge);
}

