use <MCAD/regular_shapes.scad>

//
//Check out following video made by Eric Buijs
//for more information about bezier curves
//https://www.youtube.com/watch?v=jVPJetq0BZg
//

module bezier (p0, p1, p2, w)
{
    deltat = 0.02;
    cline = [for (t=[0:deltat:1]) pow(1-t,2)*p0+2*(1-t)*t*p1+pow(t,2)*p2];
    last = len(cline) - 1;
    rline = [for(i = [0 : last]) [cline[i].x, cline[i].y - w/2]];
    lline_rev = [for(i = [len(cline) - 1 : -1 : 0]) [cline[i].x, cline[i].y + w/2]];
    //TODO Only works in one orientation
    translate([((p2.x-p0.x)-cline[last].x)/2, 0]) //corrects calculation error 
        polygon(concat(rline, lline_rev));
}

//
//Creates a fillet shape for difference operator
//# r - fillet radius
//# w - width of the filleted edge
//# center - centers on the circle 
//
module fillet(r = 5, w = 5, center=true)
{
    difference()
    {
        translate([r/2,r/2,0]) cube([r,r,w], center=center);
        cylinder(r=r, h=2*w+0.1, center=center);
    }
}

//
//Creates a fillet shape for difference from a cylinder
//# rc - radius of the cylinder
//# r1 - width radius of the fillet
//# r2 - height radius of the fillet 
//

module cylinder_fillet(rc = 5, r1 = 1, r2 = 1, bottom = true)
{
    rotate_extrude(angle = 360, convexity = 2) 
    translate([rc,0,0]) difference()
    {
        square([r1,r2], false);
        translate(bottom ? [0,r2] : [0,0]) 
        ellipse(2*r1, 2*r2);
    }
}
