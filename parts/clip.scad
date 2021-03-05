include <../constants.scad>

function clip_male_height(radius) = (radius * 2.0) + (radius * 2.0);
function clip_female_height(radius) = radius * 3.0;
function stand_width(width) = width / 5.0;

module clip_male(width, radius) {
  cylinder_stand_width = stand_width(width);

  translate([0, 0, -radius + (clip_male_height(radius) / 2.0)])
  union() {
    translate([0, 0, 0])
    rotate([0, 90, 0])
    cylinder(width, r = radius, center = true);

    translate([0, 0, radius * -2.0])
    difference() {
      cube([width, radius * 2.0, radius * 2.0], center = true);

      translate([width / -2.0, -radius, 0])
      cube([width, radius * 2.0, radius * 2.0]);
    }

    // Stands for the cylinder
    translate([
      (width / 2.0) - cylinder_stand_width,
      -radius,
      radius * -2.0
    ]) 
    cube([cylinder_stand_width, radius * 2.0, radius * 2.0]);

    translate([
      (width / -2.0),
      -radius,
      radius * -2.0
    ]) 
    cube([cylinder_stand_width, radius * 2.0, radius * 2.0]);
  }
}

module clip_female(width, radius) {
  cylinder_stand_width = stand_width(width);

  rotate([0, 0, 180])
  difference() {
    cube([
        width - (cylinder_stand_width * 2.0) - (extrude * 2.0),
        radius * 3.0,
        radius * 3.0
      ], center = true
    );

    translate([0, radius, 0])
    cube([width, radius * 2.0, radius * 1.66], center = true);

    // The "pinchers" for the pin to pass to be secure.
    translate([0, (extrude * 4.0), radius * -1.5])
    cube([width / 2.0, radius * 2.0, radius * 3.0]);

    translate([width / -2.0, (extrude * 4.0), radius * -1.5])
    cube([width / 2.0, radius * 2.0, radius * 3.0]);


    translate([0, 0, 0])
    rotate([0, 90, 0])
    cylinder(width, r = radius, center = true);
  }
}
