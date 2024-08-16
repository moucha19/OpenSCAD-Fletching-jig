use <fletching_jig.scad>


// Quality of the generated round elements of the jig. Higher values will generate more polygons, smoother surfaces and slow down the computations.
$fn=30; // [10:10:100]
// Select which part of the jig you want to show
part_select_gui = 0; //[0:All, 1:Base only, 2:Arm only, 3:Lid only]

/* [Hidden] */
part_select_cmd = -1;
part_select = part_select_cmd < 0 ? part_select_gui : part_select_cmd;

/* [Style] */
// You can either have a snap-in ball joints a hole for external axle (like bolt or piece of filament).
hinge_style = "ball"; // [ "ball":Ball joint, "axle":Axle ]
// Style of the base.
base_style = "polygon"; // [ "polygon":Polygon, "star":Star ]
// Style of the lid.
lid_style = "polygon"; // [ "polygon":Polygon, "star":Star ]

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

// Diameter of the sphere that connects two halves of the hinge together. Maximum depends on both the hinge diameter and the space between hinge extensions. Larger values will provide more strength to the pivot. Smaller values will be easier to pop into place when assembling.
hinge_pin = 3.1;

// Gap for the vane foot in the arm so that the tension is distributed evenly on the vanes during clamping. This value will depend on your vanes. A value too small will clamp unevenly, a value too large will not clamp the vane.
arm_gap = 0.5;

// Distance between the top of the base and bottom of the arm.
arm_offset = 1.5;//[0.1:0.1:2]

// Alignment guide for nocked arrows. For even vane count, you can select if you want to align nock with index vane, or if you prefer to align it between vanes for optimal clearance. 
nock = "none"; // [ "none":Disabled, "static" : Index vane, "optimal":Optimal clearance]

// Width of the nock (measure smallest point)
nock_width = 3;//[1:0.1:5]

// Depth of the nock (height of the nock guide)
nock_depth = 4;//[1:0.1:10]

// Nock diameter. If it is larger than the arrow diameter, it will be used for the hole in the base, otherwise it has no effect.
nock_diameter = 0;//[2:0.1:30]

/* [Fletching] */

// Number of vanes.
vane_count = 3;//[2:1:5]

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
helical_direction = 1;//[1:Left, -1:Right]

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
        hinge_pin,
        arm_gap,
        arm_offset,
        vane_count,
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
        nock_diameter,
        hinge_style,
        base_style,
        lid_style
    );
