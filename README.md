# Ergodox EZ 3d accessories for 3d printing

Of general use might be the `ergodox_ez_outline.scad`, which contains a bunch of variables and an outline of the base of the Ergodox-EZ that other users may wish to import in order to get the measurements right for their own projects.
Not guaranteed to be 100% accurate, but were measured from a semi-official Ergodox-EZ 3D model so should be pretty close. For all of my prints I have found them to be spot on.

Examples of the main meshes of interest can be previewed on Github by clicking on them. (In the exported meshes folder - no guarantee they are the latest version, only included for easy previewing).

There is also a slice folder with my Cura slicing settings. Choices made may be for esoteric reasons like speed, so use as a guide at best.

## Accessories

### Vertical bracket mount

Totally rethinking ultimate keyboard ergonomics. Obtain a fully neutral shoulder angle, at minimal expense.

Designed to slide onto an L bracket, allowing the keyboard to be used with your arms hanging fully vertically down (most useful when standing).
Example images to come later, once prototyping is complete.

Prints in 3 pieces: tops, left bottom, right bottom. Joints without glue, easily disassembled.

#### Slice notes

Benefits from high infill to increase ridgidity. I went with 60% in gyroid patten. Also recommend thick (1.5mm) walls. It actually isn't that expensive time-wise because that means most of the walls don't have infill but can just be done back and forth.

### Upright bracket

A less radical design, intended to enable extreme tilting of 60º+.
Redesign with much better dimensional accuracy of https://www.thingiverse.com/thing:3207945 and https://www.thingiverse.com/thing:2748084.
My redesign is more customisable (you can change the angle, wall and base thicknesses, wall height), which also gives it much-needed strength compared to the other designs.

Intended to be held on the desk or armrest with some variant of [this clamp](https://www.thingiverse.com/thing:3075868), although the sockets for the clamp can be disabled with a parameter.

Again, photo examples are on their way.

#### Slice notes

Needs a decent infill, otherwise the walls may snap. The limiting factor is layer adhesion, so do what you can when slicing to increase it and you should be fine.
Unlike the projects is is based off, it minimises thin extensions that I found were very likely to snap.

## Build

Probably need to install [BOSL2](https://github.com/revarbat/BOSL2)

Then open the .scad files in OpenSCAD.
