// Wemos D1 Mini ESP32 box with button
//
// V1: will need lots of hot glue :-)
// V2: More buttons + 0.91" OLED
//
// Torsten Paul <Torsten.Paul@gmx.de>, October 2022
// CC BY-SA 4.0
// https://creativecommons.org/licenses/by-sa/4.0/

part = "assembly"; // [ "assembly", "bottom", "top" ]

tolerance = 0.3;

wall = 2;

box_width = 65;
box_length = 88;
box_height = 25;
box_rounding = 4;
box_cable_dia = 5;

d1_mini_esp32_width = 31.4;
d1_mini_esp32_length = 39;
d1_mini_esp32_thickness = 1;
d1_mini_esp32_standoff = 3;
d1_mini_esp32_reset_cutout = 7;

pcb_width = 50;
pcb_length = 70;
pcb_thickness = 1.6;
pcb_holes_x = 18;
pcb_holes_y = 24;
pcb_standoff = 8;

oled_width = 12;
oled_length = 39.2;
oled_thickness = 1.2;
oled_disp_width = 11.6;
oled_disp_length = 30;
oled_disp_x = 0.4;
oled_disp_y = 5.6;
oled_screen_width = 5.6;
oled_screen_length = 23;
oled_screen_x = 2.0;
oled_screen_y = 1.8;

button_dia = 13.2;
button_cap_dia = 11.6;

usb_mini_h = 1.3;

box_usb_offset = box_width / 2 - d1_mini_esp32_width / 2 - 3 * box_rounding;
box_cable_offset = box_width / 2 - box_cable_dia / 2 - 3 * box_rounding;

screwhole = function(a, d) (d / 2 + tolerance * sin(5 * a)) * [sin(a), cos(a)];

module button_12x12() {
	yo = (raster * 5) / 2;

	translate([raster, yo, 0]) {
		color("black") linear_extrude(2) offset(1) square(10, center = true);
		color("silver") translate([0, 0, eps]) linear_extrude(2.1) offset(1) square(9, center = true);
		color("gold") translate([0, 0, eps]) linear_extrude(2.8) circle(d = 6.8);
		color("gold") translate([0, 0, eps]) linear_extrude(7) offset(0.2) square(2.0, center = true);
		color("gold") translate([0, 0, 5]) linear_extrude(2.2) offset(0.4) square(3, center = true);
		color("silver") translate([raster, yo, -.5 - eps]) cylinder(d = 0.8, h = 5, center = true);
		color("silver") translate([-raster, yo, -.5 - eps]) cylinder(d = 0.8, h = 5, center = true);
		color("silver") translate([raster, -yo, -.5 - eps]) cylinder(d = 0.8, h = 5, center = true);
		color("silver") translate([-raster, -yo, -.5 - eps]) cylinder(d = 0.8, h = 5, center = true);
	}
}

function oled_center(z = 0) = 
	let(xo = (oled_width - raster * 3) / 2)
	let(yo = -raster / 2)
	let(ow = oled_width / 2)
	let(ol = oled_length / 2)
	[xo - ow, yo + ol, z];

function oled_screen_center(z = 0) =
	let(xo = (oled_width - raster * 3) / 2)
	let(yo = -raster / 2)
	let(ow = oled_screen_width / 2)
	let(ol = oled_screen_length / 2)
	[xo - oled_width + oled_disp_x + oled_screen_x + ow, yo + oled_disp_y + oled_screen_y + ol, z];

module oled() {
	w2 = oled_width / 2;
	xo = (oled_width - raster * 3) / 2;
	
	if ($preview) {
		translate([-oled_width + xo, -raster / 2]) {
			color("green")
				linear_extrude(oled_thickness)
					square([oled_width, oled_length]);
			for (a = [0:3])
				color("silver")
					translate([xo + a * raster, raster / 2, -8])
						cylinder(d = 0.8, h = 11);
			color("black")
				translate([oled_disp_x, oled_disp_y, eps])
					linear_extrude(oled_thickness + 0.8)
						square([oled_disp_width, oled_disp_length]);
			color("darkslategray")
				translate([oled_disp_x + oled_screen_x, oled_disp_y + oled_screen_y, eps])
					linear_extrude(oled_thickness + 0.9)
						square([oled_screen_width, oled_screen_length]);
			h = 2.4;
			color("black")
				translate([w2, raster / 2, -h + eps])
					linear_extrude(h)
						offset(0.4)
							square([3.5 * raster, 0.8], center = true);
		}
	}
}

module pcb_drill_pos() {
	w2 = pcb_width / 2;
	for (pos = [[w2 - 2, 2], [-w2 + 2, 2], [w2 - 2, pcb_length - 2], [-w2 + 2, pcb_length - 2]])
		translate(pos)
			children();
}

module pcb_hole_pos(x, y) {
	xo = (pcb_width - raster * (pcb_holes_x - 1)) / 2;
	yo = (pcb_length - raster * (pcb_holes_y - 1)) / 2;
	translate([-pcb_width / 2 + xo, yo])
		translate(raster * [x, y])
			children();
}

module pcb_button_pos(z = 0) {
	translate([0, 0, z])
		for (pos = [[1, 0], [7, 0], [13, 0], [7, 6]])
			pcb_hole_pos(pos.x, pos.y)
				children();
}

module pcb_button_center(z = 0) {
	translate([raster, 2.5 * raster, 0])
		pcb_button_pos(z)
			children();
}

module pcb() {
	w2 = pcb_width / 2;
	
	xo = (pcb_width - raster * (pcb_holes_x - 1)) / 2;
	yo = (pcb_length - raster * (pcb_holes_y - 1)) / 2;

	if ($preview) {
		color("green") linear_extrude(pcb_thickness) difference() {
			translate([-w2, 0])
				square([pcb_width, pcb_length]);
			pcb_drill_pos()
				circle(d = 2.3);
			for (x = [0:pcb_holes_x - 1], y = [0:pcb_holes_y - 1])
				pcb_hole_pos(x, y)
					circle(d = 1);
		}
		color("silver")
			translate([0, 0, -eps])
				linear_extrude(pcb_thickness + 2 * eps)
					for (x = [0:pcb_holes_x - 1], y = [0:pcb_holes_y - 1])
						pcb_hole_pos(x, y)
							difference() {
								circle(d = 2);
								circle(d = 1 - eps);
							}

		translate([0, 0, pcb_thickness - eps]) {
			pcb_button_pos() button_12x12();
		}
		translate([0, 0, pcb_thickness - eps + 2.5])
			pcb_hole_pos(1, 19) rotate(-90) oled();
	}
}

module d1_mini_esp32(alpha = 1) {
	if ($preview) {
		w2  = d1_mini_esp32_width / 2;
		color("green", alpha = alpha) render() difference() {
			translate([-w2, 0, 0])
				cube([d1_mini_esp32_width, d1_mini_esp32_length, d1_mini_esp32_thickness]);
			// reset button cutout
			translate([-w2, 0])
				cube([2 * 2.54, 2 * d1_mini_esp32_reset_cutout, 3], center = true);
			translate([-w2 - 1, d1_mini_esp32_length - 3, -1])
				rotate(45)
					cube([8, 8, 3]);
			translate([w2 + 1, d1_mini_esp32_length - 3, -1])
				rotate(45)
					cube([8, 8, 3]);
		}
		color("silver", alpha = alpha) translate([-7.5, 14, d1_mini_esp32_thickness - eps])
			cube([15, 17, 3.2]);
		color("black", alpha = alpha) translate([-9, 13.5, d1_mini_esp32_thickness - eps])
			cube([18, 25, 0.7]);
		color("silver", alpha = alpha) translate([-5, -1, d1_mini_esp32_thickness - eps])
			cube([10, 8, 2]);
	}
}

module usb_micro_cutout(h = 10) {
	rotate([-90, 0, 0])
		translate([0, 0, -0.2])
			linear_extrude(h + 0.2)
				offset(1) offset(-1) square([12, 8], center = true);
}

module box_shape() {
	w2 = box_width / 2;
	offset(box_rounding)
		offset(-box_rounding)
			translate([-w2, 0])
				square([box_width, box_length]);
}

module pilar(d = 3) {
	h = box_height - wall - tolerance;
	f = function(a) (d / 2 + tolerance * sin(8 * a)) * [sin(a), cos(a)];
	difference() {
		cylinder(r = box_rounding, h = h);
		translate([0, 0, wall + eps])
			linear_extrude(h - wall, convexity = 2)
				polygon([for (a = [0:$fa:359]) f(a)]);
		translate([0, 0, h - 3])
			cylinder(h = 3 + eps, d1 = 0, d2 = 3.8);
				
	}
}

module top() {
	h = pcb_standoff + wall;
	l = (box_length - pcb_length) / 2;
	difference() {
		union() {
			linear_extrude(2 * wall)
				box_shape();
			linear_extrude(box_height + wall, convexity = 3) difference() {
				offset(wall) box_shape();
				box_shape();
			}
			translate([-raster / 2, l, eps]) {
				pcb_drill_pos()
					cylinder(h = h - eps, d = 8);
			}
			pilar_pos(wall - eps) pilar();
		}
		hull() {
			translate([box_cable_offset, box_length, box_height + box_cable_dia])
				rotate([90, 0, 0])
					cylinder(d = box_cable_dia, h = 5 * wall, center = true);
			translate([box_cable_offset, box_length, box_height - box_cable_dia / 2 - wall])
				rotate([90, 0, 0])
					cylinder(d = box_cable_dia, h = 5 * wall, center = true);
		}
		translate([-box_usb_offset, box_length, box_height - 3 * wall])
			usb_micro_cutout();

		depth = 1.6;
		// oled display cutout
		translate([0, box_length / 4 * 3, 0])
				linear_extrude(5 * wall, center = true)
					square([oled_screen_length + 4 * tolerance, oled_screen_width + 4 * tolerance], center = true);
		// oled display chamfer
		translate([0, box_length / 4 * 3, -depth + tolerance])
			hull() {
				translate([0, 0, wall + eps])
					linear_extrude(eps)
						square([oled_screen_length + 4 * tolerance, oled_screen_width + 4 * tolerance], center = true);
				translate([0, 0, -eps])
					linear_extrude(eps)
						offset(delta = wall)
							square([oled_screen_length + 4 * tolerance, oled_screen_width + 4 * tolerance], center = true);
			}
		// oled cutout
		o = (oled_screen_center() - oled_center()).yxz;
		translate(o + [0, box_length / 4 * 3, wall + tolerance])
			linear_extrude(2 * wall)
				square([oled_length + 2 * tolerance - raster / 2, oled_width + 2 * tolerance], center = true);
		// oled screen cutout
		translate(o + [-oled_disp_y / 2 + tolerance, box_length / 4 * 3, wall + tolerance - depth])
			linear_extrude(2 * wall) difference() {
				x = oled_length + 4 * tolerance - raster / 2 - oled_disp_y;
				y = oled_width + 2 * tolerance;
				square([x, y], center = true);
				translate([-x / 2, y / 2]) square(4, center = true);
			}

		translate([-raster / 2, l, 2 * wall]) {
			pcb_drill_pos() {
				linear_extrude(pcb_standoff + eps, convexity = 2)
					polygon([for (a = [0:$fa:359]) screwhole(a, 1.8)]);
				translate([0, 0, pcb_standoff - wall - 2])
					cylinder(h = 2 + eps, d1 = 0, d2 = 2.5);
			}
		}

		translate([-raster / 2, l, 0]) rotate([0, 180, 0]) {
			pcb_button_center(-h + eps)
				cylinder(h = h, d = button_cap_dia + 2 * tolerance);
			pcb_button_center(-h - wall)
				cylinder(h = h, d = button_dia + 4 * tolerance);
		}
	}
}

module pilar_pos(z = 0) {
	translate([-box_width / 2 + box_rounding - tolerance, box_rounding + tolerance, z])
		children();
	translate([box_width / 2 - box_rounding + tolerance, box_rounding + tolerance, z])
		children();
	translate([-box_width / 2 + box_rounding - tolerance, box_length - box_rounding + tolerance, z])
		children();
	translate([box_width / 2 - box_rounding + tolerance, box_length - box_rounding + tolerance, z])
		children();
}

module d1_mini_esp32_holder() {
	w2 = d1_mini_esp32_width / 2;

	module clip(l, h, w = wall) {
		assert(w <= d1_mini_esp32_standoff);
		difference() {
			union() {
				translate([-w/2, 0, 0])
					cube([w, l, d1_mini_esp32_standoff + eps]);
				translate([-w, 0, 0])
					cube([w, l, d1_mini_esp32_standoff + h + tolerance + eps]);
				translate([-2 * w, 0, 0])
					cube([3.5 * w, l, w]);
				translate([-w, 0, d1_mini_esp32_standoff + h + tolerance])
					linear_extrude(w / 2, scale = [1.5,1])
						square([w, l]);
				translate([-w, 0, d1_mini_esp32_standoff + h + w / 2 + tolerance])
					linear_extrude(1)
						square([1.5 * w, l]);

			}
			translate([-2 * w, -eps + d1_mini_esp32_reset_cutout, w])
				rotate([90, 0, 0])
					cylinder(h = 3 * d1_mini_esp32_length, r = w, center = true);
			translate([1.5 * w, -eps + d1_mini_esp32_reset_cutout, w])
				rotate([90, 0, 0])
					cylinder(h = 3 * d1_mini_esp32_length, r = w, center = true);
		}
	}

	translate([0, -eps, 0]) {
		translate([+0, d1_mini_esp32_length + tolerance, 0])
			rotate(-90)
				translate([0, -d1_mini_esp32_width / 4, 0])
					clip(d1_mini_esp32_width / 2, d1_mini_esp32_thickness + tolerance, 1.5 * wall);
		translate([w2 + tolerance, 0, 0])
			mirror([1, 0, 0])
				clip(d1_mini_esp32_length + eps, d1_mini_esp32_thickness, 1.5 * wall);
		translate([-w2 - tolerance, d1_mini_esp32_reset_cutout, 0])
			clip(d1_mini_esp32_length - d1_mini_esp32_reset_cutout + eps, d1_mini_esp32_thickness, 1.5 * wall);
	}
}

module bottom() {
	difference() {
		union() {
			linear_extrude(2 * wall)
				box_shape();
			linear_extrude(wall, convexity = 3)
				offset(wall) box_shape();
		}
		
		pilar_pos()
			cylinder(d = 3.2, h = 5 * wall, center = true);
		d = 5.2 + tolerance;
		pilar_pos(-eps)
			cylinder(d1 = d + 2 * tolerance, d2 = d, h = wall + eps);
			
	}
	translate([box_usb_offset, box_length, 2 * wall])
		rotate(180)
			render()
				d1_mini_esp32_holder();
}

intersection() {
	if (part == "bottom") {
		bottom();
	} else if (part == "top") {
		top();
	} else {
		bottom();
		translate([0, 0, 48]) rotate([0, 180, 0]) union() {
			translate([0, 0, -box_height-wall]) top();
			translate([-raster / 2, (box_length - pcb_length) / 2, 25])
				rotate([0, 180, 0])
					pcb();
		}
		translate([box_usb_offset, box_length, 2 * wall + d1_mini_esp32_standoff])
			rotate(180)
				d1_mini_esp32();
	}
	*translate([-50, 55, -10]) cube([100, 18, 15]);
}

$fa = 4; $fs = 0.2;
eps = 0.01;
raster = 2.54;
