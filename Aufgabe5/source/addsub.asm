cpu 8086

global addsub

addsub:
  push bp
  mov bs, sp
 sub sp, 2+2+1+4 ; Allocate space for 
                  ; short num1, short num2, char operation, ushort* flags
   
  

  
  
  pop bp
  ret


