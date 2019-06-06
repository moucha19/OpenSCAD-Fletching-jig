use <quadratic_bezier.scad>
use <hinge.scad>

//
//Creates helical vane
//# height - extrusion height
//# spread - horizontal distance between edges of the vane
//# direction - signum determines left or right spin (+ left; - right)
//
module helical_vane (width = 1, length = 75, height = 10, spread = 4, direction = 1)
{
    direction = sign(direction);
    length = length - width;
    rotate([0,90,0])
        linear_extrude(height, center = false, twist = -direction*15, scale = 1)
            translate([-length/2,0,0])
                bezier([0,-direction*spread],[0.5*length,-direction*spread],[length,direction*spread],width);
}

//
//Creates basic shape of the jig's base
//
module base_mold (a = 8, radius = 15, height = 20)
{
    hull()
    { 
        for (i = [0:2]) 
        {
            rotate(a=[0,0,i*120]) translate([0,-a,0]) 
                cube([radius, 2*a, height], false);
        }
    }
}

module jig (    arrow_diameter = 6,
                arrow_offset = 3,
                base_height = 20,
                hinge_width = 6.5, 
                hinge_diameter = 5,
                hinge_depth = 10,
                hinge_pin = 3,
                arm_gap = 0.5,         
                arm_offset = 1.5,
                vane_length = 75, 
                vane_width = 1.1, 
                vane_offset = 25,
                vane_turn = 0,
                helical = false,
                helical_adjust = 1,
                helical_direction = 1
             ) 
{
    base_diameter = arrow_diameter + 12;
    base_radius = base_diameter/2;
    arrow_radius = arrow_diameter/2;
    hinge_radius = hinge_diameter/2;
    arm_height = vane_length + 2*(vane_offset-arm_offset-(base_height - arrow_offset));
    hinge_gap = 0.1;

    //base
    difference()
    {
        base_mold(a = hinge_width, radius = base_radius, height = base_height);
        translate([0,0,arrow_offset]) cylinder(base_height,d=arrow_diameter, true);
        //hinge holer
        for (i = [0:2]) 
        {
            rotate(a=[0,0,i*120]) 
                translate([(base_radius) - hinge_radius, 0, base_height - hinge_depth + hinge_radius]) 
                        hinge (hinge_width, hinge_diameter, hinge_depth + arm_offset - hinge_radius, hinge_pin, true);
        }
    }

    //arm

    union()
    {
        difference()
        {
            translate([0,-hinge_width,base_height + arm_offset])  
                cube([base_radius, hinge_width*2, arm_height], false);
            rotate(a = 120) translate([-hinge_width*2,0,base_height + arm_offset]) 
                cube([hinge_width*4, arrow_diameter, arm_height], false);
            rotate(a = -120) mirror([0,1,0]) translate([-hinge_width*2,0,base_height + arm_offset]) 
                cube([hinge_width*4, arrow_diameter, arm_height], false);
            //shaft hole
            translate([0,0,base_height]) 
                cylinder(arm_height + base_height,d=arrow_diameter, true);
            //vane
            if (helical)
            {
                //r - radius of arrow with gap for vane foot minus correction
                //t - factor of maximum spread (side of equilateral triangle in circumscribed cirle    )
                //x - the distance from center to arm based on t
                r = arrow_radius+arm_gap-0.35;
                t = helical_adjust*(r * sqrt(3));
                x = sqrt(pow(r,2) - pow(t,2)/4);
                echo (r, t, x);
                translate([x,0, vane_length/2 + arrow_offset + vane_offset])
                    helical_vane(width = vane_width, 
                                    length = vane_length, 
                                    height = base_diameter, 
                                    spread = t/2 - vane_width/2,                            
                                    direction = helical_direction);
            }
            else
            {
                translate([base_radius/2,0, vane_length/2 + arrow_offset + vane_offset])
                    rotate([vane_turn,0,0])
                        cube([base_radius, vane_width, vane_length], true);
            }
            //vane foot cutout
            translate([0,0,arrow_offset + vane_offset]) cylinder(vane_length,r=arrow_radius + arm_gap, true);
        }
        translate([base_radius - hinge_radius, 0, base_height - hinge_depth + hinge_radius]) 
                            hinge (hinge_width - hinge_gap, hinge_diameter - hinge_gap, hinge_depth + arm_offset - hinge_radius, hinge_pin - hinge_gap, false);
    }

    //lid
    lid_thickness = 1;
    lid_lip = 2;
    lid_gap = 0.25;

    translate([3*base_radius,0,0]) difference()
    {
        h = vane_offset-arm_offset-(base_height - arrow_offset) + lid_thickness;
        w = hinge_width + lid_gap;
        r = base_radius + lid_gap;
        base_mold(a = w + lid_thickness, radius = r + lid_thickness, height = h);
        translate([0,0,lid_thickness] )base_mold(a = w, radius = r, height = h);
        base_mold(a = w - lid_lip, radius = r - lid_lip, height = h);
    }
}