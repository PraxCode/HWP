		org 100h
		cpu 8086

		jmp start

; Variablen

status	db 00000000b	; Statusbyte
;		          ^
;		          |
;		          +-----> Ton (1, an) / (0, aus)

; Konstanten
intab0		equ 20h		; Adresse Interrupttabelle PIT, Kanal 1
intab1		equ intab0 + 1 * 4	; Adresse Interrupttabelle PIT, Kanal 2
intab7		equ intab0 + 7 * 4	; Adresse Interrupttabelle Lichttaster
eoi			equ 20h		; End Of Interrupt (EOI)
clrscr		equ 0		; Clear Screen
getkey		equ 1		; Funktion auf Tastatureingabe warten
ascii		equ 2		; Funktion ASCII-Zeichenausgabe
hexbyte		equ 4		; HEX-Byte Ausgabe
conin		equ 5		; Console IN
conout		equ 6		; Console OUT
pitc		equ 0a6h	; Steuerkanal PIT
pit1		equ 0a2h	; Counter 1 PIT
pit2		equ 0a4h	; Counter 2 PIT
ppi_ctl		equ 0b6h	; Steuerkanal PPI (Parallelinterface)
ppi_a		equ 0b0h	; Kanal A PPI
ppi_pa0		equ 1		; LED 0
ppi_pa1		equ 2		; LED 1
ppi_pa2		equ 4		; LED 2
ppi_pa3		equ 8		; Lautsprecher
ppi_pa6		equ 1 << 6	; Servomotor
ppi_b		equ 0b2h	; Kanal B PPI
ppi_c		equ 0b4h	; Kanal C PPI
ocw_2_3		equ 0c0h	; PIC (Interruptcontroller), OCW2,3
ocw_1		equ 0c2h	; PIC (Interruptcontroller), OCW1
icw_1		equ 0c0h	; PIC (Interruptcontroller), ICW1
icw_2_4		equ 0c2h	; PIC (Interruptcontroller), ICW2,4
leds		equ 0		; LED Port
schalter	equ 0		; Schalterport
keybd		equ 80h		; SBC-86 Tastatur
gokey		equ 11h		; Taste "GO"
outkey		equ 15h		; Taste "OUT"
sseg7		equ 9eh		; Segmentanzeige 7
tcfreq		equ 440		; initiale Frequenz
basefreq	equ	1843200	; Basistakt in Hz
nokey		equ 7		; keine Taste gedrueckt


start:

; Initialisierung

	mov ah, clrscr		; Anzeige aus
	int conout
	
	mov byte [status], 0	; Init. Statusbyte und alle LEDs
	mov al, 0
	out ppi_a, al
	out leds, al

	call init			; Controller und Interruptsystem scharfmachen

; Hintergrundprogramm (ist immer aktiv, wenn im Service nichts zu tun ist)
; Hier sollten Ausgaben auf das Display getätigt werden, Tastatureingaben, etc.

again:

; Code des Hintergrundprogammes
	; Keyboard
	in al, keybd
	mov ah, al 
	out leds, al
	and al, 00000111b ; Isolate last 3 bit to get row
	cmp al, 7
	je no_tone

	; Determine Row and Column
	times 3 shr ah, 1
	cmp al, 6
	je fertig


	cmp al, 5
	jne next
	add ah, 8
	jmp fertig
next:	add ah, 16
fertig: ; ah = code
	mov bx, tonleiter
	mov al, ah
	mov ah, 0
	shl al, 1
	add bx, ax
	mov bx, [bx]
	mov ah, 03
	mov dl, 05
	int 6
	shl bx, 1
	mov dx, basefreq >> 16
	mov ax, basefreq & 0xFFFF
	div bx ; Res in ax

	
	out pit1, al
	mov al, ah
	out pit1, al

	test byte [status], 00001000b
	jz ton
	
	
	jmp again
ton: 
	or byte [status], 00001000b 	
	jmp again


no_tone: 
	and byte [status], ~00001000b

	jmp again
		
; Initialisierung Controller und Interruptsystem

init:
	cli			; Interrupts aus

; PIT-Init.

;	Nichts zu tun, das macht die Main-Loop :-)
	mov al, 01110110b	; Kanal 1, Mode 3, 16-Bit ZK
	out pitc, al		; Steuerkanal
	mov al, tcfreq & 0ffh	; Low-Teil Zeitkonstante
	out pit1, al
	mov al, tcfreq >> 8	; High-Teil Zeitkonstante
	out pit1, al

; PPI-Init.
	mov al, 10001011b	; PPI A/B/C Mode 0, A Output, sonst Input
	out ppi_ctl, al
	jmp short $+2		; I/O-Delay
	mov al, 0			; LED's aus (high aktiv)
	out ppi_a, al
	
; PIC-Init.
	mov al, 00010011b	; ICW1, ICW4 benoetigt, Bit 2 egal, 
						; Flankentriggerung
	out icw_1, al
	jmp short $+2		; I/O-Delay
	mov al, 00001000b	; ICW2, auf INT 8 gemapped
	out icw_2_4, al
	jmp short $+2		; I/O-Delay
	mov al, 00010001b	; ICW4, MCS-86, EOI, non-buffered,
				; fully nested
	out icw_2_4, al
	jmp short $+2		; I/O-Delay
	mov al, 11111110b	; Kanal 0, 1 + 7 am PIC demaskieren
						; PIT K1
	out ocw_1, al
	
; Interrupttabelle init.	
	
	mov word [intab0], isr_freqtimer	; Interrupttabelle (Timer K1) 
						; initialisieren (Offset)
	mov [intab0 + 2], cs		; (Segmentadresse)
	
	sti					; ab jetzt Interrupts
	ret

;------------------------ Serviceroutine -----------------------------------
	
isr_freqtimer: 				; Timer fuer Lautsprecher
	push ax	

; Code der Serviceroutine fuer die Lautsprecherausgabe	
	; Membran ansteuern
	test byte [status], 00001000b
	jz isr_freqtimer_out 
	in al, ppi_a
	xor al, ppi_pa3
	out ppi_a, al

	
isr_freqtimer_out: 		; Ausgang aus dem Service

	mov al, eoi			; EOI an PIC
	out ocw_2_3, al
	pop ax
	iret

;Frequenzen in zwei Oktaven von c4 bis b5 in Hertz (Hz)

tonleiter:
	dw 262 ; c4   0
	dw 277 ; c#4  1
	dw 294 ; d4   2 
	dw 311 ; d#4  3
	dw 329 ; e4   4
	dw 349 ; f4   5
	dw 370 ; f#4  6
	dw 392 ; g4   7
	dw 415 ; g#4  8
	dw 440 ; a4   9
	dw 466 ; a#4  10
	dw 493 ; b4   11
	dw 523 ; c5   12
	dw 554 ; c#5  13 
	dw 587 ; d5   14
	dw 622 ; d#5  15
	dw 659 ; e5   16
	dw 698 ; f5   17 
	dw 740 ; f#5  18
	dw 784 ; g5   19
	dw 830 ; g#5  20
	dw 880 ; a5   21
	dw 932 ; a#5  22 
	dw 987 ; b5   23
