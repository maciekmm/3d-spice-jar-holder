include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

$fn=50;
$vpd=1000;

back_wall=4;

jar_diameter=44;
jar_spacing=1;
effective_diameter = jar_diameter + jar_spacing;
between_jars=5;
jar_height=102;
jar_cap_height=24;
jar_base_height=jar_height-jar_cap_height;


jars=1;

//shelf_height=215;
shelf_height=between_jars * (jars + 0.5) + jars*effective_diameter;
echo(shelf_height*4);
shelf_width=93;
shelf_depth=jar_base_height + 0.03*jar_base_height + back_wall;

stopper_offset=3;
stopper_thickness=3;



module jar() {

	color("black")
		cylinder(h=jar_base_height, d=effective_diameter, center=true);
	color("red")
		translate([0, 0, (jar_base_height+jar_cap_height)/2])
			cylinder(h=jar_cap_height, d=effective_diameter, center=true);
}

module shelf() {
	union() {
		translate([0,0,shelf_height/2])
			difference() {
				cube([shelf_width, shelf_depth, shelf_height], center=true);
				translate([0, shelf_depth/2-back_wall-1.5,0]) {
				rotate([0,90,90]) {
					linear_extrude(height=back_wall+1.5) {
						grid2d(n=[4,7], spacing=13) {
							hexagon(od=11.5, rounding=1);
						}
					}
				}
				}
			}

		stopper_width=shelf_width+stopper_offset*2;
		stopper_height=shelf_height;
		translate([-stopper_width/2,-stopper_thickness-shelf_depth/2,0])
			cube([stopper_width, stopper_thickness, stopper_height]);
	}
}


difference() {
	shelf();
	zcopies(spacing=effective_diameter+between_jars, n=jars, sp=[0, 0, 0]) {
			union() {
				translate([0,0,effective_diameter/2+between_jars/2]) {
					rotate([-3,0,0]) {
						rotate([90,0,0]) {
							xcopies(spacing=effective_diameter + 1, n=2) jar();
						}
					}
				}
				translate([0,0, effective_diameter/2 + between_jars/2 + 1]) {
					rotate([-3,0,0]) {
						rotate([0,90,0]) {
							linear_extrude(shelf_width, center=true)
								grid2d(n=[4, 6], spacing=12)
									hexagon(od=10, rounding=1);
						}
					}
				}
			}
	}
}


