; homez.g
; called to home the Z axis
;
; generated by Ben Levi and David Husolo

G91                 		; relative positioning
G1 H2 Z5 F6000      		; lift Z relative to current position
G90                		 	; absolute positioning
G1 X143.5 Y89.2 F10000 		; go to first probe point
G30                 		; home Z by probing the bed