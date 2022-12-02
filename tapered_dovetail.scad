use <BOSL2/coords.scad>
angle=60;  // Allows for supportless vertical printing

module tapered_dovetail_tooth(max_width, length, taper_percent=5){
    thin_width = max_width/2;  // Should give good strength and depth.
                               // offset = width / 3;
    hypotenuse = thin_width / cos(angle);  // cos(x) = a/h, a/cos(x) = h
    point = polar_to_xy(hypotenuse, angle);
    // translate([- width / 2, - height / 2, 0]) {
    linear_extrude(height = length, scale=1-taper_percent/100) {
        // Trapezoid with fat right end at front, right thin part at origin
        translate([thin_width/2, 0]) // Translate to center on x
        polygon([
                // right thin
                [0, 0],
                // right fat
                point,
                // right thick
                [-2*thin_width, point.y],
                // left thin
                [-thin_width, 0],
        ]);
    }
}
