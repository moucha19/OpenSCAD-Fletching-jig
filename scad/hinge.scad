//
//Module that can create both parts of the hinge by changing holer value
//# hinge_diameter - diameter of the cylinder that forms a joint; also depth of the hinge
//# hinge_pin - size of the sphere that holds arm in the hinge
//# holer - if true, outline of the joint will be created and can be later subtracted from another solid, creating opening for hinge itself
//## hole_lip - adds extra depth to the holer, only useful for preview
//
module hinge (hinge_width = 7, hinge_diameter = 5, hinge_height = 8, hinge_pin = 2.4, holer = true)
{
    hole_lip = 1;
    translate([0,hinge_width/2,0]) rotate([90,-90,0]) mirror([0,1,0])
        difference()
        {
            union()
            {
                translate([0,0,hinge_width - 0.2]) sphere(d=hinge_pin);
                translate([0,0,0 + 0.2]) sphere(d=hinge_pin);
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