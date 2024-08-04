
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
echo("r", r, "t", t);

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

  //#translate([ 0, 0, h * 2 ]) linear_extrude(0.4) text(key, size=8);
}

module int_hex(hh, hr=t - 2 * o2) {
  translate([ 0, 0, -hh ])
    rotate([ 0, 0, 30 ])
      cylinder(r=hr, h=2 * hh, $fn=6);
}
module int_cyl(ch) {
  translate([ 0, 0, -ch ])
    cylinder(r=r - 5 * o2, h=2 * ch, $fn=24);
}

module blobs(xyrs, bh, shape="hex") {
  intersection() {
    if (shape == "hex") int_hex(bh);
    else if (shape == "hex2") int_hex(bh, t - 14 * o2);
    else int_cyl(bh);
    for (i = [ 0 : len(xyrs) - 1 ]) {
      a = xyrs[i];
      b = xyrs[i + 1];
      hull() {
        translate([ a.x, a.y, 0 ])
          cylinder(h=bh, r=a.z, center=true, $fn=12);
        if (b) translate([ b.x, b.y, 0 ])
          cylinder(h=bh, r=b.z, center=true, $fn=12);
      }
    }
  }
}

module holes(xyrs, bh) {
  for (xyr = xyrs) {
    translate([ xyr.x, xyr.y, - 0.5 * bh ])
      cylinder(h=bh * 2, r=xyr.z, center=true, $fn=12);
  }
}

module sea_hex(key, edge) {
  hex(key, edge);
  translate([ 0, 0, h / 2 ]) color("blue") int_hex(2 * o2);
}
module plain_hex(key, edge) {
  hex(key, edge);
  translate([ 0, 0, 0.5 * h ]) color("blue") int_hex(2 * o2);
  translate([ 0, 0, 0.5 * h + 2 * o2 ]) int_hex(2 * o2);
}
module mountain_hex(key, edge) {
  hex(key, edge);
  translate([ 0, 0, 0.5 * h ])
    rotate([ 0, 0, 30 ]) color("grey")
      cylinder(r1=t - 2 * o2, r2=t - 14 * o2, h=0.5 * h, $fn=6);
}

dx = 2.0 * r + 0.5 * o2;
dy = 1.5 * t + 0.5 * o2;
dx2 = dx / 2;

//        a0  b0  c0  d0
//
//      a1  b1  c1  d1  e1
//
//    a2  b2  c2  d2  e2  f2
//
//  a3  b3  c3  d3  e3  f3  g3
//
//    b4  c4  d4  e4  f4  g4
//
//      c5  d5  e5  f5  g5
//
//        d6  e6  f6  g6

// --- TEST ---

blobs([ [ 0, 0, r * 0.4 ] ], 1.0, "hex");

