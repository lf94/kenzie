use <./hinge.scad>

module arm(width, depth, height) {
  stub_x = width / 3.0;
  stub_y = depth / 2.0;
  stub_z = (height / -2.0) + (depth * 2.0);
  stub_ds = [(width / 3.0), depth, depth * 4.0];

  translate([0, 0, -depth])
  union() {
    translate([0, 0, (height / 2.0)])
    pin(width, depth / 2.0);

    difference() {
      // The whole flat of the arm.
      cube([width, depth, (height - (depth * 2.0))], center = true);

      // The cuts to make the stub of the arm.
      translate([0, 0, -stub_y])
      union() {
        translate([stub_x, 0, stub_z])
        cube(stub_ds, center = true);
        translate([-stub_x, 0, stub_z])
        cube(stub_ds, center = true);
      }

      // A horizontal cut so the stub fits into the kick cuts.
      translate([0, stub_y, stub_z - stub_y])
      cube(stub_ds, center = true);
    }
  }
}
