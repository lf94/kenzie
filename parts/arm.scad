use <./clip.scad>

module arm(width, depth, height) {
  translate([0, 0, -depth])
  union() {
    translate([0, 0, (height / 2.0)])
    clip_male(width, depth / 2.0);

    difference() {
      cube(
        [width, depth, (height - (depth * 2.0))],
        center = true
      );

      translate([0, 0, depth / -2.0])
      union() {
        translate([width / 3.0, 0, (height / -2.0) + (depth * 2.0)])
        cube(
          [(width / 3.0), depth, depth * 4.0],
          center = true
        );
        translate([width / -3.0, 0, (height / -2.0) + (depth * 2.0)])
        cube(
          [(width / 3.0), depth, depth * 4.0],
          center = true
        );
      }

      translate([0, depth / 2.0, ((height / -2.0) + (depth * 2.0) - (depth / 2.0))])
      cube(
        [(width / 3.0), depth, depth * 4.0],
        center = true
      );
    }
  }
}
