include <../config.scad>
use <./hinge.scad>

function stub_width(width) = (width - stand_width(width)) / 2.0;

// Directions to create the proper rotator.
RIGHT = 0;
LEFT = 1;

module lip(dimensions, rotator_gap) {
  width = dimensions[0];
  depth = dimensions[1];
  height = dimensions[2];

  rotator_x = width / 2.0;
  rotator_y = (depth / -2.0) - height;
  rotator_z = height / -2.0;
  
  rotator_ds = [depth, height];

  gap_y = rotator_y + height;
  gap_z = rotator_z;

  rotator_gap_ds = [
    rotator_gap - stub_width(rotator_gap),
    height / 2.0,
    height
  ];

  difference() {
    cube(dimensions, center = true);

    translate([-rotator_x + stub_width(rotator_gap), gap_y, gap_z])
    cube(rotator_gap_ds);

    translate([rotator_x - stub_width(rotator_gap) * 2.5, gap_y, gap_z])
    cube(rotator_gap_ds);
  }

  translate([-rotator_x, rotator_y, rotator_z])
  rotator(rotator_ds, rotator_gap, RIGHT);

  translate([rotator_x, rotator_y, rotator_z])
  rotator(rotator_ds, rotator_gap, LEFT);
}

module rotator(dimensions, rotator_gap, direction) {
  depth = dimensions[0];
  height = dimensions[1];
  width = stub_width(rotator_gap);

  height_half = height / 2.0;

  translate([-rotator_gap * direction, 0, 0]) 
  union() { 
    translate([(rotator_gap - width) * direction, 0, 0])
    union() {
      cube([width, height, height]);
      cube([width, height_half, height * 2.0]);
      translate([0, height_half, 0])
      cube([width, height_half, height * 1.5]);

      rotate([0, 90, 0])
      translate([height * -1.5, height_half, 0])
      cylinder(width, r = height_half);
    }

    translate([
      rotator_gap / 2.0,
      height_half,
      height * 1.5,
    ])
    rotate([0, 90, 0])
    cylinder(rotator_gap - (profile * 8.0), r = height_half, center = true);
  }
}
