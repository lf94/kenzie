// Retroid Pocket 2 Stand ⓒ Lee Fallat 2021
$fn = 100;

stand_thickness = 2.5;
stand_width = 142;
stand_height = 70;

stand_lip_length = 20;

kick_width = stand_width / 1.5;
kick_bottom_height = stand_height / 2.0;

// Allows many shapes to barely touch
epsilon = 0.05;

module capsule(height, thickness) {
    cylinder(height, thickness, thickness, center = true);
    translate([0, 0, height / 2.0])
        sphere(thickness);
    translate([0, 0, height / -2.0])
        sphere(thickness);
}



module face() {
    union() {
        // The front face of the stand
        cube([stand_width, stand_thickness, stand_height], center = true);
        
        // The foot of the stand
        translate([
            0,
            (stand_lip_length / 2.0) + (stand_thickness / 2.0),
               (stand_height / -2.0) + (stand_thickness / 2.0)
        ])
        cube([stand_width, stand_lip_length, stand_thickness], center = true);
    }
}

module kick_bottom() {
    difference() {
        union() {
            translate([0, 0, kick_bottom_height / -2.0])
                cube([kick_width, stand_thickness, stand_height / 2.0], center = true);

            translate([0, 0, (stand_thickness / 2.0) - epsilon])
            rotate([0, 90, 0])
                cylinder(kick_width, stand_thickness / 2.0, stand_thickness / 2.0, center = true);
        }
        
        for(a = [0 : 1 : 4]) {
            
        }
    }
}

module kick() {
    kick_bottom();
}

module stand() {
    translate([0, 10, 0])
        face();
    kick();
}

stand();