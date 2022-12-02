// {
// $fa=1;
// $fs=0.4;
include <ergodox_ez_outline.scad>;
// Orientations are designed for the right hand keyboard.
// Looking at it straight and flat on a desk with the thumb cluster closest to you, and the LEDs furthest from you.
// The back is the LED cluster end.
// The height is from the desk up.
// The width is from left to right.
// x = width, y = length, z = height
// Origin is at back left corner of the keyboard (tunnel in past origin)

// TODO separate off the back plate, add a joint of some sort.
// overlap = 0.001;
// board_width_back = 159.5;
// main_board_length = 133.85;
keyboard_height = 22.5;
wall_height = keyboard_height + 1;
base_thickness = 3;
cover_thickness = 2;
wall_thickness = 3;

mount_width = board_width_back + 2 * wall_thickness;

// Determines how long the supports are
cord_gap = 23;
coverable_part_of_back_length = 26;
// side_wall_length = back_legs_distance_from_back;
side_wall_length = coverable_part_of_back_length;

tunnel_tolerance = 0.1;
tunnel_width = 25+tunnel_tolerance;
tunnel_height = 3+tunnel_tolerance/2;

led_cluster_dist_from_left = board_width_back - 61.5;
led_cluster_dist_from_back = 15;
led_cluster_width = 15;
led_cluster_length = 5;
// Same distance from back as led_cluster_dist_from_back
reset_hole_distance_from_left = board_width_back - 20;
reset_hole_radius = 2;

// The thick parts that the keyboard sits on its back face on.
// Cords plug in between these.
support_strut_left_width = 10;
support_strut_right_width = 30;
support_strut_center_width = 22;
support_strut_center_distance_from_right = 82.5;

cord_channel_width = 5;

bracket_tunnel_height = function(tunnel_width, wall_thickness)
    tunnel_height + 2 * wall_thickness;

// }

// Main baseplate
translate([0,-main_board_length,0]){
    difference(){
        linear_extrude(base_thickness){
            ergodox_outline(square_off_backs=true);
        }
        long_back_foot_holes();
    }
}

// baseplate_extension_behind_cords
translate ([-wall_thickness, -overlap, 0]){
    cube([mount_width, cord_gap, base_thickness]);
}

// Bracket tunnel
color("green"){
    translate ([-wall_thickness, cord_gap-overlap,
            0]){
        rotate ([180,-90,90]){
            bracket_tunnel();
        }
    }
}

difference(){
    union(){
        color("blue"){
            supports();
        }
        walls();
    }
    cord_channel();
}
color("purple"){
    // rotate([-1,0,0]){
    top_coverplate();
    // }
}

brace_against_vertical();

color("red"){
    translate([0,0,-30]){
    // brace_against_vertical();

        // rotate([0, 90, 0]) cylinder(h=mount_width, d=cover_thickness, $fn=8);
    }
}


module bracket_tunnel(
        length=mount_width,
        tunnel_height=tunnel_height,
        tunnel_width=tunnel_width,
        wall_thickness=wall_thickness,
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
        support_strut_left_width + wall_thickness,
        support_strut_center_width,
        support_strut_right_width + wall_thickness,
    ];
    support_distances_from_left = [
        -wall_thickness,
        board_width_back - support_strut_center_width - support_strut_center_distance_from_right,
        board_width_back - support_strut_right_width,
    ];
    for(i=[0:2]){
        translate ([support_distances_from_left[i], 0, base_thickness-overlap]){
            cube([support_widths[i], cord_gap, wall_height]);
        }
    }
};


module top_coverplate(){
    translate ([-wall_thickness,0, wall_height - overlap + base_thickness]){
        translate ([ 0, -coverable_part_of_back_length + 2*overlap, 0, ]){
            difference(){
                cube([mount_width, coverable_part_of_back_length, cover_thickness]);
                led_window();
            }
        }
        // The part that covers the supports
        intersection(){
            translate ([wall_thickness,0, -base_thickness]) supports();
            cube([mount_width, cord_gap, cover_thickness]);
        }
        // Round the inner edge so the cords can slide over it easier
        translate ([
                0,
                2*overlap,
                cover_thickness/2,
        ]){
            rotate([0, 90, 0]) cylinder(h=mount_width, d=cover_thickness, $fn=8);
        }

    }
}

module led_window(){
    translate([0,coverable_part_of_back_length-led_cluster_dist_from_back,0]){
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
    for (x_offset = [-wall_thickness+overlap, board_width_back - overlap]){
        translate([x_offset, 0,0]){
            rotate([180,270,0]){
                cube([
                        wall_height + wall_thickness,
                        side_wall_length-overlap,
                        wall_thickness
                ]);
            }
        }
    }
}

module long_back_foot_holes(){
    backs = [
        // back left
        [foot_back_left_dist_from_left_edge, feet_back_dist_from_back_edge],
        // back right
        [feet_right_dist_from_left_edge, feet_back_dist_from_back_edge]
    ];
    // lengthen the holes for the back, to allow space for the bracket
    for (position = backs){
        hull(){
            for (y_offset = [0, coverable_part_of_back_length]){
                translate([
                        position.x,
                        main_board_length - position.y - y_offset,
                        -overlap
                ]){
                    cylinder(r=foot_radius, h=base_thickness+2*overlap);
                }
            }
        }
    }
}

// Small part that braces against the vertical part of the metal bracket this gets mounted to, to reduce flex.
module brace_against_vertical(){
    // Arbitrary positioning.
    extension_dim = [50, 30];
    // Arbitrary
    plug_len = 14;

    plug_wall_thickness = 5;
    bracket_width = tunnel_width - tunnel_tolerance;
    plug_width = bracket_width + base_thickness;
    bracket_hole_width = 5;
    bracket_hole_depth = 3 + 0.5;
    translate([
            -extension_dim.x + overlap,
            -thumb_cluster_left_inflection_distance_from_back - extension_dim.y/2 + 10,
            0
    ]){
        // Extend out from board.
        cube([extension_dim.x,extension_dim.y,base_thickness]);
        // Extend up, to brace against bracket.
        cube([plug_wall_thickness,extension_dim.y, plug_width]);
        // Create a plug into the bracket.
        translate([-bracket_hole_depth + overlap,
                extension_dim.y/2 - plug_len/2,
                bracket_width/2 - bracket_hole_width/2 + base_thickness
        ])
            cube([bracket_hole_depth, plug_len, bracket_hole_width]);
    }
}

module cord_channel(){
    translate([-wall_thickness-overlap,
            -side_wall_length,
            wall_height + base_thickness - cord_channel_width + 2*overlap]){
        cube([support_strut_left_width + wall_thickness + 2*overlap,
                cord_gap/2+side_wall_length,
                cord_channel_width]);
    }
}
