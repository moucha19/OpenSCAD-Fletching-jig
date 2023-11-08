use <components.scad>
use <hinge.scad>

//Functions that create console messages
module error_treshold (value_name, treshold_name, value, treshold)
{
    if (value == treshold) 
        echo(str("<font color='red'>", value_name," treshold (", treshold_name, " = ", treshold, ") reached!</font>"));
}
module info_treshold (value_name, treshold_name, treshold)
{
    echo(str("<font color='blue'>Current ", treshold_name, " for ", value_name, " is ", treshold, "</font>"));
}

//
//Creates helical vane
//# height - extrusion height
//# spread - horizontal distance between edges of the vane
//# direction - sign of the value determines left or right spin (+ left; - right)
//
module helical_vane (width = 1, length = 75, height = 10, spread = 4, twist = 15, direction = 1)
{
    direction = sign(direction);
    length = length - width;
    rotate([0,90,0])
        linear_extrude(height, center = false, twist = -direction*twist, scale = 1)
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
            rotate(a=[0,0,i*120]) translate([0,-a/2,0]) 
                cube([radius, a, height], false);
        }
    }
}

//
// Create nock alignment
//
module nock_insert (nock_width, nock_depth, arrow_diameter, arrow_offset)
{
    nock_radius = (nock_width >= 2) ? 1 : nock_width / 2;
    nock_length = arrow_diameter;
    translate([0,0,arrow_offset + nock_depth/2])
        difference() 
        {
            cube([nock_width, nock_length, nock_depth], true);
            translate([0,0,nock_depth/2 - nock_radius]) rotate ([90,0,0])
            {
                translate([nock_width/2 - nock_radius,0,0]) 
                    fillet(r = nock_radius, w = nock_length, center = true);
                translate([-(nock_width/2 - nock_radius),0,0])
                    mirror([1,0,0])  
                        fillet(r = nock_radius, w = nock_length, center = true);
            }
        }
}

// Polyhole compensated cylinder (that cut's hole for the arrow into the base) for correct fit 
// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects
module cylinder_holer(height = 1,radius = 1,fn = 30){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

//
//All three main components of the jig are created here - arm, base and clamping lid
//# arrow_diameter - slightly bigger than the arrow itself (may vary depending on your printer)
//# arrow_offset - distance between the bottom of the base and arrow
//# base_height - height of the base
//# hinge_width - width of the hinge cutout on the base
//# hinge_thickness - thickness of the hinge extension attached to the bottom of the arm
//# hinge_diameter - diameter of the circular part of the hinge that forms a joint
//# hinge_depth - how deep into the base is the hinge cutout
//# hinge_pin - diameter of the sphere that connects two halves of the hinge together 
//# arm_gap - gap for the vane foot, so that tension during clamping is distributed evenly
//# arm_offset - distance between the top of the base and bottom of the arm
//# vane_length - length of the vane
//# vane_width - width of the vane
//# vane_offset - how far from the end of the arrow will the vane be
//# vane_turn - sets OFFSET fletching in degrees
//# helical - if true, HELICAL fletching will be used
//# helical_adjust - horizontal distance between the bottom and top corner of the HELICAL vane
//# helical_direction - sign of the value determines left or right spin (+ left; - right)
//# nock - boolean (true/false) if nock should be added
//# nock_width - gap size of the nock
//# nock_depth - the height you want the nock guide to be
//
module jig (    part_select = 0,
                arrow_diameter = 6,
                arrow_offset = 3,
                base_height = 20,
                hinge_width = 6.5,
                hinge_thickness = 1.5, 
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
                helical_adjust = 3.5,
                helical_direction = 1,
                nock = false,
                nock_width = 3,
                nock_depth = 3,
                fn = 30
             ) 
{
    //independent internal variables
    hinge_gap = 0.1;
    flag_showAll = part_select == 0 ? 0 : 1; 

    //input corrections and tresholds
    min_arrow_diameter = 2;
    arrow_diameter = abs(arrow_diameter) >= min_arrow_diameter ? abs(arrow_diameter) : min_arrow_diameter;

    min_base_height = 5;
    base_height = base_height >= min_base_height ? base_height : min_base_height;

    hinge_depth = abs(hinge_depth) <= base_height 
                    ? (abs(hinge_depth) >= min_base_height ? abs(hinge_depth) : min_base_height)
                    : base_height;
    
    min_hinge_diameter = 2;
    hinge_diameter = abs(hinge_diameter) <= hinge_depth 
                        ? (abs(hinge_diameter) >= min_hinge_diameter ? abs(hinge_diameter) : min_hinge_diameter)
                        : hinge_depth;

    min_hinge_thickness = 1;
    min_hinge_width = 2*min_hinge_thickness + hinge_gap;
    max_hinge_width = (3*arrow_diameter)/sqrt(3); //inscribed circle in equilateral triangle formula
    hinge_width     = abs(hinge_width) >= min_hinge_width 
                        ? (abs(hinge_width) <= max_hinge_width ? abs(hinge_width) : max_hinge_width) 
                        : min_hinge_width;

    max_hinge_thickness = (hinge_width-hinge_gap)/2;
    hinge_thickness = abs(hinge_thickness) >= min_hinge_thickness
                        ? (abs(hinge_thickness) <= max_hinge_thickness ? abs(hinge_thickness) : max_hinge_thickness) 
                        : min_hinge_thickness;

    max_hinge_pin = min(hinge_diameter, hinge_width - hinge_gap - 2*hinge_thickness);
    hinge_pin = abs(hinge_pin) <= max_hinge_pin ? abs(hinge_pin) : max_hinge_pin;

    arrow_offset = abs(arrow_offset) <= base_height ? abs(arrow_offset) : base_height;

    max_arm_gap = 1.5;
    arm_gap = abs(arm_gap) <= max_arm_gap ? arm_gap : max_arm_gap;

    vane_width = abs(vane_width);

    vane_length = abs(vane_length);

    arm_offset = abs(arm_offset);

    min_vane_offset = (base_height - arrow_offset) + arm_offset + 4;  
    vane_offset = vane_offset >= min_vane_offset ? vane_offset : min_vane_offset;
    nock_depth = abs(nock_depth) <= base_height - arrow_offset ? abs(nock_depth) : base_height - arrow_offset;
    nock_width = abs(nock_width) <= arrow_diameter ? abs(nock_width) : arrow_diameter;

    //dependent internal variables
    base_diameter = arrow_diameter + 2*hinge_diameter + 2;
    base_radius = base_diameter/2;
    arrow_radius = arrow_diameter/2;
    hinge_radius = hinge_diameter/2;
    arm_height = vane_length + 2*(vane_offset-arm_offset-(base_height - arrow_offset));
    arm_width = hinge_width + hinge_pin + 3;

    //max vane turn limit calculation
    max_vane_turn = atan((((arrow_radius+arm_gap)*sqrt(3))/2 - vane_width/2)/(vane_length/2));
    vane_turn = abs(vane_turn) <= max_vane_turn ? vane_turn : sign(vane_turn)*max_vane_turn;
    error_treshold ("vane_turn", "max", abs(vane_turn), max_vane_turn);

    //error report
    info_treshold ("vane_offset", "minimal value", min_vane_offset);
    info_treshold ("vane_turn", "maximum angle", max_vane_turn);

    error_treshold ("arrow_diameter", "min", arrow_diameter, min_arrow_diameter);
    error_treshold ("base_height", "min", base_height, min_base_height);
    error_treshold ("hinge_depth", "min", hinge_depth, min_base_height);
    error_treshold ("hinge_diameter", "min", hinge_diameter, min_hinge_diameter);
    error_treshold ("hinge_diameter", "max", hinge_diameter, hinge_depth);
    error_treshold ("hinge_depth", "max", hinge_depth, base_height);
    error_treshold ("hinge_width", "min", hinge_width, min_hinge_width);
    error_treshold ("hinge_width", "max", hinge_width, max_hinge_width);
    error_treshold ("hinge_thickness", "min", hinge_thickness, min_hinge_thickness);
    error_treshold ("hinge_thickness", "max", hinge_thickness, max_hinge_thickness);
    error_treshold ("hinge_pin", "max", hinge_pin, max_hinge_pin);
    error_treshold ("vane_offset", "min", vane_offset, min_vane_offset);
    error_treshold ("arrow_offset", "max", arrow_offset, base_height);
    error_treshold ("arm_gap", "max", abs(arm_gap), max_arm_gap);
    error_treshold ("nock_depth", "max", nock_depth, base_height - arrow_offset);
    error_treshold ("nock_width", "max", nock_width, arrow_diameter);

    assert (min_hinge_width <= max_hinge_width && min_hinge_thickness <= max_hinge_thickness,
            "INVALID HINGE PARAMETERS"
    );

    //base
    if (part_select == 1 || part_select == 0)
    union()
    {
        difference()
        {
            base_mold(a = arm_width, radius = base_radius, height = base_height);
            translate([0,0,arrow_offset]) cylinder_holer(height = base_height,radius = arrow_diameter/2,fn = fn);
            //hinge holer
            for (i = [0:2]) 
            {
                rotate(a=[0,0,i*120]) 
                    translate([(base_radius) - hinge_radius, 0, base_height - hinge_depth + hinge_radius]) 
                            hinge (hinge_width, hinge_thickness, hinge_diameter, hinge_depth + arm_offset - hinge_radius, hinge_pin, true);
            }
        }
        if (nock == true)
            nock_insert(nock_width, nock_depth, arrow_diameter, arrow_offset);
    }

    //arm
    if (part_select == 2 || part_select == 0)
        rotate(flag_showAll*[0,90,0]) 
            translate(-flag_showAll*[base_radius,0,arm_height/2 + base_height + arm_offset])
    union()
    {
        difference()
        {
            translate([0,-arm_width/2,base_height + arm_offset])  
                cube([base_radius, arm_width, arm_height], false);
            //intersections with two remaining arms
            rotate(a = 120) translate([ -arm_width,0,base_height + arm_offset]) 
                cube([arm_width*2, arrow_diameter, arm_height], false);
            rotate(a = -120) mirror([0,1,0]) translate([ -arm_width,0,base_height + arm_offset]) 
                cube([arm_width*2, arrow_diameter, arm_height], false);
            //shaft hole
            translate([0,0,base_height]) 
                cylinder(arm_height + base_height,d=arrow_diameter, true);
            //vane
            if (helical == 0)
            {
                translate([base_radius/2,0, vane_length/2 + arrow_offset + vane_offset])
                    rotate([vane_turn,0,0])
                        cube([base_radius, vane_width, vane_length], true);
            }
            else
            {
                //r - radius of arrow + gap for vane foot - correction
                //t - values from 0 to maximum spread (side of equilateral triangle in circumscribed cirle)
                //x - distance from center to arm based on t
                r = arrow_radius+arm_gap-0.35;
                t = helical_adjust < (r * sqrt(3)) ? helical_adjust/2 : (r * sqrt(3))/2;
                x = sqrt(pow(r,2) - pow(t*2,2)/4);
                t_outer = (base_radius)*(t/x);
                twist = 2*(atan(t_outer/vane_length/2) - atan(t/vane_length/2));

                error_treshold ("helical_adjust", "max", t*2, r * sqrt(3));
                translate([x,0, vane_length/2 + arrow_offset + vane_offset])
                    helical_vane(width = vane_width,
                                    length = vane_length,
                                    height = base_radius - x + 0.01,
                                    spread = t - vane_width/2,
                                    twist = twist,
                                    direction = helical_direction);
            }

            //vane foot cutout
            vane_foot_easein = 2*arm_gap;
            translate([0,0,arrow_offset + vane_offset - vane_foot_easein])
            {
                difference()
                {
                    cylinder(vane_length + 2*vane_foot_easein,r=arrow_radius + arm_gap, true);
                    cylinder_fillet(rc = arrow_radius, r1 = arm_gap, r2 = vane_foot_easein, bottom = true);
                    translate(v = [0,0,vane_length + vane_foot_easein]) 
                        cylinder_fillet(rc = arrow_radius, r1 = arm_gap, r2 = vane_foot_easein, bottom = false);
                }
            }
        }
        translate([base_radius - hinge_radius, 0, base_height - hinge_depth + hinge_radius]) 
                            hinge(hinge_width - hinge_gap, hinge_thickness, hinge_diameter - hinge_gap, hinge_depth + arm_offset - hinge_radius, hinge_pin - hinge_gap, false);
    }

    //lid

    lid_thickness = 1;
    lid_lip = 2;
    lid_gap = 0.25;

    if (part_select == 3 || part_select == 0)
        translate((flag_showAll-1)*[3*base_radius,0,0]) 
    difference()
    {
        h = vane_offset-arm_offset-(base_height - arrow_offset) + lid_thickness;
        w = arm_width + lid_gap;
        r = base_radius + lid_gap;
        base_mold(a = w + lid_thickness, radius = r + lid_thickness, height = h);
        translate([0,0,lid_thickness] )base_mold(a = w, radius = r, height = h);
        base_mold(a = w - lid_lip, radius = r - lid_lip, height = h);
    }
}
