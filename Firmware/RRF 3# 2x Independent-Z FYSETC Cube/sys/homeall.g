; homeall.g
; called to home all axes
;
; generated by Ben Levi and David Husolo

G91                     ; relative positioning
G1 H2 Z5 F6000          ; lift Z relative to current position
G1 H1 X-355 Y355 F6000  ; move quickly to X-min and Y-max endstop 
G1 H1 X-355             ; home X-min
G1 H1 Y355              ; home Y-max
G1 X5 Y-5 F6000         ; go back a few mm
G1 H1 X-355 F360        ; move slowly to X-min endstop once more (second pass)
G1 H1 Y355              ; then move slowly to Y-max endstop
G90                     ; absolute positioning
G1 X181.95 Y143.2 F10000 		; go to center of the bed
G30                     ; home Z by probing the bed