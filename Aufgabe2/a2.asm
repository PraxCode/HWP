	org 100h
	cpu 8086



LED_L equ 94h
LED_R equ 92h
LED_h equ 90h

ZERO	db 00111111b
ONE	  db 00001110b
TWO	  db 01011011b
THREE	db 01001111b
FOUR	db 01100110b
FIVE	db 01101101b
SIX	  db 01111101b
SEVEN db 00000111b
EIGHT	db 01111111b
NINE	db 01101111b
A	    db 01110111b
B	    db 01111100b
C	    db 00111001b
D	    db 01011110b
E	    db 01111001b
F	    db 01110001b
	
START:
  in al, 0; Port 0 in al ; z. B. 0000'0000
  out 0, al
  mov ah, ZERO
  add al, ah; Calculate Offset

  out 90h, al
	jmp START
