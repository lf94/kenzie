include <../config.scad>

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
  additional_width = (extrude_width / 2.0);
  radius_e = radius + additional_width;
  width_e = width - (extrude_width * 8.0);

  cylinder_stand_width = stand_width(width_e);
  clip_width = width_e - (cylinder_stand_width * 2.0) - (extrude * 2.0);

  translate([0, -additional_width, 0])
  union() {
    rotate([0, 0, 180])
    difference() {
      cube([
          clip_width,
          radius_e * 4.0,
          radius_e * 4.0
        ], center = true
      );

      // The "pinchers" for the pin to pass to be secure.
      translate([0, radius_e / 2.0, radius_e * -2.0])
      cube([clip_width / 2.0, radius_e * 2.0, radius_e * 4.0]);

      translate([clip_width / -2.0, radius_e / 2.0, radius_e * -2.0])
      cube([clip_width / 2.0, radius_e * 2.0, radius_e * 4.0]);

      translate([0, 0, 0])
      rotate([0, 90, 0])
      cylinder(clip_width, r = radius_e, center = true);
    }

    // The tips of the "pinchers".
    rotate([0, 90, 0])
    translate([-radius_e, radius_e / -1.5, 0])
    cylinder(clip_width, r = radius_e / 5.0, center = true);

    translate([0, radius_e / -1.5, radius_e * 1.5])
    cube([clip_width, radius_e / 2.5, radius_e], center = true);

    rotate([0, 90, 0])
    translate([radius_e, radius_e / -1.5, 0])
    cylinder(clip_width, r = radius_e / 5.0, center = true);

    translate([0, radius_e / -1.5, radius_e * -1.5])
    cube([clip_width, radius_e / 2.5, radius_e], center = true);
  }
}
