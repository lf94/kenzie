include <../config.scad>
use <./clip.scad>

module lip(dimensions, rotator_gap) {
  width = dimensions[0];
  depth = dimensions[1];
  height = dimensions[2];

  difference() {
    cube(
      [width, depth, height],
      center = true
    );
  }

  translate([
    width / -2.0,
    (depth / -2.0) - height,
    height / -2.0,
  ])
  rotator([depth, height], rotator_gap, RIGHT);

  translate([
    width / 2.0,
    (depth / -2.0) - height,
    height / -2.0,
  ])
  rotator([depth, height], rotator_gap, LEFT);

}

// Directions to create the proper rotator.
RIGHT = 0;
LEFT = 1;

module rotator(dimensions, rotator_gap, direction) {
  depth = dimensions[0];
  height = dimensions[1];
  width = (rotator_gap - stand_width(rotator_gap)) / 2.0;

  translate([-rotator_gap * direction, 0, 0]) 
  union() { 
    translate([(rotator_gap - width) * direction, 0, 0])
    union() {
      cube([width, height, height]);
      cube([width, height / 2.0, height * 2.0]);
      translate([0, height / 2.0, 0])
      cube([width, height / 2.0, height * 1.5]);

      rotate([0, 90, 0])
      translate([height * -1.5, height / 2.0, 0])
      cylinder(width, r = height / 2.0);
    }

    translate([
      rotator_gap / 2.0,
      height / 2.0,
      height * 1.5,
    ])
    rotate([0, 90, 0])
    cylinder(rotator_gap - (extrude * 8.0), r = height / 2.0, center = true);
  }
}
