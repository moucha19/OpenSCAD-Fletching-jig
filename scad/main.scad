use <fletching_jig.scad>

$fn=50;

//6 mm arrow - straight

jig (   arrow_diameter = 6,
        arrow_offset = 3,
        base_height = 20,
        hinge_width = 6.5, 
        hinge_diameter = 5,
        hinge_depth = 10,
        hinge_pin = 3,
        arm_gap = 0.5,         
        arm_offset = 1.5,
        vane_length = 72, 
        vane_width = 1.1, 
        vane_offset = 25,
        vane_turn = 0,
        helical = false,
        helical_adjust = 0.5,
        helical_direction = 1
    );

//8 mm arrow - helical right

*jig (   arrow_diameter = 8,
        arrow_offset = 3,
        base_height = 20,
        hinge_width = 6.5, 
        hinge_diameter = 5,
        hinge_depth = 10,
        hinge_pin = 3,
        arm_gap = 0.5,         
        arm_offset = 1.5,
        vane_length = 72, 
        vane_width = 1.1, 
        vane_offset = 25,
        vane_turn = 0,
        helical = true,
        helical_adjust = 2.2,
        helical_direction = -1
    );
