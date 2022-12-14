// Upright mount/bracket for Erdodox EZ, so you can type without pronated wrists. The ultimate tent.
// Designed to slot onto the pinky side of the keyboard.
// This file models the right side. Mirror for left.
// Inspired/based off https://www.thingiverse.com/thing:3207945/comments
// and https://www.thingiverse.com/thing:2748084
include <Ergodox-EZ vertical mount/ergodox_ez_outline.scad>;
use <BOSL2/std.scad>;

overlap = 0.01;

upright_bracket();
module upright_bracket(
        // Inner = the side of the base pointing towards the other keyboard.
        base_inner_width = 50,
        base_outer_width = 20,
        base_thickness = 3,
        wall_inner_thickness = 4,
        wall_outer_thickness = 3,
        tilt_angle = 70,
        // Covers the reset hole, but the LED window starts 55mm in
        back_cover_width = 40,
        main_wall_height = 40,
        include_clamp_slot = true,
        ){
    low_wall_height = 6.4;  // 6.6 mm between edge of board and socket for first key.
    clamp_diameter = 24.5;
    front_right_key_distance_from_right = 16;
    rightmost_column_bottom_key_distance_from_bottom = 25.7;
    base();
    if (include_clamp_slot) {
        up(base_thickness-overlap){
            clamp_slot();
            back(main_board_length-clamp_diameter-3) clamp_slot();
        }
    }
    // Skew gets defined as a shift x units across for every 1 unit up.
    // So can be modelled as a right triangle, with desired angle at base,
    // 1 as height and skew as adjacent side.
    // tan(x) = o/a
    // a = o/tan(x)
    skew = 1/tan(tilt_angle);
    skew(sxz=skew){
        up(base_thickness-overlap) {
            right(keyboard_height) inner_wall();
            left(wall_outer_thickness) outer_wall();
        }
    }

    module base(){
        left(base_outer_width)
            cube([base_outer_width, main_board_length, base_thickness]);
        cube([keyboard_height + base_inner_width, main_board_length, base_thickness]);
    }


    module inner_wall(){
        coverable_part_of_back_length = 26;
        front_cover_width = front_right_key_distance_from_right - 0.5;
        front_cover_length = rightmost_column_bottom_key_distance_from_bottom - 0.5;
        // Back cover
        back(main_board_length-coverable_part_of_back_length)
            cube([wall_inner_thickness, coverable_part_of_back_length, back_cover_width]);

        // front corner cover - avoid getting in the way of the keys
        linear_extrude(front_cover_width)
            square([wall_inner_thickness, front_cover_length]);
        // low_wall
        cube([wall_inner_thickness, main_board_length, low_wall_height]);
    }

    module outer_wall(){
        // cube([wall_outer_thickness, main_board_length, low_wall_height]);
        difference(){
            cube([wall_outer_thickness, main_board_length, main_wall_height]);
            feet_gaps();
        }
        module feet_gaps(){
            // feet_back_dist_from_back_edge = 19.22;
            // feet_right_dist_from_left_edge = 141.65;
            // feet_front_dist_from_back_edge = 122.14;
            for (y = [feet_front_dist_from_back_edge, feet_back_dist_from_back_edge]){
                back = main_board_length - y;
                translate([-overlap,back,base_thickness]) cube([
                        wall_outer_thickness+2*overlap,
                        foot_radius*2,
                        main_wall_height,
                ]);
            }
        }
    }

    module clamp_slot(){
        outer_clamp_diameter = clamp_diameter + 3;
        translate([
                keyboard_height + base_inner_width - outer_clamp_diameter/2,
                outer_clamp_diameter/2,
                0]
        ){
            difference(){
                cylinder(d=outer_clamp_diameter, h=2);
                cylinder(d=clamp_diameter, h=2+overlap);
            }
        }
    }

}

