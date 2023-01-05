// Upright mount/bracket for Erdodox EZ, so you can type without pronated wrists. The ultimate tent.
// Designed to slot onto the pinky side of the keyboard.
// This file models the right side. Mirror for left.
// Inspired/based off https://www.thingiverse.com/thing:3207945/comments
// and https://www.thingiverse.com/thing:2748084
include <ergodox_ez_outline.scad>;
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
        // How tall the walls are, basically. Back cover is for the outer wall,
        // main wall is the inner wall (on the bottom of the ergodox.
        // 40 mm covers the reset hole. The LED window starts 55mm in
        back_cover_width = 30,
        main_wall_height = 30,
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
    up(base_thickness-overlap) {
            skew(sxz=skew){
            // Plus 1 to give it an easier fit
            color("blue") right(keyboard_height+1) inner_wall();
            color("green") left(wall_outer_thickness) outer_wall();
        }
    }

    module base(){
        left(base_outer_width)
            cube([base_outer_width, main_board_length, base_thickness]);
        cube([keyboard_height + base_inner_width, main_board_length, base_thickness]);
    }


    module outer_wall(){
        coverable_part_of_back_length = 26;
        front_cover_width = front_right_key_distance_from_right - 0.5;
        front_cover_length = rightmost_column_bottom_key_distance_from_bottom - 0.5;
        // Back cover
        cube([wall_outer_thickness, coverable_part_of_back_length, back_cover_width]);

        // front corner cover - avoid getting in the way of the keys
        back(main_board_length - front_cover_length)
            cube([wall_outer_thickness, front_cover_length, front_cover_width]);
        // low_wall
        cube([wall_outer_thickness, main_board_length, low_wall_height]);
    }

    module inner_wall(){
        difference(){
            cube([wall_outer_thickness, main_board_length, main_wall_height]);
            feet_gaps();
        }
        module feet_gaps(){
            for (y = [
                feet_front_dist_from_back_edge,
                feet_back_dist_from_back_edge,
            ]){
                back = main_board_length - y - foot_radius;
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

