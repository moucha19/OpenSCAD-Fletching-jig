use <fletching_jig.scad>


// increase to improve render quality
fn=30; // [10:10:100]
part_select = 0; //[0:All, 1:Base only, 2:Arm only, 3:Lid only]

/* [Jig settings] */

arrow_diameter = 6;//[2:0.1:30] 

//distance between the bottom of the base and arrow
arrow_offset = 3;//[0:0.1:100] 

base_height = 20;//[0:0.1:100]

hinge_width = 6.5;//[0:0.1:30]  

//thickness of the hinge extension attached to the bottom of the arm
hinge_thickness = 1.5;

//diameter of the hinge's circular part
hinge_diameter = 5.1;

//how deep into base is the hinge cutout
hinge_depth = 10.1;

//diameter of the sphere that connects two halves of the hinge together 
hinge_pin = 3.1;

//gap for the vane foot
arm_gap = 0.5;     

//distance between the top of the base and bottom of the arm
arm_offset = 1.5;

/* [Fletching] */

vane_length = 72.1;//[0:0.1:200] 

vane_width = 1.1;//[0:0.1:10] 

//how far from the end of arrow will the vane be
vane_offset = 25.1;//[0:0.1:200] 

//select vane style
helical = 0;//[0:Offset, 1:Helical]

//sets offset fletching in degrees
vane_turn = 0;// [-30:0.1:30]

//horizontal distance between the bottom and top corner of the helical vane
helical_adjust = 3.5; //[0:0.1:40]

helical_direction = 1;//[1:left, -1:right]

$fn = fn;
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
        vane_length, 
        vane_width, 
        vane_offset,
        vane_turn,
        helical,
        helical_adjust,
        helical_direction,
        fn
    );

