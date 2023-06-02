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
        base_outer_width = 0,
        base_thickness = 3,
        wall_inner_thickness = 4,
        wall_outer_thickness = 3.5,
        tilt_angle = 70,
        // How tall the walls are, basically. Back cover is for the outer wall,
        // main wall is the inner wall (on the bottom of the ergodox.
        // 40 mm covers the reset hole. The LED window starts 55mm in
        back_cover_width = 30,
        main_wall_height = 40,
        include_clamp_slot = true,
        // Base rest is what the board sits on when angled.
        // Doesn't need to be very thick.
        base_rest_thickness = 5,
        ){
    // 6.6 mm between edge of board and socket for first key.
    // 7 mm by micrometer.
    low_wall_height = 6.8;
    clamp_diameter = 24.5;
    front_right_key_distance_from_right = 16;
    rightmost_column_bottom_key_distance_from_bottom = 25.7;
    // Distance between the walls gets smaller the larger the angle.
    // We want it to stay the thickness of the board, regardless of angle.
    // Need to move the walls apart to account for that.
    // sin(x) = o/h; h = o/sin(x);
    // 0.8 is fine-tuning for my particular board + tolerances.
    wall_distance_apart = keyboard_height / sin(tilt_angle) - 0.4;

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
    // tan(x) = o/a; a = o/tan(x)
    skew = 1/tan(tilt_angle);
    up(base_thickness-overlap) {
            skew(sxz=skew){
            color("blue") right(wall_distance_apart) inner_wall();
            color("green") left(wall_outer_thickness) outer_wall();
        }
    }

    color("purple") translate([0, 0, base_thickness-overlap]){
        // Offset by 25 to put closer to board middle, rather than the ends
        // where the board has rounded corners.
        back(base_rest_thickness + 25) base_rest();
        back(main_board_length - 25) base_rest();
    }

    module base(){
        // Outer base + base under outer wall
        outer_width = base_outer_width + wall_outer_thickness;
        left(outer_width)
            cube([outer_width,
                    main_board_length,
                    base_thickness]);
        // Inner base + base under keyboard
        cube([
                keyboard_height + base_inner_width,
                main_board_length,
                base_thickness]);
    }


    module outer_wall(){
        // Extra adjustment to keep wall off keys
        wall_off_keys_adjustment = 1.5;
        // This wall isn't actually going to reach up the full distance,
        // because of the angle. So can afford to add a bit more length to it.
        // That is calculated as the height correction factor. Treats it like a
        // right angle triangle, where opposite side is the width of the kb
        // bottom and correction length is the adjacent side. Angle is from
        // bottom left. tan(x) = o/a, a = o/tan(x)
        height_correction_factor = (keyboard_height) / tan(tilt_angle);

        // Back cover
        coverable_part_of_back_length = 26;
        cube([
                wall_outer_thickness,
                coverable_part_of_back_length,
                back_cover_width + height_correction_factor
        ]);

        // front corner cover -- avoid getting in the way of the keys
        // Subtract a little to ensure it isn't overlapping with keys
        // and jamming them.
        front_cover_width = front_right_key_distance_from_right +
            height_correction_factor - wall_off_keys_adjustment;
        front_cover_length = rightmost_column_bottom_key_distance_from_bottom - 3;

        back(main_board_length - front_cover_length) cube([
                wall_outer_thickness,
                front_cover_length,
                front_cover_width
        ]);

        // low_wall
        cube([
                wall_outer_thickness,
                main_board_length,
                low_wall_height +
                height_correction_factor -
                wall_off_keys_adjustment
        ]);
    }

    module inner_wall(){
        difference(){
            cube([wall_inner_thickness, main_board_length, main_wall_height]);
            feet_gaps();
        }
        module feet_gaps(){
            for (y = [
                feet_front_dist_from_back_edge,
                feet_back_dist_from_back_edge,
            ]){
                back = y - foot_radius;
                translate([-overlap, back, overlap]) cube([
                        wall_inner_thickness+2*overlap,
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

    module base_rest(){
        angle_against_inner_wall = 180 - tilt_angle - 90;
        prism_height = sin(angle_against_inner_wall) * keyboard_height;
        prism_peak_x = cos(angle_against_inner_wall) * keyboard_height;
        rotate([90,0,0]) linear_extrude(base_rest_thickness)
            polygon([
                    [0,0],
                    [wall_distance_apart, 0],
                    [wall_distance_apart - prism_peak_x, prism_height],

            ]);

        /* prismoid(size1=[keyboard_height, base_rest_thickness], size2=[0, base_rest_thickness], h=height_correction_factor); */
    }

}

