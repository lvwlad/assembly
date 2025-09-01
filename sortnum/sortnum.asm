; SORTNUM.ASM
.model small
;.386
.stack 100h
.data
number      dw      0
position    db      0
msg0        db      'Enter five numbers sep by space (necessarily) from -32768 to 32767: $'
msg1        db      0Dh,0Ah,'Sorted massive: $'
buffer      db      255,?,255 dup(?)
numbers     dw      ?

.code
start:
    mov     ax,@data
    mov     ds,ax
    mov     es,ax
    call    meeting
    call    asc2num
    
    ;mov    word ptr [bx+position], 0D0Dh
    ; Does user choose a bubble sort ? 
    call    bubble_sort



    asc2num     proc
    ; The procedure uses several labels for its work. 
    ; These labels are defined by the .data directive.
    ; The first label is <numbers>, which is a future array of numbers. 
    ; This label is used to keep track of where each number is stored.
    ; There is also a <position> label,
    ; which is an offset relative to the <numbers> label. 
    ; This label helps us to determine
    ; the position of each number in the array.
    ; Another label is <number>,
    ; which is used to temporarily store a translated number.
    ; This is necessary because we need to perform
    ; some calculations on the numbers before 
    ; they are stored in the final array.
 
    mov     si,offset buffer
    add     si,2
     mov    bx,offset numbers
    point1:      ; it is a negative number? if yes then sets bp=1 
    cmp     dh,1
    jz      end_prog
    lodsb
    cmp     al,'-'
    jnz     point2
    mov     bp,1
    jmp     point22
    
    point2:          ;    find a end of number
    dec     si
point22:
     lodsb
     cmp     al,20h
     jz      point3
     cmp     al,0Dh
     jz      end_line
     
     inc     cx
     jmp     point22
     
     point3:        ; set positions
     ; CX = sum of numerals
     
     sub    si,cx
     dec    si
     mov    dl,10

     point4:    ; load a char

     push   cx
     dec    cx
     cmp    cx,0
     jz     point55
     lodsb
     
     cmp    al,20h
     jz     point6 
     sub    al,30h
     point5:       ; transfer to numberand save the number in memory
     mul    dl
     loop   point5
     add    number,ax
     pop    cx
     
     loop   point4
 point55:
     
     lodsb
     sub    al,30h
     xor    ah,ah
     add    number,ax
     inc    si
 point6:
     cmp    bp,1
     jnz    point7   
     mov    di,offset number
     neg    word ptr [di]
     mov    bp,0
    ; mov    di,offset numbers
point7:
    
    mov     ax,number
    mov     number,0
    mov    word ptr [bx+position], ax
    mov    ax,word ptr [bx+position] ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    add    position,2
    jmp    point1
    
 
end_line:
    
    mov     dh,1
    jmp     point3  
end_prog:
    ;pop     cx
    ;At the end of the procedure, a value is directly set for SP, 
    ;this is due to the stack being filled with extra values. 
    ;To do this, we pop an extra value from the stack.

    mov     sp,00FEh
    ret
    asc2num     endp
   
   
   
   
   
   
   
   
   
    
    bubble_sort proc
    ; This proc sorts a massive of numbers
    mov     bx,offset numbers
    mov     al,position
    sub     al,2
    xor     ah,ah
    mov     dl,4
    div     dl          ; al = sum of numbers
    mov     cl,al
    dec     cl
    push    cx
    xor     dx,dx
again:
    mov     si,bx
    add     bx,2
    mov     di,bx
next:
    mov     ax,[si]
    mov     ax,es:[di]
    cmpsw   ;;;;; use this comand  
    LAHF
    and     ah,10000000b
    shr     ah,7
    add     dx,ax
    js      next1
    mov     ax,word ptr [si]
    xchg    word ptr [di],ax
    mov     word ptr [si],ax
    ;xchg    word ptr [si],word ptr [di]
next1:
    loop    next  
nums_end:
    cmp     dx,0
    jnz      again                  
    ret
    bubble_sort endp
    
    
    
    
    
    
    
    
    
    meeting     proc
    ; Proc prints meeting message for input data 
    mov     ah,09h
    mov     dx,offset msg0
    int     21h
    mov     ah,0Ah
    mov     dx,offset buffer
    int     21h
    ret
    meeting     endp
end     start