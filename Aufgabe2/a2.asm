	org 100h
	cpu 8086

jmp START
LED_L equ 94h
LED_R equ 92h
LED_h equ 90h
H:     equ 01110100b
; ARR Codierung für LED-Darstellung des SBCs von 0 bis F sequenziell
ARR: db 00111111b, 00000110b, 01011011b, 01001111b, 01100110b, 01101101b, 01111101b, 00000111b, 01111111b, 01101111b, 01110111b, 01111100b, 00111001b, 01011110b, 01111001b, 01110001b

START: 
  mov al, H
  out LED_h, al
  
  in al, 00h; Port 0 in al ; z. B. 0000'0000
  out 00h, al
  ; Isolate Low Nibble
  mov cl, 4
  shl al, cl
  shr al, cl
  mov cl, 0
  

  ; LED_R
  mov ah, al
  lea bx, ARR
  xlat
  out LED_R, al

  ; Read 
  in al, 00h
  out 00h, al
  ; Isolate High Nibble
  mov cl, 4
  shr al, cl
  ;shl al, cl
  mov cl, 0
  
  ; LED_L
  ;lea bx, ARR
  xlat
  out LED_L, al
	jmp START
