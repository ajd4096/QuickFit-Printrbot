//**************************************************
// Quick-Fit carriage for Printrbot
//
// Copyright (c) 2012, Andrew Dalgleish <andrew+github@ajd.net.au>
//
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
// 
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
// 
//
// This is modelled as fitted, with the top-front edge of the QFcarriage() module on the X-axis.
//
// Each of the OpenSCAD axes is parallel with the Printrbot axes with the same name, 
// except the sign is the opposite for X and Y.
//
// OpenSCAD X +ve is towards the left of the Printrbot.
// OpenSCAD Y +ve is towards the front of the Printrbot.
// OpenSCAD Z +ve is towards the top of the Printrbot.


// mo = manifold overlap
// this is a small overlap used to force the model to be manifold
mo	= 0.01;

// constant used to calculate radius for hex holes
da6		= 1/cos(180/6)/2;

//**************************************************
// These dimensions are common

// size of the main base plate
base_plate	= [110, 60, 5];

extruder_size	= [100, 28, 5];		// from RichRap's files, Z + 0.5 at the ends
extruder_offset	= [0, 30, 0];

extruder_clamp	= [10, extruder_size[1] +20, extruder_size[2] + 5];

clamp_hole_offset = extruder_size[1]/2 + 5;
clamp_hole_d	= 4.5;
clamp_nut_d	= 8;
clamp_nut_h	= 2;
clamp_clearance_y1	= 0.5;		// Y-clearance on EACH side of inner edge
clamp_clearance_y2	= 1.5;		// Y-clearance on EACH side of outer edge
clamp_clearance_z1	= +0.0;		// Z-clearance on inner edge
clamp_clearance_z2	= +1.5;		// Z-clearance on outer edge
clamp_clearance_z3	= +2;		// Z-clearance under movable clamp legs

carriage_holes_x	= [-15, 0, 15];		// 3 holes on 15mm spacing - the center hole is compatible with the PB carriage/bracket
carriage_holes_z	= [-5.600, -25.457];	// from PB files
carriage_hole_d		= 4.5;
carriage_nut_d		= 8;
carriage_nut_h1		= 2;			// nut depth
carriage_nut_h2		= 4;			// nut trap in bracket base

// locating lug, dimensions from PB files
groove_zo	= 8.7;
groove_z	= 7.8;
groove_y	= 1;


//**************************************************
// These dimensions are for the plates in QFbracket2

// main vertical plate clamped against carriage
rear_plate		= [80, 5, 40];

// side plates
side_plate		= [5, base_plate[1], 40];
side_plate_offset	= rear_plate[0]/2;
side_holes_y		= [10, 30, 50];
side_holes_z		= [-10, -30];
side_hole_d		= 4.5;
side_nut_d		= 8;
side_nut_h		= 1;

// front plate
front_plate		= [rear_plate[0], 5, 20];
front_holes_x		= [30, 20, 10, 0, -10, -20, -30];
front_holes_z		= [-10];
front_hole_d		= 4.5;
front_nut_d		= 8;
front_nut_h		= 1;


//**************************************************
// QFcarriage
//
// X-Carriage for Printrbot
//
// This is modelled as fitted, with the top-front edge on the X-axis.
//

module QFcarriage(printable=0) {

	block_size		= [48, 25, 32];	// ajd - make wider to seperate the groove from the bearing

	rod_offset	= 15.5;
	rod_spacing	= 25.4;
	// The PB carriage file says 25.2, but the X ends are 25.4

	gap1_y		= 2;

	// LM8UU 8x15x24
	// You may need to adjust bearing_od
	// Initial print 15.2 (0.4mm layer, 0.5mm nozzle) measured 14.2
	bearing_clr	= 10.2;
	bearing_id	= 8;
	bearing_od	= 15.2;
	bearing_w	= 24;
	bearing_od	= 15.7;

	flange		= [block_size[0] - 10, 30, 5];
	flange_offset	= [-block_size[0]/2, -flange[1] -block_size[1] +mo, -rod_offset +1 -flange[2]];	// from PB files, top of flange is 1mm above rod center
	// FIXME - check bottom of flange!

	belt		= [8, 8, flange[2] +mo*2];
	// from PB files, center of belt hole is 31.309mm from rod center
	belt_offset1	= [-block_size[0]/2 +flange[0] -belt[0] -5, -block_size[1]/2 -31.309 -belt[1]/2, flange_offset[2] -mo];
	belt_offset2	= [-block_size[0]/2 + 5, -block_size[1]/2 -31.309 -belt[1]/2, flange_offset[2] -mo];

	gusset1_x	= 5;
	gusset1_yz	= 12;

	gusset2_x	= flange[0];
	gusset2_yz	= 5;

	gusset3_x	= 5;
	gusset3_yz	= 15;

	gusset4_x	= flange[0];
	gusset4_yz	= 2;

	gusset5_z	= flange[2];
	gusset5_xy	= block_size[0] - flange[0];

	rotate(printable ? [0, -90, 0] : [0, 0, 0])
	translate(printable ? [block_size[0]/2, block_size[1]/2, block_size[2]/2] : [0, 0, 0])
	difference() {
		union() {

			// main body, top rod
			translate([-block_size[0]/2, -block_size[1], -block_size[2]])
				cube(block_size);

			// main body, bottom rod
			hull() {
				translate([-block_size[0]/2, -block_size[1], -block_size[2]])
					cube([block_size[0]/2+bearing_w/2, block_size[1], mo]);
				translate([-block_size[0]/2, -block_size[1]/2, -block_size[2]/2 -rod_spacing])
					rotate([0, 90, 0]) cylinder(r=block_size[1]/2, h=block_size[0]/2 +bearing_w/2);
			}


			// belt flange
			translate(flange_offset) cube(flange);

			// top right gusset
			translate([-block_size[0]/2, -block_size[1] -gusset1_yz, flange_offset[2] +flange[2] -mo])
			rotate([0, 90, 0]) linear_extrude(height=gusset1_x, convexity=1)
					polygon([[0, 0], [0, gusset1_yz+mo], [-gusset1_yz -mo, gusset1_yz +mo]]);


			// top wide gusset
			translate([-block_size[0]/2, -block_size[1] -gusset2_yz, flange_offset[2] +flange[2] -mo])
			rotate([0, 90, 0]) linear_extrude(height=gusset2_x, convexity=1)
					polygon([[0, 0], [0, gusset2_yz +mo], [-gusset2_yz -mo, gusset2_yz -mo]]);


			// bottom right gusset
			translate([-block_size[0]/2, -block_size[1] -gusset3_yz, flange_offset[2] +mo])
			rotate([0, 90, 0]) linear_extrude(height=gusset3_x, convexity=1)
					polygon([[0, 0], [0, gusset3_yz+mo], [gusset3_yz +mo, gusset3_yz +mo]]);


			// bottom wide gusset
			translate([-block_size[0]/2, -block_size[1] -gusset4_yz, flange_offset[2] +mo])
			rotate([0, 90, 0]) linear_extrude(height=gusset4_x, convexity=1)
					polygon([[0, 0], [0, gusset4_yz+mo], [gusset4_yz +mo, gusset4_yz +mo]]);


			// flange edge gusset
			translate([block_size[0]/2 - gusset5_xy -mo, -block_size[1] -gusset5_xy, flange_offset[2]])
			linear_extrude(height=gusset5_z, convexity=1)
					polygon([[0, 0], [gusset5_xy +mo, gusset5_xy +mo], [0, gusset5_xy +mo]]);


		}
		// show top rod for assembly
		#translate([-block_size[0]/2 -mo, -block_size[1]/2, -rod_offset])
			rotate([0, 90, 0]) cylinder(r=bearing_id/2, h=block_size[0] +mo*2);
		#translate([-block_size[0]/2 -mo, -block_size[1]/2, -rod_offset -rod_spacing])
			rotate([0, 90, 0]) cylinder(r=bearing_id/2, h=block_size[0] +mo*2);

		// clamp gap
		translate([-block_size[0]/2 -mo, -block_size[1]/2 -gap1_y/2, -rod_offset -rod_spacing])
			cube([block_size[0] +mo*2, gap1_y, rod_spacing]);

		// top rod bearings
		translate([-block_size[0]/2 -mo, -block_size[1]/2, -rod_offset])
			rotate([0, 90, 0]) cylinder(r=bearing_od/2, h=block_size[0] +mo*2);

		// bottom rod clearance
		translate([-block_size[0]/2 -mo, -block_size[1]/2, -rod_offset -rod_spacing])
			rotate([0, 90, 0]) cylinder(r=bearing_clr/2, h=block_size[0] +mo*2);

		// bottom rod bearing
		translate([-bearing_w/2, -block_size[1]/2, -rod_offset -rod_spacing])
			rotate([0, 90, 0]) cylinder(r=bearing_od/2, h=bearing_w +mo);

		// bolt holes
		#for (hx = carriage_holes_x) for (hz = carriage_holes_z) translate([hx, -block_size[1] -mo, hz]) rotate([-90, 0, 0]) {
			cylinder(r=carriage_hole_d *da6, h=block_size[1]+mo*2, $fn=6);
			cylinder(r=carriage_nut_d *da6, h=carriage_nut_h1 +mo, $fn=6);
		}

		// belt hole
		translate(belt_offset1) cube(belt);
		translate(belt_offset2) cube(belt);

		// locating groove
		translate([-block_size[0]/2 -mo, -groove_y, -groove_zo -groove_z])
			rotate([0, 90, 0])
			linear_extrude(height=block_size[0] +mo*2, convexity=2)
			polygon([[0, 0], [0, groove_y +mo], [-groove_z, groove_y+mo], [-groove_z +groove_y, 0]]);
	}
}


//**************************************************
// QFbracket1
//
// Extruder mounting bracket for Printrbot
//
// This is oriented as fitted, with the top-rear edge on the X-axis.
//
// This is the "pretty" version with bevelled corners etc

module QFbracket1(printable=0) {
	base		= base_plate;
	bevel1		= [(base[0] - 48)/2, 5];
	bevel2		= bevel1;

	bevel_rear_left		= [[+base[0]/2 +mo, -mo], [+base[0]/2 -bevel1[0], -mo], [+base[0]/2 +mo, bevel1[1]]];
	bevel_rear_right	= [[-base[0]/2 -mo, -mo], [-base[0]/2 +bevel1[0], -mo], [-base[0]/2 -mo, bevel1[1]]];
	bevel_front_left	= [[-base[0]/2 -mo, base[1] +mo], [-base[0]/2+bevel2[0], base[1] +mo], [-base[0]/2 -mo, base[1] -bevel2[1]]];
	bevel_front_right	= [[+base[0]/2 +mo, base[1] +mo], [+base[0]/2-bevel2[0], base[1] +mo], [+base[0]/2 +mo, base[1] -bevel2[1]]];

	// main vertical plate clamped against carriage
	// outer edge is flat
	plate1		= [48, 4, 31.8];
	// inner edge is bevelled
	plate2_y	= 7.7;
	plate2_poly	= [[29.3, 0], [29.3, -27.8], [19.6, -31.8], [-19.6, -31.8], [-29.3, -27.8], [-29.3, 0]];

	rotate(printable ? [0, 180, 0] : [0, 0, 0])
	difference() {
		union() {
			// main outline
			translate([-base[0]/2, 0, -base[2]]) cube(base);

			// locating lug
			translate([-plate1[0]/2 -mo, -groove_y, -groove_zo]) rotate([0, 90, 0]) 
			linear_extrude(height=plate1[0] +mo*2, convexity=2)
				polygon([[groove_y, 0], [groove_z, 0], [groove_z, groove_y +mo], [0, groove_y +mo]]);

			// vertical mounting plate
			hull() {
				translate([-plate1[0]/2, 0, -plate1[2]])
					cube(plate1);

				translate([0, plate2_y, 0]) rotate([90, 0, 0])
					linear_extrude(height=mo, convexity=5) polygon(plate2_poly);
			}

			// side edges
			for (M=[[0, 0, 0], [1, 0, 0]]) mirror(M) {
				hull() {
					translate([plate1[0]/2, 0, -plate1[2]]) cube([mo, 4, plate1[2]  +mo]);
					translate([40.4, 18.8, -16.4]) cube([4, mo, 16.4]);
				}

				hull() {
					translate([40.4, 18.8, -16.4]) cube([4, mo, 16.4]);
					translate([40.4, 39.1, -base[2]]) cube([4, mo, base[2]]);
				}
			}
		}

		// Remove the center hole
		translate([0, 0, -base[2] -mo]) linear_extrude(height=(base[2] +mo*2), convexity=5) {
			hull() {
				translate([+25, extruder_offset[1], 0]) circle(15);
				translate([0, extruder_offset[1], 0]) circle(20);
				translate([-25, extruder_offset[1], 0]) circle(15);
			}
		}

		// Remove the corner bevels
		translate([0, 0, -base[2] -mo]) linear_extrude(height=(base[2] +mo*2), convexity=5) {
			polygon(bevel_rear_left);
			polygon(bevel_rear_right);
			polygon(bevel_front_left);
			polygon(bevel_front_right);
		}
	

		// vertical holes for clamps
		translate(extruder_offset)
		for (X = [extruder_size[0]/2, -extruder_size[0]/2]) {
			for (Y = [clamp_hole_offset, -clamp_hole_offset]) {
				translate([X, Y, -base[2] -mo])
					rotate([0, 0, 180/6])
					#cylinder(r=clamp_hole_d * da6, h=base[2] + mo*2, $fn=6);
				translate([X, Y, -base[2] -mo])
					rotate([0, 0, 180/6])
					#cylinder(r=clamp_nut_d * da6, h=clamp_nut_h +mo, $fn=6);
			}
		}

		// bracket-carriage mounting holes
		for (X = carriage_holes_x) {
			for (Z = carriage_holes_z) {
				// mounting holes
				#translate([X, -mo, Z]) rotate([-90, 0, 0])
					 cylinder(r=carriage_hole_d *da6, h=plate2_y +mo*2, $fn=6);
				// nut traps
				#translate([X, plate2_y - carriage_nut_h1, Z]) rotate([-90, 0, 0])
					 cylinder(r=carriage_nut_d *da6, h=carriage_nut_h2, $fn=6);

			}
		}
	}
}


//**************************************************
// QFbracket2
//
// Extruder mounting bracket for Printrbot
//
// This is oriented as fitted, with the top-rear edge on the X-axis.
//
// This is the "ugly" version with bevelled corners etc

module QFbracket2(printable=0) {


	rotate(printable ? [0, 180, 0] : [0, 0, 0])
	difference() {
		union() {
			// main outline
			translate([-base_plate[0]/2, 0, -base_plate[2]]) cube(base_plate);

			// add locating lug
			translate([-rear_plate[0]/2, -groove_y, -groove_zo]) rotate([0, 90, 0]) 
			linear_extrude(height=rear_plate[0] +mo*2, convexity=2)
				polygon([[groove_y, 0], [groove_z, 0], [groove_z, groove_y +mo], [0, groove_y +mo]]);

			// vertical mounting plate
			translate([-rear_plate[0]/2, 0, -rear_plate[2]]) cube(rear_plate);

			// add side plates
			for (M=[[0, 0, 0], [1, 0, 0]]) mirror(M) {
				translate([side_plate_offset - side_plate[0], 0, 0])
				difference() {
					translate([0, 0, -side_plate[2]]) cube(side_plate);
					for (Y = side_holes_y) for (Z = side_holes_z) {
						translate([-mo, Y, Z])
							rotate([0,90,0]) cylinder(r=side_hole_d * da6, h=5 +mo*2, $fn=6);
						translate([-mo, Y, Z])
							rotate([0,90,0]) cylinder(r=side_nut_d * da6, h=side_nut_h +mo, $fn=6);
						translate([side_plate[0]-side_nut_h, Y, Z])
							rotate([0,90,0]) cylinder(r=side_nut_d * da6, h=side_nut_h +mo, $fn=6);
					}
				}
			}

			// add front plate
			difference() {
				translate([-front_plate[0]/2, base_plate[1] -front_plate[1], -front_plate[2]]) cube(front_plate);
				for (X = front_holes_x) for (Z = front_holes_z) {
						translate([X, base_plate[1] -front_plate[1] -mo, Z])
							rotate([-90, 180/6, 0]) cylinder(r=front_hole_d * da6, h=front_plate[1] +mo*2, $fn=6);
						translate([X, base_plate[1] -front_plate[1] -mo, Z])
							rotate([-90, 180/6, 0]) cylinder(r=front_nut_d * da6, h=front_nut_h +mo, $fn=6);
						translate([X, base_plate[1] -front_nut_h, Z])
							rotate([-90, 180/6, 0]) cylinder(r=front_nut_d * da6, h=front_nut_h +mo, $fn=6);
				}
			}
		}

		// Remove the central hole
		translate([0, 0, -base_plate[2] -mo]) linear_extrude(height=(base_plate[2] +mo*2), convexity=5) {
			hull() {
				translate([+20, extruder_offset[1], 0]) circle(15);
				translate([0, extruder_offset[1], 0]) circle(20);
				translate([-20, extruder_offset[1], 0]) circle(15);
			}
		}

		// vertical holes for clamps
		translate(extruder_offset)
		for (X = [extruder_size[0]/2, -extruder_size[0]/2]) {
			for (Y = [clamp_hole_offset, -clamp_hole_offset]) {
				translate([X, Y, -base_plate[2] -mo])
					rotate([0, 0, 180/6])
					cylinder(r=clamp_hole_d * da6, h=base_plate[2] + mo*2, $fn=6);
				translate([X, Y, -base_plate[2] -mo])
					rotate([0, 0, 180/6])
					cylinder(r=clamp_nut_d * da6, h=clamp_nut_h +mo, $fn=6);
			}
		}

		// bracket-carriage mounting holes
		for (X = carriage_holes_x) for (Z = carriage_holes_z) {
			// mounting holes
			#translate([X, -mo, Z]) rotate([-90, 0, 0])
				 cylinder(r=carriage_hole_d *da6, h=rear_plate[1] +mo*2, $fn=6);
			// nut traps
			#translate([X, rear_plate[1] - carriage_nut_h1, Z]) rotate([-90, 0, 0])
				 cylinder(r=carriage_nut_d *da6, h=carriage_nut_h2, $fn=6);
		}
	}
}


//**************************************************
//	QFextruderAdapter
//
//	Template for the extruder.
//
//	This is modeled centered on X & Y, move it into place for assembly view.

module	QFextruderAdapter(adapter=0) {
	block1	= extruder_size;
	block2	= [block1[0] -20, block1[1] +10, block1[2]];
	block3	= [block1[0] - 8*2, block1[1], block1[2] + 1];	// clearance for tab at each end
	block4	= [4, block1[1], block1[2] + 0.5];		// raised section at end of tab

	union() {
		// base plate
		translate([-block1[0]/2, -block1[1]/2, 0]) cube(block1);
		translate([-block2[0]/2, -block2[1]/2, 0]) cube(block2);

		// raised tab to show extruder clearance
		%translate([-block3[0]/2, -block3[1]/2, 0]) cube(block3);

		// raised section at ends for clamping
		for (m=[[0, 0, 0], [1, 0, 0]]) mirror(m)
		translate([block1[0]/2 - block4[0], -block4[1]/2, 0]) {
			intersection() {
				cube(block4);
				// raised section is 4mm wide, 0.5 high
				// calc the radius which fits this exactly
				// xx + yy = rr
				// 2*2 + (r-.5)(r-.5) = rr
				// 4 + rr -r + .25 = rr
				// r = 4.25
				translate([block4[0]/2, 0, block4[2] - 4.25])
				rotate([-90, 0, 0])
				cylinder(r=4.25, h=block4[1], $fn=30);
			}
		}
	}
}


//**************************************************
//	QFextruderAdapter1
//
//	Adapter to suit greg's wade with jhead etc
//
//	This is modeled centered on X & Y, move it into place for assembly view.

module	QFextruderAdapter1() {
	difference() {
		QFextruderAdapter();

		translate([0, 0, -mo]) cylinder(r=25/2, h=extruder_size[2] + mo*2);
		for (m=[[0, 0, 0], [1, 0, 0]]) mirror(m)
			translate([25, 0, -mo]) cylinder(r=4 *da6, h=extruder_size[2] + mo*2, $fn=6);
	}
}


//**************************************************
//	QFextruderAdapter2
//
//	Adapter to suit greg's wade with jhead etc, using legacy mount.
//
//	This is modeled centered on X & Y, move it into place for assembly view.

module	QFextruderAdapter2() {
	difference() {
		QFextruderAdapter();

		// greg's wade with jhead etc, legacy mount
		#translate([0, 0, -mo]) cylinder(r=25/2, h=extruder_size[2] + mo*2);
		translate([-3.4, 1, 0])
		for (m=[[0, 0, 0], [1, 0, 0]]) mirror(m)
		#translate([25, 0, -mo]) cylinder(r=4 *da6, h=extruder_size[2] + mo*2, $fn=6);
	}
}


//**************************************************
//	QFextruderClamps
//
//	Clamps for the extruder.
//	This is modeled centered on X & Y, move it into place.

module	QFextruderClamps(printable=0) {
	QFextruderClampLeft(printable);
	QFextruderClampRight(printable);
}
	
//**************************************************
//	QFextruderClampLeft
//
//	Left clamp for the extruder.
//	This is modeled centered on X & Y, move it into place.

module	QFextruderClampLeft(printable=0) {

	block	= extruder_clamp;

	rotate(printable ? [0, 180, 0] : [0, 0, 0])
	translate(printable ? [10, 0, -block[2]] : [extruder_size[0]/2, 0, 0])
	difference() {
		translate([-block[0]/2, -block[1]/2, 0]) cube(block);

		// remove cutout for extruder plate
		#hull() {
			translate([+block[0]/2 +mo, -extruder_size[1]/2 -clamp_clearance_y1, -mo])
				cube([mo, extruder_size[1] +clamp_clearance_y1*2, extruder_size[2] +clamp_clearance_z1]);

			translate([-block[0]/2 -mo, -extruder_size[1]/2 -clamp_clearance_y2, -mo])
				cube([mo, extruder_size[1] +clamp_clearance_y2*2, extruder_size[2] +clamp_clearance_z2]);
		}

		// Shorten legs
		translate([-block[0]/2 -mo, -block[1]/2 -mo, -mo]) cube([block[0] +mo*2, block[1] +mo*2, clamp_clearance_z3 +mo]);


		// remove holes for clamps
		for (m=[[0, 0, 0], [0, 1, 0]]) mirror(m)
			translate([0, clamp_hole_offset, -mo])
				rotate([0, 0, 180/6])
				cylinder(r=clamp_hole_d * da6, h=block[2] +5 +mo*2, $fn=6);
	}
}

//**************************************************
//	QFextruderClampRight
//
//	Right clamp for the extruder.
//	This is modeled centered on X & Y, move it into place.

module	QFextruderClampRight(printable=0) {

	block	= extruder_clamp;

	rotate(printable ? [0, 180, 0] : [0, 0, 0])
	translate(printable ? [-10, 0, -block[2]] : [-extruder_size[0]/2, 0, 0])
	difference() {
		translate([-block[0]/2, -block[1]/2, 0]) cube(block);

		// remove cutout for extruder plate
		#hull() {
			translate([+block[0]/2 +mo, -extruder_size[1]/2 -clamp_clearance_y2, -mo])
				cube([mo, extruder_size[1] +clamp_clearance_y2*2, extruder_size[2] +clamp_clearance_z2]);

			translate([-block[0]/2 -mo, -extruder_size[1]/2 -clamp_clearance_y1, -mo])
				cube([mo, extruder_size[1] +clamp_clearance_y1*2, extruder_size[2] +clamp_clearance_z1]);
		}

		// remove holes for clamps
		for (m=[[0, 0, 0], [0, 1, 0]]) mirror(m) {
			translate([0, clamp_hole_offset, -mo])
				rotate([0, 0, 180/6])
				cylinder(r=clamp_hole_d *da6, h=block[2] +mo*2, $fn=6);
			*translate([0, clamp_hole_offset, block[2] -clamp_nut_h])
				rotate([0, 0, 180/6])
				cylinder(r=clamp_nut_d *da6, h=clamp_nut_h +mo, $fn=6);
		}
	}
}


//**************************************************
//	show_assembly
//
//	Show the main components in assembled position

module	show_assembly(exploded=0, bracket=1) {
	gap	= 20;

	translate(exploded ? [0, -gap, 0] : [0, 0, 0])
		QFcarriage();

	if (bracket == 1)
		QFbracket1(printable);
	else if (bracket == 2)
		QFbracket2(printable);

	translate(exploded ? [0, 0, gap] : [0, 0, 0])
		translate(extruder_offset) QFextruderAdapter1();

	translate(exploded ? [0, 0, gap *2] : [0, 0, 0]) {
		translate(extruder_offset) QFextruderClamps();
	}

}


show_assembly(exploded=1, bracket=2);
//show_assembly(exploded=0, bracket=2);
//QFcarriage(printable=1);
//QFbracket1(printable=1);
//QFbracket2(printable=1);
//QFextruderClamps(printable=1);
//QFextruderAdapter1(printable=1);
//QFextruderAdapter2(printable=1);
