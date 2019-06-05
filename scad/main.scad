use <fletching_jig.scad>

$fn=20;

//6 mm arrow

jig (   arrow_diameter = 6,
        arrow_offset = 3,
        base_height = 20,
        hinge_width = 6.5, 
        hinge_diameter = 5,
        hinge_depth = 10,
        hinge_pin = 2.4,
        arm_gap = 0.5,         
        arm_offset = 1.5,
        vane_length = 75, 
        vane_width = 1, 
        vane_offset = 25,
        vane_turn = 0,
        helical = false,
        helical_adjust = 0.5,
        helical_direction = 1
    );
