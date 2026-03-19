![](./doc/img/icon_80px.png)
# OpenSCAD Fletching jig

## Overview
Simple yet effective fletching jig that will adjust to all your needs. Intended to provide new archers with access to 3D printer cheap way to fix broken arrows without a need for expensive off-the-shelf jig. Hopefully, even skilled shooters may find utility in this design.

### Features

+ highly adjustable to fit different arrows and vanes
+ supports both 3 and 4 vanes
+ straight, offset and **true** helical fletchings
+ features optional nock alignment
+ no additional tools required for assembly
+ hot swappable arms
+ very compact and light 

## Quick start

### Online Playground (no install)

1. Open the [Online Playground](https://ochafik.com/openscad2/#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).
2. Project is already preloaded. Tweak the parameters for your needs, render and export the model as STL directly from the browser. 

### Desktop workflow (OpenSCAD)

Although I provide several pre-rendered files as an example, it is very likely that you will not like something about them. If some of the parameters do not fit your setup or you simply want to enable some special features mentioned above, you will have to change the relevant parameters in the OpenSCAD customizer and render a new, unique jig yourself. Don't worry though, it is very simple!

#### Prerequisites

For the desktop workflow, first download latest version (2019.05 or newer) of [OpenSCAD](http://www.openscad.org/downloads.html). It's free and open source software available for all major desktop platforms. Nothing else is needed for editing and rendering.

Additional software required will vary depending on your 3D printer.

#### Steps

1. Download and extract [latest release](https://github.com/moucha19/OpenSCAD-Fletching-jig/releases) of this project somewhere on your PC.
2. Locate [main.scad](./scad/main.scad) and open it in OpenSCAD. 
3. Go to the **Customizer** section:
   - **Windows/Linux**: Click on `Window` in the top menu and select `Customizer`.
   - **macOS**: Click on `View` in the top menu, then select `Customizer`.
4. The Customizer panel will appear on the right side of the OpenSCAD interface.
   - If you don't need to see or edit the code, you can close the editor window on the left to focus solely on the Customizer and 3D view.
5. Adjust the parameters:
   - You will see a list of customizable parameters, such as dimensions and features. See the table below for the detailed description or refer to [parameter reference drawing](./doc/parameter-reference.pdf).
   - Modify these parameters as needed to customize your model.
   - I did all i could to prevent user from inserting invalid values, but there could still be ways to generate completely invalid design - so be reasonable. I'd advise you to change parameters you're sure about first (arrow_diameter, vane_length etc.) and then adjust the rest.
6. **Preview your changes** in real-time. The 3D model will update automatically as you adjust the parameters.
7. Once you're satisfied with the customization, you can render the model (`F6`) and export it to your desired format with `File > Export > ...`.
   - By default, you will get file with every jig part. However, by changing `part_select` parameter, you can isolate individual parts in their correct orientation for 3D printing. This way you can split the jig into multiple files.

### Parameters

Parameter | Description | Thresholds
--- | --- | ---
base_style | choose the base shape | `"polygon"` or `"star"`
lid_style | choose the outer lid shape | `"polygon"` or `"star"`
joint_style | either snap-in ball joints or pin joints | `"ball"` or `"pin"`
arrow_diameter | slightly bigger than the arrow itself (may vary depending on your printer) | 2 < ■
arrow_offset | distance between the bottom of the base and arrow | 0 < ■ < `base_height`
base_height | height of the base | 5 < ■
hinge_width | width of the hinge cutout on the base | 2.1 < ■ < *depends on arrow_diameter*
hinge_thickness | thickness of the hinge extension attached to the bottom of the arm | 1 < ■ < *depends on hinge_width and joint_diameter*
hinge_diameter | diameter of the circular part of the hinge that revolves around a joint | 2 < ■ < `hinge_depth`
hinge_depth | how deep into the base is the hinge cutout | 5 < ■ < `base_height`
joint_diameter | diameter of the joint that connects two halves of the hinge together | 0 < ■ < *depends on joint_style*
arm_gap | gap for the vane foot, so that tension during clamping is distributed evenly and the vane fits in the closed jig | 0 < ■ < 1.5
arm_offset | distance between the top of the base and bottom of the arm | 0 < ■ < 1.5 
vane_count | number of vanes, typically 3 or 4 | 2 < ■ 
vane_style | changes shape of the vane | `"straight"` or `"helical"`
vane_length | length of the vane | 0 < ■
vane_width | width of the vane | 0 < ■ < *in the console*
vane_offset | how far from the end of the arrow will the vane be | *in the console* < ■
vane_turn | sets rotation of the fletching in degrees, negative values flip the direction | ■ < *in the console*
nock | choose whether to add a nock alignment guide and if so, how you want to rotate it | `"none"`, `"static"` or `"optimal"`
nock_width | width of the nock guide, smallest point of the arrow nock | 0 < `arrow_diameter`
nock_height | depth of nock in your arrow, this will be the height of the nock guide | 0 < `(base_height - arrow_offset)`
nock_diameter | if the nock alignment guide is enabled, this value takes precedence over `arrow_diameter` for the base hole when the nocked arrow is wider than bare shaft | 0 < ■

![](./doc/img/parameter-reference-readme.svg)

### Thresholds

Like I already mentioned, I've take some precautions to ensure a valid outputs.

First are constrained sliders in customizer. These are set to accommodate even extreme values and should be sufficient for everyone. They're nothing more than recommendations though and even values beyond their range may work just fine. If - for any reason - you'd want to allow values outside of default range, you can do so in `main.scad` by editing lines just like this one:

```openscad
//distance between the bottom of the base and arrow
arrow_offset = 3;//[0:0.1:100] 
```
where comment behind the assignment means *[min:precision:max]*. Go to [customizer documentation](https://customizer.makerbot.com/docs) for more information.

Second are thresholds in the module itself that are actually checking if desired parameters make sense or not. For example, if you have small jig for 6mm arrows, you can't have 10 centimeter wide hinge. So even if you're able to set something like this in the customizer, invalid parameters will be truncated in the module to a closest valid value. If this happens, you'll be informed about it in the console window with similar line:

> hinge_thickness threshold (max = 5.25) reached!

List of some thresholds is in the table above. Some extreme values may still produce invalid results. That could either be because fixing it is more trouble than it's worth or because calculation of thresholds is impossible. Or it can simply be an oversight on my part. If you think something can be improved or you discover a bug, raise an issue or submit PR. 

Also, not all parameters are available in the customizer. Some of them do not change and should not have an effect on the validity of the generated output. However, if you did some testing and think some of these default values could be adjusted to generate better results, let me know.


## Printing recommendations

These settings were tested on Prusa MK2S. You might need to adjust them slightly.

Part | Layer height | Infill | Supports | Bed placement
--- | --- | --- | --- | --- 
Arm | 0.15mm or better | 15% | none / 3mm brim | ![](./doc/img/bed_arm.png)
Base | 0.2mm or better  | 15% | none | ![](./doc/img/bed_base.png)
Lid | 0.35mm | solid | none | ![](./doc/img/bed_lid.png)

***

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
