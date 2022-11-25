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

// Basically starts just after this. Same as side wall len
top_legs_distance_from_top = 44;
side_wall_length = 44;
// Determines how long the supports are
cord_gap = 23;
thumb_cluster_width = 73.7;
coverable_part_of_top_length = 26;

tunnel_width = 25;
tunnel_height = 3;
mount_wall_thickness = 3;

led_cluster_dist_from_right = 61.5;
led_cluster_dist_from_top = 15;
led_cluster_width = 15;
led_cluster_length = 5;
// Same distance from top as led_cluster_dist_from_top
reset_hole_distance_from_right = 20;

// The thick parts that the keyboard sits on its top face on.
// Cords plug in between these.
support_strut_left_width = 10;
support_strut__right_width = 30;
support_strut_center_width = 22;
support_strut_center_distance_from_right = 82.5;

module bracket_tunnel(
        length=board_width_top,
        tunnel_height=tunnel_height,
        tunnel_width=tunnel_width,
        wall_thickness=mount_wall_thickness,
        ){

    width = tunnel_width + 2 * wall_thickness;
    height = tunnel_height + 2 * wall_thickness;

    difference() {
        cube([width, height, length]);
        translate ([0, wall_thickness, wall_thickness]){
            cube([tunnel_width, tunnel_height, length + 1]);
        }
    }

}
ergodox_outline();
