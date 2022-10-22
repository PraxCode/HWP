	org 100h
	cpu 8086

	jmp START

LED1	equ 90h
LED2	equ 92h
LED3	equ 94h
LED4	equ 96h
LED5	equ 98h
LED6	equ 9ah
LED7	equ 9ch
LED8	equ 9fh

ZERO	equ 00111111b
ONE	equ 00001110b
TWO	equ 01011011b
THREE	equ 01001111b
FOUR	equ 01100110b
FIVE	equ 01101101b
SIX	equ 01111101b
SEVEN 	equ 00000111b
EIGHT	equ 01111111b
NINE	equ 01101111b
A	equ 01110111b
B	equ 01111100b
C	equ 00111001b
D	equ 01011110b
E	equ 01111001b
F	equ 01110001b

TAB	db 00111111b
	
START:	in al, 0 ; Read LED Port
	out 0, al 

	out LED1, al
	out LED2, al
	out LED3, al
	out LED4, al
	out LED5, al
	out LED6, al
	out LED7, al
	out LED8, al
	jmp START
