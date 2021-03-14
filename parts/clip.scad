include <../config.scad>

function width_e(width) = width - (extrude_width * 8.0);

function clip_female_height(radius) = (radius + (extrude_width / 2.0)) * 4.0;
function clip_female_width(width) =
  width_e(width) - (stand_width(width_e(width)) * 2.0) - (extrude * 2.0);

function clip_male_height(radius) = (radius * 2.0) + (radius * 2.0);
function clip_male_width(radius) = (radius * 2.0) + (radius * 2.0);

function stand_width(width) = width / 5.0;

module clip_male(width, radius) {
  cylinder_stand_width = stand_width(width);

  diameter = radius * 2.0;

  translate([0, 0, -radius + (clip_male_height(radius) / 2.0)])
  union() {
    // The pin to clip onto.
    translate([0, 0, 0])
    rotate([0, 90, 0])
    cylinder(width, r = radius, center = true);

    // Stands for the cylinder
    translate([
      (width / 2.0) - cylinder_stand_width,
      -radius,
      diameter * -1.5
    ]) 
    cube([cylinder_stand_width, diameter, diameter * 1.5]);

    translate([
      (width / -2.0),
      -radius,
      diameter * -1.5
    ]) 
    cube([cylinder_stand_width, diameter, diameter * 1.5]);
  }
}

module clip_female(width, radius) {
  additional_width = (extrude_width / 2.0);
  radius_e = radius + additional_width;
  inner_radius_e = radius + (additional_width / 2.0);

  diameter_e = radius_e * 2.0;

  clip_width = clip_female_width(width_e(width));

  // 28 is a tested, known to work value.
  clip_angle = 28;

  pincher_radius = radius / 5.0;
  pincher_y1 = sin(clip_angle) * -inner_radius_e;
  pincher_z1 = cos(clip_angle) * inner_radius_e;

  pincher_y2 = sin(clip_angle) * -pincher_radius;
  pincher_z2 = cos(clip_angle) * pincher_radius;

  union() {
    rotate([0, 0, 180])
    difference() {
      cube([
          clip_width,
          diameter_e * 2.0,
          diameter_e * 2.0
        ], center = true
      );

      // The "pinchers" for the pin to pass to be secure.
      translate([
        0,
        -pincher_y1,
        ((pincher_z1 + pincher_z2) - diameter_e) - (pincher_z1 + pincher_z2)
       ])
      cube([clip_width / 2.0, diameter_e, diameter_e * 2.0]);

      translate([
        clip_width / -2.0,
        -pincher_y1,
       ((pincher_z1 + pincher_z2) - diameter_e) - (pincher_z1 + pincher_z2)
       ])
      cube([clip_width / 2.0, diameter_e, diameter_e * 2.0]);

      // The inner cylinder which will hold the male clip.
      translate([0, 0, 0])
      rotate([0, 90, 0])
      cylinder(clip_width, r = inner_radius_e, center = true);
    }

    translate([0, pincher_y1 + pincher_y2, pincher_z1 + pincher_z2])
    rotate([0, 90, 0])
    cylinder(clip_width, r = pincher_radius, center = true);

    pincher_width = diameter_e - (pincher_z1 + pincher_z2);

    translate([0, pincher_y1 + pincher_y2, pincher_z1 + pincher_z2 + (pincher_width / 2.0)])
    cube([clip_width, pincher_radius * 2.0, pincher_width], center = true);

    translate([0, pincher_y1 + pincher_y2, -pincher_z1 - pincher_z2])
    rotate([0, 90, 0])
    cylinder(clip_width, r = pincher_radius, center = true);

    translate([0, pincher_y1 + pincher_y2, -(pincher_z1 + pincher_z2 + (pincher_width / 2.0))])
    cube([clip_width, pincher_radius * 2.0, pincher_width], center = true);
  }
}
