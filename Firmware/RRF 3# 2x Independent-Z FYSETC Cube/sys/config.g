; Configuration file for Duet WiFi (firmware version 3)
; executed by the firmware on start-up
;
; generated by Ben Levi and David Husolo

; ================= General preferences ===================
M80															; Turns on the ATX power supply
;G90                                                     	; send absolute coordinates...
;M83                                                     	; ...but relative extruder moves-Remove and use slicer profile or starting macro to set M82/M83
M550 P"FYSETC BLV Cube"                                     ; set printer name
M669 K1														; Select CoreXY mode

; ====================== Network ===========================
M552 S1                                                 	; enable network
;M552 P192.168.1.50											; set IP Address
;M587 P"Cowabunga" S"Sexywife16" I192.168.1.50				; Connect WiFi and set IP address
;M586 P0 S1                                              	; enable HTTP
;M586 P1 S0                                              	; disable FTP
;M586 P2 S0                                              	; disable Telnet

; ======================= Drives ===========================
M569 P0 S1                                              	; physical drive 0 goes forwards
M569 P1 S1                                              	; physical drive 1 goes backwards
M569 P2 S1                                              	; physical drive 2 goes backwards
M569 P3 S1                                              	; physical drive 3 goes backwards
M569 P4 S1                                              	; physical drive 3 goes backwards
M584 X0 Y1 Z2:4 E3                                      	; set drive mapping Z2=Left, Z4=Right

; ===================== Drive Settings =====================
M350 X16 Y16 Z16 E16 I1                            			; configure microstepping with interpolation
M92 X200.00 Y200.00 Z400.00 E405.00               			; set steps per mm 100/102.5=.0975 * 415.15
M566 X700.00 Y700.00 Z24.00 E1000.00                   		; set maximum instantaneous speed changes (mm/min)
M203 X35000.00 Y35000.00 Z800.00 E4000.00              		; set maximum speeds (mm/min)
M201 X6000.00 Y6000.00 Z100.00 E1500.00                 	; set accelerations (mm/s^2)
M906 X1600 Y1600 Z1600 E1000 I30                     	    ; set motor currents (mA) and motor idle factor in per cent
M84 S120	                               	                ; Set idle timeout

; ================ Independent Z Leveleing =================
M671 X-75.25:354.25 Y143.2:143.2 S10			   			   	; leadscrew pivot point:

; ===================== Axis Limits ========================
M208 X-35.5 Y0 Z0 S1                                      	; set axis min
M208 X320 Y326.8 Z340 S0                                  	; set axis max

; ======================= Endstops =========================
M574 X1 S1 P"xstop"                                     	; configure active-high endstop for low end on X via pin xstop
M574 Y2 S1 P"ystop"                                     	; configure active-high endstop for high end on Y via pin ystop
M574 Z1 S2                                              	; configure Z-probe endstop for low end on Z
;M591 D0 P1 C"e0stop" S1								    ; configure filament runout sensor for high end on extruder drive 0 via pin i03.in

; ======================== Z-Probe =========================
M950 S0 C"exp.heater3"                                  	; create servo pin 0 for BLTouch
M558 P9 C"^zprobe.in" H5 F300 T9000                     	; set Z probe type to bltouch and the dive height + speeds
G31 P500 X-42.45 Y0 Z1.370                                  ; set Z probe trigger value, offset and trigger height

; ======================== Heaters =========================
M308 S0 P"bedtemp" Y"thermistor" A"Bed" T100000 B3950 		; configure sensor 0 as thermistor on pin bedtemp
M950 H0 Q10 C"bedheat" T0                                   ; create bed heater output on bedheat and map it to sensor 0
M307 H0 B0 R0.450 C615.4 D2.65 S1.00 V24.1					; Heatbed PID
M140 H0                                                 	; map heated bed to heater 0
M143 H0 S120                                            	; set temperature limit for heater 0 to 120C
M308 S1 P"e0temp" Y"thermistor" A"Hotend" T100000 B4725 C0.06e-8  ; configure sensor 1 as thermistor on pin e0temp
M950 H1 C"e0heat" T1                                    	; create nozzle heater output on e0heat and map it to sensor 1
M307 H1 B0 R2.461 C155.7 D10.12 S0.90 V24.1					; Hotend PID .4mm
M143 H1 S260												; set temperature limit for heater 0 to 260C
M308 S2 P"mcu-temp" Y"mcu-temp" A"Duet Board" 				; Configure MCU sensor

; ========================= Fans ===========================
M950 F0 C"fan2" Q500                                    	; create fan 1 on pin fan1 and set its frequency
M106 P0 C"Layer fan" S0 H-1                             	; set fan 1 value. Thermostatic control is turned off
M950 F1 C"fan1" Q500                                    	; create fan 2 on pin fan2 and set its frequency
M106 P1 C"HE Fan" S1 H1 T40                             	; set fan 2 value. Thermostatic control is turned off

; ======================== Tools ===========================
M563 P0 D0 H1 F0                                   			; define tool 0
G10 P0 X0 Y0 Z0                                    			; set tool 0 axis offsets
G10 P0 R0 S0                                       			; set initial tool 0 active and standby temperatures to 0C

; ===================== Custom settings ====================
M564 H0                                   	            	; Let the Jog buttons work blv: added to allow jog buttons

; ====================== Miscellaneous =====================
M575 P1 S1 B57600                                       	; enable support for PanelDue
M911 S10 R11 P"M913 X0 Y0 G91 M83 G1 Z3 E-5 F1000" 			; set voltage thresholds and actions to run on power loss

;Duet 2 pinout-*=inverted
;bedheat * Bedheater
;e0heat * Hotend
;e1heat * NC
;exp.heater3 BLTouch S
;Duet 2 temperature inputs
;bedtemp Bed thermistor
;e0temp HE thermistor
;e1temp NC
;Duet 2 fan outputs
;fan0 MB Fan GND
;fan1 LY Fan GND
;fan2 HE Fan GND
;Endstop inputs
;xstop X Endstop C
;ystop Y Endstop C
;zstop NC
;e0stop Filament runout sensor C
;e1stop Off button C pin
;zprobe.in Z-
;zprobe.mod NC
