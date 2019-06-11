use <fletching_jig.scad>


// render resolution
$fn=10; // [10:10:100]

/* [Jig settings] */

arrow_diameter = 6; 

//distance between the bottom of the base and arrow
arrow_offset = 3;

base_height = 20;

hinge_width = 6.5;//[0:0.1:15]   

//diameter of the hinge's circular part
hinge_diameter = 5;

//how deep into base is the hinge cutout
hinge_depth = 10;

//diameter of the sphere that connects two halves of the hinge together 
hinge_pin = 3;

//gap for the vane foot
arm_gap = 0.5;//[0:0.1:5]     

//distance between the top of the base and bottom of the arm
arm_offset = 1.5;

/* [Fletching] */

vane_length = 72; 

vane_width = 1.1; 

//how far from the end of arrow will the vane be
vane_offset = 25;

//sets offset fletching in degrees
vane_turn = 0;// [-30:0.1:30]

//if true, helical fletching will be used
helical = false;

//horizontal distance between the bottom and top corner of the helical vane
helical_adjust = 3.5; //[0:0.1:30]

helical_direction = 1;//[1:left, -1:right]

jig (
        arrow_diameter,
        arrow_offset,
        base_height,
        hinge_width, 
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
        helical_direction
    );

