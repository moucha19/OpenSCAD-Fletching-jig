#!/bin/bash

sed -e '/use <components.scad>/{r ./scad/components.scad' -e 'd}' ./scad/fletching_jig.scad > ./tmp.scad
grep -v -e '^\s*//' -e '^\s*$' -e '^\s*[[:alpha:]]*_treshold' ./tmp.scad > ./doc/squashed.scad
echo -e "\n\$fn=30;\njig(part_select=0, fn=30);" >> ./doc/squashed.scad
rm tmp.scad
