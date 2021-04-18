#!/bin/bash

MAIN=./scad/main.scad
PRESETS=./scad/main.json
OUT_DIR=./stl
FN=100

#bases and lids
openscad $MAIN -p $PRESETS  -P "6 mm - straight" -D "part_select_cmd=1" -D "\$fn=$FN" -o ${OUT_DIR}/6.0_base.stl
openscad $MAIN -p $PRESETS  -P "8 mm - straight" -D "part_select_cmd=1" -D "\$fn=$FN" -o ${OUT_DIR}/8.0_base.stl
openscad $MAIN -p $PRESETS  -P "6 mm - straight" -D "part_select_cmd=3" -D "\$fn=$FN" -o ${OUT_DIR}/6.0_lid.stl
openscad $MAIN -p $PRESETS  -P "8 mm - straight" -D "part_select_cmd=3" -D "\$fn=$FN" -o ${OUT_DIR}/8.0_lid.stl

#different arms
openscad $MAIN -p $PRESETS  -P "6 mm - straight" -D "part_select_cmd=2" -D "\$fn=$FN" -o ${OUT_DIR}/6.0_arm_straight.stl
openscad $MAIN -p $PRESETS  -P "8 mm - straight" -D "part_select_cmd=2" -D "\$fn=$FN" -o ${OUT_DIR}/8.0_arm_straight.stl
openscad $MAIN -p $PRESETS  -P "6 mm - helical/right/3.5" -D "part_select_cmd=2" -D "\$fn=$FN" -o ${OUT_DIR}/6.0_arm_helical-right-3.5.stl
openscad $MAIN -p $PRESETS  -P "8 mm - helical/right/3.5" -D "part_select_cmd=2" -D "\$fn=$FN" -o ${OUT_DIR}/8.0_arm_helical-right-3.5.stl 

#full jigs
openscad $MAIN -p $PRESETS  -P "6 mm - straight" -D "part_select_cmd=0" -D "\$fn=$FN" -o ${OUT_DIR}/jig_6.0_straight.stl
openscad $MAIN -p $PRESETS  -P "8 mm - straight" -D "part_select_cmd=0" -D "\$fn=$FN" -o ${OUT_DIR}/jig_8.0_straight.stl
openscad $MAIN -p $PRESETS  -P "6 mm - helical/right/3.5" -D "part_select_cmd=0" -D "\$fn=$FN" -o ${OUT_DIR}/jig_6.0_helical-right-3.5.stl
openscad $MAIN -p $PRESETS  -P "8 mm - helical/right/3.5" -D "part_select_cmd=0" -D "\$fn=$FN" -o ${OUT_DIR}/jig_8.0_helical-right-3.5.stl