//
//Check out following video made by Eric Buijs
//for more information about bezier curves
//https://www.youtube.com/watch?v=jVPJetq0BZg
//

module bezier (p0, p1, p2, w)
{
    deltat = 0.02;
    points = [for (t=[0:deltat:1+deltat]) pow(1-t,2)*p0+2*(1-t)*t*p1+pow(t,2)*p2];

    for (i = [1 : len(points) - 1])
    {
        hull() 
        {
            translate(points[i-1]) circle(d=w);
            translate(points[i]) circle(d=w);
        }
    }
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
