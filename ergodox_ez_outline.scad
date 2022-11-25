$fa=1;
$fs=0.4;
// Orientations are designed for the right hand keyboard.
// Looking at it straight and flat on a desk with the thumb cluster closest to you, and the LEDs furthest from you.
// The top is the LED cluster end.
// The height is from the desk up.
// The width is from left to right.
// x = width, y = length, z = height
// Origin is at bottom right corner of the keyboard

overlap = 0.01;
board_width_top = 159.5;
main_board_length = 133.85;
wall_height = 23;
base_thickness = 3;

top_right_board_corner_radius = 42.14;
thumb_cluster_corner_radius = 21.8;
thumb_cluster_angle_away_from_left_side = 115;
thumb_cluster_width = 73.7;
thumb_cluster_length = 95;
thumb_cluster_right_inflection_len_from_right_side = 85.5;

// Basically starts just after this. Same as side wall len
top_legs_distance_from_top = 44;
side_wall_length = 44;
// Determines how long the supports are
cord_gap = 23;
coverable_part_of_top_length = 26;

foot_radius = 5.5;
// the top 2 feet share position on Y with one-another, as do the bottom 2.
// the right two feet share their X position.
feet_top_dist_from_top_edge = 19.22;
feet_right_dist_from_left_edge = 141.65;
feet_bottom_dist_from_top_edge = 122.14;
foot_top_left_dist_from_left_edge = 17.92;
// Thumb cluster foot
foot_bottom_left_dist_from_left_edge = -24.82;

module ergodox_outline(base_thickness=base_thickness){
    difference(){
        __board_base(base_thickness);
        __foot_holes(base_thickness);
    }
}

module thumb_cluster(base_thickness){
    // Thumb cluster
    translate([thumb_cluster_right_inflection_len_from_right_side, 0,0]){
        rotate([0,0,thumb_cluster_angle_away_from_left_side]){
            cube([thumb_cluster_width, thumb_cluster_length, base_thickness]);
        }
    }
}
module __board_base(base_thickness){
    // Main rectangle
    cube([board_width_top, main_board_length, base_thickness]);
    thumb_cluster(base_thickness);
}

module __foot_holes(base_thickness){
    // top left
    translate([
            foot_top_left_dist_from_left_edge,
            main_board_length - feet_top_dist_from_top_edge,
            -overlap/2
            ]){
        cylinder(r=foot_radius, h=base_thickness+overlap);
    }
    // top right
    translate([
            feet_right_dist_from_left_edge,
            main_board_length - feet_top_dist_from_top_edge,
            -overlap/2
    ]){
        cylinder(r=foot_radius, h=base_thickness+overlap);
    }
    // bottom right
    translate([
            feet_right_dist_from_left_edge,
            main_board_length - feet_bottom_dist_from_top_edge,
            -overlap/2
    ]){
        cylinder(r=foot_radius, h=base_thickness+overlap);
    }
    // thumb cluster bottom left
    translate([
            foot_bottom_left_dist_from_left_edge,
            main_board_length - feet_bottom_dist_from_top_edge,
            -overlap/2
    ]){
        cylinder(r=foot_radius, h=base_thickness+overlap);
    }
}
