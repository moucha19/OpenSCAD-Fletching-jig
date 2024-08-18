#!/bin/bash

MAIN=./scad/main.scad
PRESETS=./scad/main.json
OUT_DIR=./stl
FN=100

if command -v openscad &> /dev/null
then
    # Use the system package
    OPENSCAD_CMD="openscad"
elif flatpak list | grep -q "OpenSCAD"
then
    # Use the Flatpak command
    OPENSCAD_CMD="flatpak run org.openscad.OpenSCAD"
else
    # If neither is available, print an error message and exit
    echo "Error: OpenSCAD is not available. Please install it as a system package or via Flatpak."
    exit 1
fi

# Enable manifold for versions >= 2023.03
OPENSCAD_VERSION=$($OPENSCAD_CMD --version 2>&1 | tr -cd '0-9')
ARGS=""
if [[ $OPENSCAD_VERSION -gt 20230300 ]]; then
    ARGS="--enable manifold"
fi

mkdir -p $OUT_DIR

#bases and lids
$OPENSCAD_CMD $ARGS $MAIN -p $PRESETS  -P "6 mm - straight" -D "part_select_cmd=1" -D "\$fn=$FN" -o ${OUT_DIR}/6.0_base.stl
$OPENSCAD_CMD $ARGS $MAIN -p $PRESETS  -P "8 mm - straight" -D "part_select_cmd=1" -D "\$fn=$FN" -o ${OUT_DIR}/8.0_base.stl
$OPENSCAD_CMD $ARGS $MAIN -p $PRESETS  -P "6 mm - straight" -D "part_select_cmd=3" -D "\$fn=$FN" -o ${OUT_DIR}/6.0_lid.stl
$OPENSCAD_CMD $ARGS $MAIN -p $PRESETS  -P "8 mm - straight" -D "part_select_cmd=3" -D "\$fn=$FN" -o ${OUT_DIR}/8.0_lid.stl

#different arms
$OPENSCAD_CMD $ARGS $MAIN -p $PRESETS  -P "6 mm - straight" -D "part_select_cmd=2" -D "\$fn=$FN" -o ${OUT_DIR}/6.0_arm_straight.stl
$OPENSCAD_CMD $ARGS $MAIN -p $PRESETS  -P "8 mm - straight" -D "part_select_cmd=2" -D "\$fn=$FN" -o ${OUT_DIR}/8.0_arm_straight.stl
$OPENSCAD_CMD $ARGS $MAIN -p $PRESETS  -P "6 mm - helical/right/3.5" -D "part_select_cmd=2" -D "\$fn=$FN" -o ${OUT_DIR}/6.0_arm_helical-right-2deg.stl
$OPENSCAD_CMD $ARGS $MAIN -p $PRESETS  -P "8 mm - helical/right/3.5" -D "part_select_cmd=2" -D "\$fn=$FN" -o ${OUT_DIR}/8.0_arm_helical-right-2deg.stl 

#full jigs
$OPENSCAD_CMD $ARGS $MAIN -p $PRESETS  -P "6 mm - straight" -D "part_select_cmd=0" -D "\$fn=$FN" -o ${OUT_DIR}/jig_6.0_straight.stl
$OPENSCAD_CMD $ARGS $MAIN -p $PRESETS  -P "8 mm - straight" -D "part_select_cmd=0" -D "\$fn=$FN" -o ${OUT_DIR}/jig_8.0_straight.stl
$OPENSCAD_CMD $ARGS $MAIN -p $PRESETS  -P "6 mm - helical/right/3.5" -D "part_select_cmd=0" -D "\$fn=$FN" -o ${OUT_DIR}/jig_6.0_helical-right-2deg.stl
$OPENSCAD_CMD $ARGS $MAIN -p $PRESETS  -P "8 mm - helical/right/3.5" -D "part_select_cmd=0" -D "\$fn=$FN" -o ${OUT_DIR}/jig_8.0_helical-right-2deg.stl