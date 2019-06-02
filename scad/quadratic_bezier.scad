//
//based on Eric Buijs Bezier Curve demo
//https://www.youtube.com/watch?v=jVPJetq0BZg
//

deltat = 0.02;
function bezier(p0,p1,p2) = [for (t=[0:deltat:1+deltat]) pow(1-t,2)*p0+2*(1-t)*t*p1+pow(t,2)*p2];
    
module line(p1,p2,w) {
    hull() {
        translate(p1) circle(d=w);
        translate(p2) circle(d=w);
    }
}

module polyline(points, index, w) {
    if(index < len(points)) {
        line(points[index - 1], points[index],w);
        polyline(points, index + 1, w);
    }
}