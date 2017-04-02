/*$fn=4;*/
$fa = 2;
$fs = .2;

include <thing_libutils/system.scad>
include <thing_libutils/units.scad>

use <thing_libutils/shapes.scad>

use <MCAD/boxes.scad>

module galaxy_s5()
{
    translate([-36.5,-73,-5]) import("SAMSUNG GALAXY S5.STL");
}

cable_radius=2;

pad_width = 73;
pad_thickness = 9.5;
pad_spacing = 0.1;

pad_from_floor = 35;
pad_pos = pad_width/2+pad_from_floor;

width = pad_width+5;
height = pad_from_floor+pad_width;
thickness = pad_thickness+5;

rot_degrees = -25;

pad_offset = -0.8;

phone_width = 72.5;
phone_thickness = 11;

bottom_height = 9;

cable_connector_width = 15;
cable_connector_height = 27;
cable_connector_thickness = 8;

phone_well_wall_thickness = 3*mm;
phone_well_thickness = phone_thickness+5*mm;
phone_well_height = 5*mm;

module upright()
{
    // main body
    translate(Z*5*mm)
    difference()
    {
        rcubea(size=[width,thickness,height], align=Z);

        union()
        {
            translate([0,pad_offset,pad_pos])
            {
                rcubea(
                    size=[pad_width+pad_spacing,pad_thickness,pad_width+pad_spacing],
                    extrasize=[0,0,10],
                    extrasize_align=Z);

                rcubea(
                    size=[pad_width+pad_spacing-5,pad_thickness,pad_width+pad_spacing],
                    extrasize=[0,6,10],
                    extrasize_align=-Y+Z);
            }
        }

        cylinder(r=cable_radius, h=100);

        // charging pad
        translate([0,pad_offset,pad_pos])
        rotate([90,0,0])
        roundedBox([pad_width,pad_width,pad_thickness], 13, true);
    }
}

module phone_well(part)
{
    if(part=="pos")
    {
        rcubea(
            size=[width,phone_well_thickness,phone_well_height],
            align=Z,
            extrasize=Y*phone_well_wall_thickness+Z*phone_well_height,
            extrasize_align=-Y+Z);
    }
    else if(part=="neg")
    {
        rcubea(
            size=[phone_width+2,phone_well_thickness,phone_well_height],
            align=Z,
            extrasize=Z*1000,
            extrasize_align=Z);

        translate(Y*-1)
        translate(Z*4)
        rcubea(
            size=[20,100,1000],
            align=Z-Y);
    }
}

module dock()
{
    difference()
    {
        union()
        {
            rotate([rot_degrees,0,0])
            upright();

            hull()
            {
                rotate([rot_degrees,0,0])
                translate(-Y*(thickness))
                phone_well(part="pos");

                // main body
                rcubea(
                    size=[width,width-30,bottom_height],
                    align=Y+Z,
                    extrasize=Y*(phone_well_thickness+3.2*mm),
                    extrasize_align=-Y);
            }

            /*translate([0,phone_offset-2,pad_pos])*/
            /*rotate([90,0,0])*/
            /*#galaxy_s5();*/
        }

        rotate([rot_degrees,0,0])
        translate(-Y*(thickness/2+phone_well_thickness/2))
        phone_well(part="neg");

        // vertical cable cutout
        rotate([rot_degrees,0,0])
        translate([0,0,5])
        translate([0,pad_offset,pad_pos])
        rotate([90,0,0])
        translate([0,-45,0])
        rcubea(
            size=[cable_connector_width,cable_connector_height,cable_connector_thickness],
            extrasize=Y*50,
            extrasize_align=-Y);

        // cable cutout trench
        translate([0,0,1])
        {
            cubea(size=[cable_radius*2,width-20,cable_radius*2], align=Y+Z);
            cubea(size=[cable_radius*5,10,cable_radius*7], align=Y+Z);
        }

        cubea(size=[cable_radius*1.3,width-20,cable_radius*1.3], align=Y+Z);
    }
}

dock();


