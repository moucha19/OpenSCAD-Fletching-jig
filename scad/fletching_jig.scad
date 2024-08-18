use <components.scad>

//Functions that create console messages
module error_treshold (value_name, treshold_name, value, treshold)
{
    if (value == treshold) 
    {
        message = str(value_name," treshold (", treshold_name, " = ", treshold, ") reached!");
        if (version()[0] > 2019)
            echo(message);
        else
            echo(str("<font color='red'>", message, "</font>"));
    }
}
module info_treshold (value_name, treshold_name, treshold)
{
    message = str("Current ", treshold_name, " for ", value_name, " is ", treshold);
    if (version()[0] > 2019)
        echo(message);
    else
        echo(str("<font color='blue'>", message, "</font>"));
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
    length = length;
    rotate([0,90,0])
        linear_extrude(height, center = false, twist = -direction*twist, scale = 1)
            translate([-length/2,0,0])
                bezier([0,-direction*spread],[0.5*length,-direction*spread],[length,direction*spread],width);
}

//
//Creates basic shape of the jig's base
//# a - style of the outline
//# a - length of primary side
//# radius - distance from center to midpoint of primary side (apothem)
//# vane_count - number of vanes
//
module base_outline (style, a, radius, vane_count)
{
    rotation_by = 360/vane_count;
    or = sqrt(pow(a/2, 2) + pow(radius, 2)); //? outside radius
    alpha = atan((a/2)/radius); //? half angle of the hinge side
    beta = (rotation_by - 2*alpha)/2; //? half angle of the secondary side
    b = 2 * or * sin(beta); //? secondary side length
    cross_radius = (or * cos(beta)) - ((b/2)*tan((180-rotation_by)/2));

    points = [for (i=[0:rotation_by:360-rotation_by]) 
        if (style == "star") 
            each 
            [
                [cos(i - alpha)*or, sin(i - alpha)*or],
                [cos(i + alpha)*or, sin(i + alpha)*or],
                [cos(i + alpha + beta)*cross_radius, sin(i + alpha + beta)*cross_radius]
            ]
        else
            each 
            [
                [cos(i - alpha)*or, sin(i - alpha)*or],
                [cos(i + alpha)*or, sin(i + alpha)*or],
            ]
    ];
    polygon(points);
}

//
//Calculates primary and secondary angle of the polygon that encompasses base outline
//
function base_outline_angles(a, radius, vane_count) = [
    2*atan((a/2)/(radius)),
    (360 - vane_count*(2*atan((a/2)/(radius))))/vane_count
];

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
//# joint_diameter - diameter of the sphere that connects two halves of the hinge together 
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
//# nock_height - the height you want the nock guide to be
//
module jig (    part_select = 0,
                arrow_diameter = 6,
                arrow_offset = 3,
                base_height = 20,
                hinge_width = 6.5,
                hinge_thickness = 1.5, 
                hinge_diameter = 5,
                hinge_depth = 10,
                joint_diameter = 3,
                arm_gap = 0.5,         
                arm_offset = 1.5,
                vane_style = "straight",
                vane_count = 3,
                vane_length = 75, 
                vane_width = 1.1, 
                vane_offset = 25,
                vane_turn = 0,
                nock = "none",
                nock_width = 3,
                nock_height = 4,
                nock_diameter = 0,
                joint_style = "ball",
                base_style = "polygon",
                lid_style = "polygon",
                fn = $fn
             ) 
{
    //independent internal variables
    hinge_gap = 0.2;
    hinge_to_arrow_gap = 2;
    min_gap = 0.6;
    flag_showAll = part_select == 0 ? 0 : 1; 

    //input corrections and tresholds
    min_arrow_diameter = 2;
    arrow_diameter = abs(arrow_diameter) >= min_arrow_diameter ? abs(arrow_diameter) : min_arrow_diameter;
    arrow_diameter_base = nock != "none" ? max(arrow_diameter, nock_diameter) : arrow_diameter;

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
    max_hinge_width = (arrow_diameter_base + hinge_to_arrow_gap)*tan(180/vane_count) - 2*min_gap; //length of the side of polygon aroung arrow hole, minus min_gap
    hinge_width     = abs(hinge_width) >= min_hinge_width 
                        ? (abs(hinge_width) <= max_hinge_width ? abs(hinge_width) : max_hinge_width) 
                        : min_hinge_width;

    max_joint_diameter = joint_style == "ball" ? min(hinge_diameter - 2*min_gap, hinge_width - hinge_gap - 2*min_hinge_thickness) : hinge_diameter - 2*min_gap;
    joint_diameter = abs(joint_diameter) <= max_joint_diameter ? abs(joint_diameter) : max_joint_diameter;

    max_hinge_thickness = joint_style == "ball" ? (hinge_width-hinge_gap-joint_diameter)/2 : (hinge_width-hinge_gap)/2;
    hinge_thickness = abs(hinge_thickness) >= min_hinge_thickness
                        ? (abs(hinge_thickness) <= max_hinge_thickness ? abs(hinge_thickness) : max_hinge_thickness) 
                        : min_hinge_thickness;

    arrow_offset = abs(arrow_offset) <= base_height ? abs(arrow_offset) : base_height;

    max_arm_gap = 1.5;
    arm_gap = abs(arm_gap) <= max_arm_gap ? arm_gap : max_arm_gap;

    vane_count = abs(vane_count) >= 2 ? abs(vane_count) : 2;
    vane_length = abs(vane_length);

    arm_offset = abs(arm_offset);

    min_vane_offset = (base_height - arrow_offset) + arm_offset + 4;  
    vane_offset = vane_offset >= min_vane_offset ? vane_offset : min_vane_offset;
    nock_height = abs(nock_height) <= base_height - arrow_offset ? abs(nock_height) : base_height - arrow_offset;
    nock_width = abs(nock_width) <= arrow_diameter ? abs(nock_width) : arrow_diameter;

    base_diameter = arrow_diameter_base + 2*hinge_diameter + hinge_to_arrow_gap;
    base_radius = base_diameter/2;
    arrow_radius = arrow_diameter/2;
    hinge_radius = hinge_diameter/2;
    arm_height = vane_length + 2*(vane_offset-arm_offset-(base_height - arrow_offset));
    
    interior_angle = (2*vane_count - 2)*180/(2*vane_count);
    hinge_corner_radius = sqrt(pow(base_radius-hinge_diameter,2) + pow(hinge_width/2,2));
    hinge_secondary_angle = base_outline_angles(hinge_width, base_radius - hinge_diameter, vane_count)[1];
    arm_fill = (2 * sin(hinge_secondary_angle/2) * hinge_corner_radius) * cos(180-interior_angle) * 2;

    arm_width = hinge_width + (joint_style == "pin" ? max(arm_fill, hinge_to_arrow_gap) : max(arm_fill, joint_diameter + 2*min_gap));
    rotation_by = 360/vane_count;

    max_vane_width = 2*(arm_gap+arrow_radius)*sin(rotation_by/2);
    vane_width = abs(vane_width) <= max_vane_width ? abs(vane_width) : max_vane_width;

    //max vane turn limit calculation
    max_vane_spread = max_vane_width - vane_width;
    max_vane_turn = asin(max_vane_spread/vane_length);
    vane_turn = abs(vane_turn) <= max_vane_turn ? vane_turn : sign(vane_turn)*max_vane_turn;

    //error report
    info_treshold ("vane_offset", "minimal value", min_vane_offset);
    info_treshold ("vane_turn", "maximum angle", max_vane_turn);
    info_treshold ("vane_width", "maximum width", max_vane_width);

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
    error_treshold ("joint_diameter", "max", joint_diameter, max_joint_diameter);
    error_treshold ("vane_offset", "min", vane_offset, min_vane_offset);
    error_treshold ("vane_width", "max", vane_width, max_vane_width);
    error_treshold ("vane_turn", "max", abs(vane_turn), max_vane_turn);
    error_treshold ("arrow_offset", "max", arrow_offset, base_height);
    error_treshold ("arm_gap", "max", abs(arm_gap), max_arm_gap);
    error_treshold ("nock_height", "max", nock_height, base_height - arrow_offset);
    error_treshold ("nock_width", "max", nock_width, arrow_diameter);

    assert (min_hinge_width <= max_hinge_width && min_hinge_thickness <= max_hinge_thickness,
            "INVALID HINGE PARAMETERS"
    );

    //Nested module definitions

    //
    //Module that can create both parts of the hinge by changing holer value
    //# holer - if true, outline of the joint will be created and can be later subtracted from another solid, creating opening for hinge itself
    //
    module hinge (holer = true)
    {
        h = hinge_depth + arm_offset - hinge_radius;
        w = !holer ? hinge_width - hinge_gap : hinge_width;
        d = !holer ? hinge_diameter - hinge_gap : hinge_diameter;
        pin = !holer && joint_style == "ball" ? joint_diameter - hinge_gap : joint_diameter;
        hole_lip = 1;
        rotate([90,-90,0]) mirror([0,1,0])
            difference()
            {
                union()
                {
                    if (joint_style == "ball")
                    {
                        translate([0,0,w/2]) sphere(d=pin);
                        translate([0,0,-w/2]) sphere(d=pin);
                    }
                    cylinder(w,d=d, center = true);     
                    translate([h/2,0,0]) cube([h,d,w], true);
                    if (holer)
                    {
                        translate([-d/2,0,-w/2]) 
                            cube([h + d/2, d/2 + hole_lip, w]);
                        if (joint_style == "pin") 
                            cylinder( base_diameter, d=pin,  center = true);
                    }
                }
                if (!holer)
                {
                    translate([h/2 - hole_lip,0, 0]) 
                        cube([h + d, d + hole_lip, w - 2*hinge_thickness], true);
                    if (joint_style == "pin")
                        cylinder( w*2, d=pin, center=true);
                }
            }
    }

    //base
    if (part_select == 1 || part_select == 0)
    union()
    {
        difference()
        {
            linear_extrude(base_height) base_outline(base_style, arm_width, base_radius, vane_count);
            translate([0,0,arrow_offset]) cylinder_holer(height = base_height,radius = arrow_diameter_base/2,fn = fn);
            //hinge holer
            for (i = [0:vane_count-1]) 
            {
                rotate(a=[0,0,i*rotation_by]) 
                    translate([(base_radius) - hinge_radius, 0, base_height - hinge_depth + hinge_radius]) 
                            hinge(true);
            }
        }
        if (nock != "none")
            translate([0,0,arrow_offset + nock_height/2])
                rotate([0,0,nock == "optimal" && vane_count%2 == 0 && vane_count > 2 ? rotation_by/2 : 0])
                    cube([nock_width, arrow_diameter_base, nock_height], true);
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
            rotate(a = rotation_by/2) translate([ -arm_width,0,base_height + arm_offset]) 
                cube([arm_width*2, arrow_diameter, arm_height], false);
            rotate(a = -rotation_by/2) mirror([0,1,0]) translate([ -arm_width,0,base_height + arm_offset]) 
                cube([arm_width*2, arrow_diameter, arm_height], false);
            //shaft hole
            translate([0,0,base_height]) 
                cylinder(arm_height + base_height,d=arrow_diameter, true);
            //vane
            if (vane_style == "straight")
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
                t = (vane_length/2) * sin(abs(vane_turn));
                x = sqrt(pow(r,2) - pow(t*2,2)/4);
                t_outer = (base_radius)*(t/x);
                twist = 2*(atan(t_outer/vane_length/2) - atan(t/vane_length/2));

                translate([x,0, vane_length/2 + arrow_offset + vane_offset])
                    helical_vane(width = vane_width,
                                    length = vane_length,
                                    height = base_radius - x + 0.01,
                                    spread = t,
                                    twist = twist,
                                    direction = sign(vane_turn));
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
                            hinge(false);
    }

    //lid

    lid_thickness = 1;
    lid_lip = 2;
    lid_gap = 0.25;

    if (part_select == 3 || part_select == 0)
        translate((flag_showAll-1)*[3*base_radius,0,0]) 
    union()
    {
        h = vane_offset-arm_offset-(base_height - arrow_offset) + lid_thickness;
        w = arm_width + lid_gap;
        r = base_radius + lid_gap/2;
        linear_extrude(h) 
            difference()
            {
                offset(delta=lid_thickness) base_outline(lid_style, w, r, vane_count);
                base_outline("star", w, r, vane_count);
            }
        linear_extrude(lid_thickness) 
            difference()
            {
                base_outline(lid_style, w, r, vane_count);
                offset(delta=-lid_lip) base_outline("star", w, r, vane_count);
            }
    }
}
