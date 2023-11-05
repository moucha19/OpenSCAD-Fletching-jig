#!/bin/bash

sed -e '/use <hinge.scad>/{r ./scad/hinge.scad' -e 'd}' ./scad/fletching_jig.scad > ./tmp.scad
sed -i -e '/use <components.scad>/{r ./scad/components.scad' -e 'd}' ./tmp.scad
grep -v -e '^\s*//' -e '^\s*$' -e '^\s*.*_treshold' ./tmp.scad > ./doc/squashed.scad
rm tmp.scad
