$fa=1;
$fs=0.4;
// Orientations are designed for the right hand keyboard.
// Looking at it straight and flat on a desk with the thumb cluster closest to you, and the LEDs furthest from you.
// The top is the LED cluster end.
// The height is from the desk up.
// The width is from left to right.
// x = width, y = height, z = length

overlap = 0.001;
board_width_top = 159.5;
main_board_length = 133.85;
wall_height = 23;
base_thickness = 3;

top_right_board_corner_radius = 42.14;
thumb_cluster_corner_radius = 21.8;
thumb_cluster_angle_ = 65;

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

support_strut_left_width = 10;
support_strut__right_width = 30;
support_strut_center_width = 22;
support_strut_center_distance_from_right = 82.5;

feet_radius = 5.5;
foot_top_left_dist_from_left_edge = 17.92;
foot_top_left_dist_from_top_edge = 19.22;
foot_top_right_dist_from_top_left_foot = 123.73;
// the top 2 feet share position on Z with one-another, as do the bottom 2.
// the right two feet share their X position.
foot_bottom_left_dist_from_top_left_foot = 102.92;

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

module board_base(){
    cube([board_width_top, base_thickness, main_board_length]);
}
board_base();
