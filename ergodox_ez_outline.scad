$fa=1;
$fs=0.4;
// Orientations are designed for the right hand keyboard.
// Looking at it straight and flat on a desk with the thumb cluster closest to you, and the LEDs furthest from you.
// The back is the LED cluster end.
// The height is from the desk up.
// The width is from left to right.
// x = width, y = length, z = height
// Origin is at front right corner of the keyboard

overlap = 0.01;
board_width_back = 159.5;
main_board_length = 133.8;
// Not used, but useful for importing
keyboard_height = 22.5;

front_right_board_corner_radius = 42.14/2;
back_right_board_corner_radius = 12.45;
// thumb_cluster_corner_radius = 21.8;
thumb_cluster_corner_radius = 10.92;
thumb_cluster_angle_away_from_left_side = 115;
// Far left edge
thumb_cluster_width = 73.7;
// front-most edge
thumb_cluster_length = 95.8;
thumb_cluster_right_inflection_len_from_right_side = 85.5;
// Busting back out the high school trig, wow.
thumb_cluster_left_inflection_distance_from_back = main_board_length - (cos(180-thumb_cluster_angle_away_from_left_side) * thumb_cluster_width);

back_legs_distance_from_back = 44;

foot_radius = 5.5;
// the back 2 feet share position on Y with one-another, as do the front 2.
// the right two feet share their X position.
// Distance is to center of foot radius
feet_back_dist_from_back_edge = 19.2;
feet_front_dist_from_back_edge = 122.1;
feet_right_dist_from_left_edge = 141.7;
foot_back_left_dist_from_left_edge = 17.9;
// Thumb cluster foot
foot_front_left_dist_from_left_edge = -24.8;

module ergodox_outline(square_off_backs=false){

    module board_base(){
        main_base();
        // Thumb cluster
        translate([board_width_back - thumb_cluster_right_inflection_len_from_right_side, -0,0]){
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
                // fronts - one circle is irrelevant, hidden within the thumb
                // cluster - but something needs to be there to finish the hull.
                for (trans_x = [board_width_back - front_right_board_corner_radius,
                        front_right_board_corner_radius]){
                    translate([trans_x, front_right_board_corner_radius, 0]){
                        circle(r=front_right_board_corner_radius);
                    }
                }
                // backs
                for (trans_x = [board_width_back - back_right_board_corner_radius,
                        back_right_board_corner_radius]){
                    translate([trans_x, main_board_length  - back_right_board_corner_radius, 0]){
                        if(square_off_backs){
                            // For if you are adding something else to the
                            // back (eg a bracket)
                            translate([-back_right_board_corner_radius, 0, 0])
                                square([
                                    back_right_board_corner_radius*2,
                                    back_right_board_corner_radius*2]);
                        }else{
                            circle(r=back_right_board_corner_radius);
                        }
                    }
                }
            }
        }
    }

    module foot_holes(){
        backs = [
            // back left
            [foot_back_left_dist_from_left_edge, feet_back_dist_from_back_edge],
            // back right
            [feet_right_dist_from_left_edge, feet_back_dist_from_back_edge]
        ];
        fronts = [
            // front left/thumb cluster
            [foot_front_left_dist_from_left_edge, feet_front_dist_from_back_edge],
            // front right
            [feet_right_dist_from_left_edge, feet_front_dist_from_back_edge]
        ];
        positions = concat(backs, fronts);
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

