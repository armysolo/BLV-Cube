; ran when external trigger is triggered
; quick press turns printer on
; long press turns printer off
M80							; Power on
G4 P200						; wait 2ms
M98 P"config.g"				; run config.g to recognize toolboard
G4 P200						; wait 2ms
if sensors.gpIn[1].value = 1 	; check if button still pressed
	M291 P"Power off" S1 T2 	;
	G4 S1						; give time to let go of the button to prevent accidental power on
    M81 						; turn off power
