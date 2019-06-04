use <quadratic_bezier.scad>

$fn=50;

//
//Module that can create both parts of the hinge by changing holer value
//# hinge_diameter - diameter of the cylinder that forms a joint; also depth of the hinge
//# hinge_pin - size of the sphere that holds arm in the hinge
//# holer - if true, outline of the joint will be created and can be later subtracted from another solid, creating opening for hinge itself
//## hole_lip - adds extra depth to the holer, only useful for preview
//
module hinge (hinge_width = 7, hinge_diameter = 5, hinge_height = 8, hinge_pin = 1.2, holer = true)
{
    hole_lip = 1;
    translate([0,hinge_width/2,0]) rotate([90,-90,0]) mirror([0,1,0])
        difference()
        {
            union()
            {
                translate([0,0,hinge_width - 0.2]) sphere(hinge_pin);
                translate([0,0,0 + 0.2]) sphere(hinge_pin);
                cylinder(hinge_width,d=hinge_diameter, true);     
                translate([hinge_height/2,0,hinge_width/2]) cube([hinge_height,hinge_diameter,hinge_width], true);
                if (holer)
                {
                    translate([-hinge_diameter/2,0,0]) 
                        cube([hinge_height + hinge_diameter/2, hinge_diameter/2 + hole_lip, hinge_width]);
                }
            }
            if (!holer)
            {
                translate([hinge_height/2 - hole_lip,0, hinge_width/2]) 
                    cube([hinge_height + hinge_diameter, hinge_diameter + hole_lip, hinge_width - 3], true);
            }
        }
}

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
                polyline(bezier([0,-direction*spread],[length/2,-direction*spread],[length,direction*spread]),1,width);
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
                cube([radius, a*2, height], false);
        }
    }
}

module jig ( arrow_diameter = 6,
             arrow_offset = 4,
             base_height = 20,
             hinge_width = 7, 
             hinge_diameter = 5,
             hinge_depth = 10, 
             arm_height = 90,
             arm_gap = 0.5,         //gap between arm and arrow shaft
             arm_offset = 1,
             vane_length = 75, 
             vane_width = 1, 
             vane_offset = 25,
             vane_turn = 0,
             helical = true,
             helical_adjust = 0.5,
             helical_direction = 1
             ) 
{
    base_diameter = arrow_diameter + 12;
    base_radius = base_diameter/2;
    arrow_radius = arrow_diameter/2;
    hinge_radius = hinge_diameter/2;
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
                        hinge (hinge_width, hinge_diameter, hinge_depth + hinge_diameter + arm_offset, 1.2, true);
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
            //vane and vane foot cutout
            if (helical)
            {
                //x is the distance from center to the side of the inscribed triangle
                x = (arrow_radius+arm_gap) - (arrow_radius+arm_gap)*(1-cos(60));
                translate([x,0, vane_length/2 + arrow_offset + vane_offset])
                    helical_vane(width = vane_width, 
                                    length = vane_length, 
                                    height = base_diameter, 
                                    spread = ((arrow_radius) * sqrt(3))/2 - vane_width/2 - helical_adjust, //side of equilateral triangle in circumscribed cirle                               
                                    direction = helical_direction);
            }
            else
            {
                translate([base_radius/2,0, vane_length/2 + arrow_offset + vane_offset])
                    rotate([vane_turn,0,0])
                        cube([base_radius, vane_width, vane_length], true);
            }
            translate([0,0,arrow_offset + vane_offset]) cylinder(vane_length,d=arrow_diameter + arm_gap, true);
        }
        translate([base_radius - hinge_radius, 0, base_height - hinge_depth + hinge_radius]) 
                            hinge (hinge_width - hinge_gap, hinge_diameter - hinge_gap, hinge_depth + hinge_diameter + arm_offset, 1.2, false);
    }

    //lid
    lid_thickness = 1;
    lid_lip = 2;
    lid_gap = 0.25;

    translate([3*base_radius,0,0]) difference()
    {
        h = arm_height - (vane_offset - arm_offset - base_height + vane_length);
        w = hinge_width + lid_gap;
        r = base_radius + lid_gap;
        base_mold(a = w + lid_thickness, radius = r + lid_thickness, height = h);
        translate([0,0,lid_thickness] )base_mold(a = w, radius = r, height = h);
        base_mold(a = w - lid_lip, radius = r - lid_lip, height = h);
    }
}

//6 mm arrow

jig (   arrow_diameter = 6,
        arrow_offset = 4,
        base_height = 20,
        hinge_width = 6.5, 
        hinge_diameter = 5,
        hinge_depth = 10, 
        arm_height = 90,//-
        arm_gap = 0.5,         
        arm_offset = 1.5,//-
        vane_length = 75, 
        vane_width = 1, 
        vane_offset = 25,
        vane_turn = 0,
        helical = true,
        helical_adjust = 0.5,
        helical_direction = 1
    );
