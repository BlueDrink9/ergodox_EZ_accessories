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

bottom_right_board_corner_radius = 42.14/2;
top_right_board_corner_radius = 12.45;
thumb_cluster_corner_radius = 21.8;
thumb_cluster_angle_away_from_left_side = 115;
// Far left edge
thumb_cluster_width = 73.7;
// Bottom-most edge
thumb_cluster_length = 95.8;
thumb_cluster_right_inflection_len_from_right_side = 85.5;
// Busting back out the high school trig, wow.
thumb_cluster_left_inflection_distance_from_top = main_board_length - (cos(180-thumb_cluster_angle_away_from_left_side) * thumb_cluster_width);

top_legs_distance_from_top = 44;

foot_radius = 5.5;
// the top 2 feet share position on Y with one-another, as do the bottom 2.
// the right two feet share their X position.
feet_top_dist_from_top_edge = 19.22;
feet_right_dist_from_left_edge = 141.65;
feet_bottom_dist_from_top_edge = 122.14;
foot_top_left_dist_from_left_edge = 17.92;
// Thumb cluster foot
foot_bottom_left_dist_from_left_edge = -24.82;

module ergodox_outline(square_off_tops=false){

    module board_base(){
        main_base();
        // Thumb cluster
        translate([board_width_top - thumb_cluster_right_inflection_len_from_right_side, -0,0]){
            rotate([0,0,thumb_cluster_angle_away_from_left_side]){
                thumb_cluster();
            }
        }

        module thumb_cluster(){
            // Thumb cluster
            // TODO do this as a 2D shape, I think.
            hull(){
                // rounded end
                translate([thumb_cluster_corner_radius,thumb_cluster_length-thumb_cluster_corner_radius,0]){
                    circle(r=thumb_cluster_corner_radius);
                    translate([thumb_cluster_width-2*thumb_cluster_corner_radius,0]){
                        circle(r=thumb_cluster_corner_radius);
                    }
                }
                // Main part of cluster
                translate([0, 0, 0]){
                    square([thumb_cluster_width,
                            thumb_cluster_length-thumb_cluster_corner_radius]);
                }
            }
        }

        module main_base(){
            hull(){
                // Bottoms - one circle is irrelevant, hidden within the thumb
                // cluster - but something needs to be there to finish the hull.
                for (trans_x = [board_width_top - bottom_right_board_corner_radius,
                        bottom_right_board_corner_radius]){
                    translate([trans_x, bottom_right_board_corner_radius, 0]){
                        circle(r=bottom_right_board_corner_radius);
                    }
                }
                // Tops
                for (trans_x = [board_width_top - top_right_board_corner_radius,
                        top_right_board_corner_radius]){
                    translate([trans_x, main_board_length  - top_right_board_corner_radius, 0]){
                        if(square_off_tops){
                            // For if you are adding something else to the
                            // top (eg a bracket)
                            translate([-top_right_board_corner_radius, 0, 0])
                                square([
                                    top_right_board_corner_radius*2,
                                    top_right_board_corner_radius*2]);
                        }else{
                            circle(r=top_right_board_corner_radius);
                        }
                    }
                }
            }
        }
    }

    module foot_holes(){
        tops = [
            // top left
            [foot_top_left_dist_from_left_edge, feet_top_dist_from_top_edge],
            // top right
            [feet_right_dist_from_left_edge, feet_top_dist_from_top_edge]
        ];
        bottoms = [
            // bottom left/thumb cluster
            [foot_bottom_left_dist_from_left_edge, feet_bottom_dist_from_top_edge],
            // bottom right
            [feet_right_dist_from_left_edge, feet_bottom_dist_from_top_edge]
        ];
        positions = concat(tops, bottoms);
        for(position = positions){
            translate([
                    position.x,
                    main_board_length - position.y,
                    -overlap
            ]){
                circle(r=foot_radius);
            }
        }

    }

    // Board with gaps for feet
    difference(){
        board_base();
        foot_holes();
    }
}

