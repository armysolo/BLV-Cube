## Firmware
I will only update my configuration files for the latest released versions. I won't do it for the beta versions because they change too frequent. If you find any issues PM me on Facebook. I'm trying to highlight any useful or important information so if I missed something I apologize.  

Make sure your M208 in config.g is configured correctly for max and min.  

Firmware versions:  
Duet 2 Wifi RRF 3.4  
Cube Duet 3 RRF 3.4  

If upgrading from Duet RRF2 you need to update to RRF3.0.0 before going to the latest released version. After updating to RRF3.0.0 you can go to RRF3.#.#.  

https://duet3d.dozuki.com/Wiki/Installing_and_Updating_Firmware#Section_Upgrading_a_Duet_WiFi_Ethernet_Maestro_from_firmware_2_x_to_3_01_or_later  

There are a number of changes in RRF3 which makes some of the RRF2 Gcode incompatible.  

https://duet3d.dozuki.com/Wiki/RepRapFirmware_3_overview#Section_Summary_of_what_you_need_to_do_to_convert_your_configuration_and_other_files  

Become familiar with the firmware. Learn to troubleshoot and use the Duet resources. You'll learn more if figure it out on your own vs always asking someone to fix it for you. Make sure you're using the latest version of the firmware.  

I've personally spent hundreds of hours writing instructions and how to guides for the FYSETC kit. Even if you don't have a FYSETC kit these guides can still be extremely beneficial.  
https://www.ifixit.com/Device/BLV_MGN_Cube  

After your build is assembled and firmware configured, DO THE COMMISSION TESTING!!!! I can't stress that enough. It can prevent damage to the printer or the main board.  

https://duet3d.dozuki.com/Wiki/Step_by_step_guide#Section_Commissioning_tests  

Duet Resources/Useful links  
https://duet3d.dozuki.com/Wiki/Getting_Started_With_Duet_3  
https://duet3d.dozuki.com/Wiki/Step_by_step_guide  
https://duet3d.dozuki.com/Wiki/Gcode  
https://duet3d.dozuki.com/Wiki/Bed_levelling_using_multiple_independent_Z_motors  
https://duet3d.dozuki.com/  
https://forum.duet3d.com/  
https://www.blvprojects.com/  

## RRF3.4 Update  
If updating to RRF3.4 you will need to modify your M80 config.  
Pre RRF3.4 `M80`  
RRF3.4 `M80 C"pson"`  

## Bed Probe Configuration  
For a BLTouch-  
1. In config.g you need to define 3 things:  
`M950 S0 C"exp.heater3"                                   	; create servo/PWM channel and assign to exp.heater3 pin`  
`M558 P9 C"^zprobe.in" H5 F300 T9000                     	; P9 = BLTOUCH, C PWM pin, H# = dive height, F = dive speed, T = travel speed`  
`G31 P500 X-42.45 Y0 Z1.370                                ; P = Z probe trigger value, XY = offset from nozzle, Z = trigger height`  

2. You need 2 files:  
A. deployprobe.g  
  `M280 P0 S10				; P = servo/PWM channel defined in config.g`  
B. retractprobe.g  
  `M280 P0 S90 I1				; P = servo/PWM channel defined in config.g`  


## Endstop Locations  
Configs have the X Endstop on the left of the carriage(homing to min) and the Y endstop at the back(homing to max).  
`M574 X1 S1 P"io1.in"  
M574 Y2 S1 P"io2.in"`  
X1 = Home to min  
Y2 = Home to max  
S1 = Microswith endstop  

If homing isn't working correctly:  
1. Make sure your motors move in the correct direction.  
A. Jog X. - will move left, + will move right.  
B. Jog Y. - will move towards the front, + will move back.  
Stepper wire colors are not universal. If they're moving the opposite direction change the S parameter in M569 P# S#. If you're not sure which one to change, check the drive mapping in M584.  
`M584 X0.1 Y0.2`  
Changing `M569 P0.1 S0` to `M569 P0.1 S1` will invert the direction of X because it's assigned to driver 0.1.  

2. If you get an error that says "failed to trigger endstop during homing" your homing files might be incorrect. 
homex.g example:  
`G91               ; relative positioning`  
`G1 H2 Z5 F1000     ; lift Z relative to current position`  
`G1 H1 X-355 F6000 ; move quickly to X axis endstop and stop there (first pass)`  
`G1 X5 F6000       ; go back a few mm`  
`G1 H1 X-355 F360  ; move slowly to X axis endstop once more (second pass)`  
`G1 H2 Z-5 F1000      ; lower Z again`  
`G90               ; absolute positioning`  

If you need to home X to max change these 3 lines in homex.g and the corresponding ones in homeall.g  
`G1 H1 X355 F6000 ; move quickly to X axis endstop and stop there (first pass)`  
`G1 X-5 F6000       ; go back a few mm`  
`G1 H1 X355 F360  ; move slowly to X axis endstop once more (second pass)`  
And change the switch location in config.g  
`M574 X2 S1 P"io1.in"`

# Independent leveling:  
You must use M671 to define the X and Y coordinates of the leadscrews.  
M671 must come after the M584, M667 or M669.  
Must specify the same quantity of X and Y coordinates as the number of motors assigned to the Z axis in M584  
These coordinates must be in the same order as the driver numbers of the associated motors in M584. 
Define it with the physical location in relation to the nozzle. The S parameter is for the max allowed adjustment.  
G30 defines where the head will probe to calculate the offset.  

**3 independent Z steppers with Kinematic Leveling**  
Physical coordinates of the pivot points, NOT the lead screw. These will be out of your printable range `M671 X###:###:### Y###:###:### S##`  
Define the driver in config.g `M584 Z0.3:0.4:0.5` 

In bed.g  
`G30 P0 X55 Y161 Z-99999 ; Probe near left lead screw position`  
`G30 P1 X328 Y301 Z-99999 ; Probe near right rear lead screw position` 
`G30 P1 X328 Y30 Z-99999 S3 ; Probe near right front lead screw position` 

**2 Z motors**  
One at each end of the X axis  
Set the Y coordinates of the leadscrews in M671 to be equal (the value doesn't matter, so you can use zero).  
Use at least two probe points, one at each end of the X axis.  
All your probe points should have the same Y coordinate, which should be at or near the middle of the printable range.  

Define the driver in config.g `M584 Z0.3:0.4`  
`M671 X-48.5:360 Y150:150 S10`  
The order the coordinates appear are important. The stepper located at -48.5,150 must be connected to driver 3  
The stepper located at 360,150 must be connected to driver 4  

In bed.g  
`G30 P0 X55 Y161 Z-99999 ; Probe near left lead screw position`  
`G30 P1 X328 Y161 Z-99999 S2 ; Probe near right lead screw position`  


-Note: If you are experiencing the Z axis compensating in the opposite direction needed, that means your Z motors are swapped. 
You can either swap the X values in the M671 command, or swap the stepper motors plugged into the Duet.
