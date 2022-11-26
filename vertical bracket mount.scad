// {
$fa=1;
$fs=0.4;
use <ergodox_ez_outline.scad>;
// Orientations are designed for the right hand keyboard.
// Looking at it straight and flat on a desk with the thumb cluster closest to you, and the LEDs furthest from you.
// The top is the LED cluster end.
// The height is from the desk up.
// The width is from left to right.
// x = width, y = length, z = height
// Origin is at top left corner of the keyboard (tunnel in past origin)

overlap = 0.001;
board_width_top = 159.5;
main_board_length = 133.85;
wall_height = 23;
base_thickness = 3;
cover_thickness = 2;
mount_wall_thickness = 3;

mount_width = board_width_top + 2 * mount_wall_thickness;

side_wall_length = 44;
// Determines how long the supports are
cord_gap = 23;
thumb_cluster_width = 73.7;
coverable_part_of_top_length = 26;

tunnel_width = 25;
tunnel_height = 3;

led_cluster_dist_from_left = board_width_top - 61.5;
led_cluster_dist_from_top = 15;
led_cluster_width = 15;
led_cluster_length = 5;
// Same distance from top as led_cluster_dist_from_top
reset_hole_distance_from_left = board_width_top - 20;
reset_hole_radius = 2;

// The thick parts that the keyboard sits on its top face on.
// Cords plug in between these.
support_strut_left_width = 10;
support_strut_right_width = 30;
support_strut_center_width = 22;
support_strut_center_distance_from_right = 82.5;

bracket_tunnel_height = function(tunnel_width, wall_thickness)
    tunnel_height + 2 * wall_thickness;
// }

// Main baseplate
translate([0,-main_board_length,0]){
    ergodox_outline(base_thickness = 3);
}

// baseplate_extension_behind_cords
translate ([-mount_wall_thickness, -overlap, 0]){
    cube([mount_width, cord_gap, base_thickness]);
}

// Bracket tunnel
color("green"){
    translate ([-mount_wall_thickness, cord_gap-overlap,
            0]){
        rotate ([180,-90,90]){
            bracket_tunnel();
        }
    }
}

color("blue"){
    supports();
}
color("purple"){
    top_coverplate();
}
walls();

// color("red"){
//     translate([0,0,-30]){
//     // Wall
//     rotate([180,270,0]){
//         cube([wall_height, top_legs_distance_from_top-0.1, wall_thickness]);
//     }
//     }
// }


module bracket_tunnel(
        length=mount_width,
        tunnel_height=tunnel_height,
        tunnel_width=tunnel_width,
        wall_thickness=mount_wall_thickness,
        ){

    width = tunnel_width + 2 * wall_thickness;
    height = tunnel_height + 2 * wall_thickness;

    difference() {
        // outer
        cube([width, length, height]);
        // tunnel
        translate ([wall_thickness, wall_thickness - 9, wall_thickness]){
            cube([tunnel_width, length + 99, tunnel_height]);
        }
    }
}

module supports(){
    support_widths = [
        support_strut_left_width + mount_wall_thickness,
                                 support_strut_center_width,
                                 support_strut_right_width + mount_wall_thickness,
    ];
    support_distances_from_left = [
        -mount_wall_thickness,
        board_width_top - support_strut_center_width - support_strut_center_distance_from_right,
        board_width_top - support_strut_right_width,
    ];
    for(i=[0:2]){
        translate ([support_distances_from_left[i], 0, base_thickness-overlap]){
            cube([support_widths[i], cord_gap, wall_height]);
        }
    }
};


module top_coverplate(){
    translate ([
            -mount_wall_thickness,
            -coverable_part_of_top_length + 2*overlap,
            wall_height + mount_wall_thickness - overlap,
    ]){
        difference(){
            cube([mount_width, coverable_part_of_top_length, cover_thickness]);
            led_window();
        }
    }
    // The part that covers the supports
    translate ([
            0,
            overlap,
            wall_height + overlap,
    ]){
        intersection(){
            supports();
            translate ([-mount_wall_thickness, 0, base_thickness]){
                cube([mount_width, cord_gap, cover_thickness]);
            }
        }
    }
}

module led_window(){
    translate([0,coverable_part_of_top_length-led_cluster_dist_from_top,0]){
        // Reset hole window
        translate([reset_hole_distance_from_left, led_cluster_length/2, -1]){
            cylinder(r=reset_hole_radius, h=cover_thickness+10);
        }
        // LED window
        translate([led_cluster_dist_from_left, 0, -1]){
            cube([led_cluster_width, led_cluster_length, cover_thickness+10]);
        }
    }
}


module walls(){
    for (x_offset = [-mount_wall_thickness+overlap, board_width_top - overlap]){
        translate([x_offset, 0,0]){
            rotate([180,270,0]){
                cube([
                        wall_height + mount_wall_thickness,
                        coverable_part_of_top_length-overlap,
                        mount_wall_thickness
                ]);
            }
        }
    }
}

