$fs= $preview ? 1 : 0.1;
$fa= $preview ? 12 : 3;
overlap = 0.01;
include <BOSL2/std.scad>

foot_d = 8.2; // Actual measure 8
ankle_d = 6.6; // Actual measure 7
ankle_l = 2;
leg_w = 9;
leg_l = 95; // OEM legs are 45, Thingiverse extended legs are 85.
head_inner_d = 7;
// Head has 2 parts: a thinner part that interfaces with the hole on the
// ergodox, which needs to be within a certain size; and the thicker main
// part of the head, which can be as thick as you want for strength.
head_outer_d = head_inner_d + 6;
head_interface_outer_d = 10.3;
head_interface_h = 0.8;
// Neck is the length between the ergodox and the leg; make this longer to
// put a bigger gap betreen the body and the leg when folded.
// Neck is also where the head narrows for the screw (no reason it
// couldn't be a separate length but this is convenient).
neck_h = 3;
screw_hole_d = 3;

knurl_n_prisms = 40;
knurl_prisms_h = 0.20;
knurl_prisms_w = 0.40;

translate([0,-ankle_l,0]) foot();
leg();
translate([0,leg_l+head_inner_d/2, -leg_w/2 - neck_h]) head();

module foot(){
    // foot
    difference() {
        sphere(d=foot_d);
        translate([-foot_d,0,-foot_d]) cube(foot_d*2);
    }
    // ankle
    rotate([-90,0,0]) linear_extrude(ankle_l) circle(d=ankle_d);
}

module leg(){
    translate([-leg_w/2, 0, -leg_w/2]) cuboid([leg_w, leg_l, leg_w],
    chamfer=1, p1=[0,0,0]);
}

module head(){
    translate([0,0,+neck_h]){
        difference(){
            cylinder(leg_w, d=head_outer_d);
            translate([0, 0, -overlap]) cylinder(999, d=head_inner_d);
        }

        translate([0,0,-neck_h]){
            difference(){
                cylinder(neck_h, d=head_outer_d);
                translate([0, 0, -overlap]) cylinder(999, d=screw_hole_d);
            }
            // interface with dox
            translate([0,0,-head_interface_h]){
                difference(){
                    cylinder(neck_h, d=head_interface_outer_d);
                    translate([0, 0, -overlap]) cylinder(999, d=screw_hole_d);
                }
            }
        }
    }

    // Knurling
    translate([0,0,-head_interface_h+overlap]){
        difference(){
            for(i = [0:knurl_n_prisms-1]) {
                angle = i * 360 / knurl_n_prisms;
                rotate([0, -180, angle+90]) { // +90 to have the base of the
                    prismoid(
                            [knurl_prisms_w,head_interface_outer_d/2-overlap],
                            [0,head_interface_outer_d/2-overlap],
                            h=knurl_prisms_h, anchor=BOTTOM+BACK+CENTER);
                }
            }
            translate([0, 0, -99]) cylinder(999, d=screw_hole_d+1);
        }
    }

}
