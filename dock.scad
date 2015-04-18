$fn=100;

//use <MCAD/shapes.scad>
use <MCAD/boxes.scad>

module size_align(size=[10,10,10], align=[0,0,0])
{
    translate([align[0]*size[0]/2,align[1]*size[1]/2,align[2]*size[2]/2])
    {
        children();
    }
}

module cubea(size=[10,10,10], align=[0,0,0], extrasize=[0,0,0], extrasize_align=[0,0,0])
{
    size_align(extrasize,extrasize_align)
    {
        size_align(size,align)
        {
            cube(size+extrasize, center=true);
        }
    }
}

module galaxy_s5()
{
    translate([-36.5,-73,-5]) import("SAMSUNG GALAXY S5.STL");
}

module upright()
{
    // main body
    difference()
    {
        cubea([width,thickness+5,height],[0,0,1],[0,0,0],[0,1,0]);

        union()
        {
            translate([0,pad_offset,pad_pos])
            {
                cubea([pad_width+pad_spacing,pad_thickness,pad_width+pad_spacing],[0,0,0], [0,0,10], [0,0,1]);
                cubea([pad_width+pad_spacing-5,pad_thickness,pad_width+pad_spacing],[0,0,0], [0,6,10], [0,-1,1]);
            }
        }
        cylinder(r=cable_radius,h=100);

        // charging pad
        translate([0,pad_offset,pad_pos])
            rotate([90,0,0])
            roundedBox([pad_width,pad_width,pad_thickness], 13, true);
    }
}


cable_radius=2;

pad_width = 73;
pad_thickness = 9.5;
pad_spacing = 0.1;

pad_from_floor = 35;
pad_pos = pad_width/2+pad_from_floor;

width = pad_width+5;
height = pad_from_floor+pad_width;
thickness = pad_thickness;

rot_degrees = -25;

pad_offset = -0.8;

phone_width = 72.5;
phone_thickness = 11;
phone_offset = -11.5;

bottom_height = 9;

cable_connector_width = 15;
cable_connector_height = 27;
cable_connector_thickness = 8;

phone_well_wall_thickness = 3.5;
phone_well_thickness = phone_thickness+5;
phone_well_height = 8;

module phone_well()
{
    // s5 holder/well
    translate([0,phone_offset,0])
    {
        difference()
        {
            cubea([width,phone_well_thickness+phone_well_wall_thickness,phone_well_height],[0,0,1],[0,0,0],[0,1,0]);

            cubea([phone_width+2,phone_well_thickness,phone_well_height],[0,0,1],[0,0,10],[0,0,1]);
        }
    }
}

module dock()
{
    difference()
    {
        union()
        {
            rotate([rot_degrees,0,0])
            {
                translate([0,0,5])
                    upright();

                phone_well();

                /*translate([0,phone_offset-2,pad_pos])*/
                /*rotate([90,0,0])*/
                /*#galaxy_s5();*/
            }


            // main body
            cubea([width,width-30,bottom_height],[0,1,1],[0,phone_well_thickness+3.2,0],[0,-1,0]);
        }


        rotate([rot_degrees,0,0])
        {
            translate([0,0,5])
            {
                translate([0,pad_offset,pad_pos])
                {
                    rotate([90,0,0])
                    {
                        translate([0,-45,0])
                        {
                            // vertical cable cutout
                            cubea([cable_connector_width,cable_connector_height,cable_connector_thickness],[0,0,0],[0,50,0],[0,-1,0]);
                        }
                    }
                }
            }


        }

        // cable cutout trench
        translate([0,0,1])
        {
            cubea([cable_radius*2,width-20,cable_radius*2],[0,1,1],[0,0,0],[0,-1,0]);
            cubea([cable_radius*5,10,cable_radius*7],[0,1,1],[0,0,0],[0,-1,0]);
        }

        cubea([cable_radius*1.3,width-20,cable_radius*1.3],[0,1,1],[0,0,0],[0,-1,0]);
    }
}

dock();


