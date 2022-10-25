		org 100h
		cpu 8086

		jmp START

LEDL:		equ 94h
LEDR:		equ 92h
LEDh:		equ 90h

ARR: 		db 00111111b, 00000110b, 01011011b, 01001111b, 01100110b, 01101101b, 01111101b, 00000111b, 01111111b, 01101111b, 01110111b, 01111100b, 00111001b, 01011110b, 01111001b, 01110001b
H:		equ 01110100b

START:	mov al, H
		mov cl, 4
		out LEDh, al
		in al, 0
		AND al, 00001111b
		mov dl, al
		in al, 0
		AND al, 11110000b
		shr al, cl
		SBB dl, al
		mov al, dl
		out 0, al
		lea bx, ARR
		xlat
		out LEDR, al
		jmp START

