use <fletching_jig.scad>


// Quality of the generated round elements of the jig. Higher values will generate more polygons, smoother surfaces and slow down the computations.
$fn=30; // [10:10:100]
// Select which part of the jig you want to show
part_select_gui = 0; //[0:All, 1:Base only, 2:Arm only, 3:Lid only, 4:Base+Lid]

/* [Hidden] */
part_select_cmd = -1;
part_select = part_select_cmd < 0 ? part_select_gui : part_select_cmd;

/* [Jig settings] */

// Your arrow diameter. This number should be slightly bigger than the arrow itself to take into account the precision of your printer.
arrow_diameter = 6;//[2:0.1:30]

// Distance between the bottom of the base and arrow. A smaller offset will restrict the vane offset as the arrow will be deeper into the base.
arrow_offset = 3;//[0:0.1:100]

// Height of the base.
base_height = 20;//[0:0.1:100]

// Width of the hinge cutout on the base. The maximum value will depend on the arrow diameter.
hinge_width = 6.5;//[0:0.1:30]

// Thickness of the hinge extension attached to the bottom of the arm. The maximum value depends on the hinge width. A larger hinge will be harder to assemble.
hinge_thickness = 1.5;

// Diameter of the hinge's circular part. A larger value will produce larger arms. The maximum value is the hinge depth.
hinge_diameter = 5.1;

// How deep into base is the hinge cutout. The maximum value is the base height. Smaller values will be harder to assemble as the arms will be less flexible.
hinge_depth = 10.1;

// Diameter of the sphere that pivots the halves of the hinge. Maximum depends on both the hinge diameter and the space between hinge extensions. Larger values will provide more strength to the pivot. Smaller values will be easier to pop into place when assembling. See hinge holes below.
hinge_pin_diameter = 3.1;

// Makes holes for a pin or bolt rather than a sphere pivot for the hinge. You can use a bit of filament as the pin. If so, recommend hinge_pin_diameter 2.5 for 1.75mm filament
hinge_holes = false;

// Gap for the vane foot in the arm so that the tension is distributed evenly on the vanes during clamping. This value will depend on your vanes. A value too small will clamp unevenly, a value too large will not clamp the vane.
arm_gap = 0.5;

// Distance between the top of the base and bottom of the arm.
arm_offset = 1.5;//[0.1:0.1:2]

// nock for aligning wooden arrows that have a carved-in nock
nock = true;

// Width of the nock (measure smallest point)
nock_width = 3;//[1:0.1:5]

// Depth of the nock (height of the nock guide)
nock_depth = 4;//[1:0.1:10]

/* [Fletching] */

// Length of the vane.
vane_length = 72.1;//[0:0.1:200]

// Width of the vane.
vane_width = 1.1;//[0:0.1:10]

// How far from the end of arrow will the vane be. The minimal value will depend on the arrow offset, the base height and the arm offset.
vane_offset = 25.1;//[0:0.1:200]

//Select vane style
helical = 0;//[0:Offset, 1:Helical]

// Offset of the fletching in degrees. The maximum value will depend on the arrow radius, the fletching width, the fletching length as well as the arm gap. This value is ignored if the helical option is chosen.
vane_turn = 0;// [-30:0.1:30]

// Horizontal distance between the bottom and top corner of the helical vane. This value is only used if helical fletching is enabled. The maximum value depends on the arrow radius and the arm gap.
helical_adjust = 3.5; //[0:0.1:30]

// Direction of the helical fletching and thus the arrow spin direction.
helical_direction = 1;//[1:left, -1:right]

// Whether the base (and lid) have joined up edges making hexagon like shape not tricorn. Tricorn shape is better for using hinge pins or screws. 
hulled_base = false;



// Verbose info for command line rendering
if (part_select_cmd != -1)
{
    echo(str("Selected part = ", part_select));
    echo(str("Arrow diameter = ", arrow_diameter));
    echo(str("Vane turn style = ", helical == 1 ? "Helical" : "Offset"));
}

jig (
        part_select,
        arrow_diameter,
        arrow_offset,
        base_height,
        hinge_width,
        hinge_thickness,
        hinge_diameter,
        hinge_depth,
        hinge_pin_diameter,
        arm_gap,
        arm_offset,
        vane_length,
        vane_width,
        vane_offset,
        vane_turn,
        helical,
        helical_adjust,
        helical_direction,
        nock,
        nock_width,
        nock_depth,
        helical_direction,
        hulled_base,
        hinge_holes
    );
