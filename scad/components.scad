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
//# bottom - if true, fillet is generated for the bottom edge, otherwise for the top edge
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

//
//Creates a polyhedron which is a loft of two polygons
//# bottom - bottom polygon points
//# top - top polygon points
//# z_bottom - position of bottom polygon on Z axis 
//# z_top - position of top polygon on Z axis 
//
module loft(bottom, top, z_bottom=0, z_top=1)
{
 n = len(bottom);

    points = concat(
        [[0,0,z_bottom]],
        [for (p = bottom) [p[0], p[1], z_bottom]],
        [[0,0,z_top]],
        [for (p = top) [p[0], p[1], z_top]]
    );

    bottom_center = 0;
    top_center = n + 1;

    bottom_offset = 1;
    top_offset = n + 2;

    side_faces =
    [
        for (i = [0:n-1])
        let(
            j = (i + 1) % n,

            b0 = bottom_offset + i,
            b1 = bottom_offset + j,

            t0 = top_offset + i,
            t1 = top_offset + j
        )
        each [
            [b0, b1, t1],
            [b0, t1, t0]
        ]
    ];

    bottom_faces =
    [
        for (i = [0:n-1])
        let(j = (i + 1) % n)
            [bottom_center,
             bottom_offset + j,
             bottom_offset + i]
    ];

    top_faces =
    [
        for (i = [0:n-1])
        let(j = (i + 1) % n)
            [top_center,
             top_offset + i,
             top_offset + j]
    ];

    polyhedron(
        points = points,
        faces = concat(
            side_faces,
            bottom_faces,
            top_faces
        ),
        convexity = 10
    );
}