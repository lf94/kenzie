//
// Global configuration parameters
//

// Extrusion height (profile) for 3D printers in millimeters.
// Uses the common height of 0.2mm.
profile = 0.2;

// Extrusion width (nozzle diameter)  for 3D printers in millimeters.
// Use the common width of 0.4mm.
nozzle_diameter = 0.4;

// Number of fragments to use when generating smooth surfaces.
$fn = 40;

//
// Choose which parts you want to render.
// Use -D in OpenSCAD to pass which parts you want to render.
//

all = true;
face = false;
lip = false;
arm = false;
kick = false;
hinge = false;

