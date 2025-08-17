.model small
.data    
    message1    db      'What operation you want choose?','$'
    message2    db      0Dh,0Ah,'Enter + or -: ','$'
    message3    db      0Dh,0Ah,'Enter your 1st number (from -32768 to 32767): ','$'
    message4    db      0Dh,0Ah,'Enter your 2nd number (from -32768 to 32767): ','$'
    message5    db      0Dh,0Ah,'Result: ','$'
    message6    db      0Dh,0Ah,'Do you want calculate any other numbers? ','$'
    message7    db      0Dh,0Ah,'(Y)es or (N)o:  ','$'
    answer      db      4,?,4 DUP(0Dh)
    ;input       db      1,?
    number1     db      6,?,6 DUP('$')
    number2     db      6,?,6 DUP('$')
    end_num     db      1
    numbers     dw      number1,number2,end_num
    res         dw      ?
    result      db      ?
    position    dw      ?
    
.stack 100h
.code  
.386
start:
    mov     ax,@data
    mov     ds,ax
    mov     es,ax
start1:
    cld
 
  comment *
   mov      ax,offset number1
   mov      ax,offset number2
   mov      ax,offset end_num
   mov      ax,offset numbers
   *
    mov     ah,09h
    mov     dx,offset message1
    int     21h
    mov     ah,09h
    mov     dx,offset message2
    int     21h
    mov     ah,01h
    int     21h
    push    ax                      ; AX = - or +
    mov     res,0000h
    mov     position,offset numbers
enter_numbers:
    mov     ah,09h
    mov     dx,offset message3
    int     21h
    mov     ah,0Ah
    mov     dx,offset number1
    int     21h                     ; enter firs number
    mov     ah,09h
    mov     dx,offset message4
    int     21h
    mov     ah,0Ah
    mov     dx,offset number2
    int     21h                     ; enter 2nd number
    cld
    
    
    mov     si,offset numbers
    
    mov     di, word ptr [si]
    
asc2num:
    cmp     di,offset end_num
    jz      calculator
    add     di,2                    ; go to buffer
    mov     si,di
    lodsb   
    cmp     al,'-'
    jz      transfer0
    dec     si
    jmp     transfer
transfer0:
    dec     di
    dec     byte ptr [di]
    inc     di
transfer:
    xor     bx,bx
    mov     bl,10
    dec     di
    mov     cl,byte ptr [di]                 ; tens place
    inc     di
transfer2:
    lodsb   
    ; ????? = ??? ????? - ??? ??????? 0
    xor     ah,ah
    sub     ax,'0'                  ; numeral in AX
    cmp     cx,1
    jz      last_numeral
    push    cx
    dec     cx
    call    mnoz
    pop     cx
    dec     cx
        
    ;mov     res,0000h                    ; number in AX push to stack
    add     res,ax
    ;dec     di
    jmp     transfer2
    
mnoz:
     mul     bx
     loop   mnoz
     ret
last_numeral:
    
    add     res,ax
    ;push    ax
   ; mov     bx,offset numbers
   ;add     bx,2
   add     position, 2
   mov      bx,position
    ;mov     di,bx
    
    mov     di,word ptr [bx]
    mov     ax,res
    mov     res,0
    push    ax
    jmp     asc2num
next_num:
    mov     di,offset end_num
    ;mov     
calculator:
    pop     bx                  ; first number
    pop     ax                  ; 2nd number
    pop     dx                  ; type of operation
    
    mov     di,offset number1
    add     di,2
    mov     cl,byte ptr [di]
    cmp     cl,'-'
    jz      negative1
calculator2:
    mov     di,offset number2
    add     di,2
    mov     cl,byte ptr [di]
    cmp     cl,'-'
    jz      negative2
calculator3:    
    cmp     dl,'-'
    jz      minus
    cmp     dl,'+'
    jz      plus
    
minus:
    
    sub     eax,ebx
    cmp     eax,0
    js      neg_result
    ;mov     eax,ebx
    xor     cx,cx
    jmp     print_result
    
plus:
    add     eax,ebx
    cmp     eax,0
    js      neg_result
    ;mov     eax,ebx
    xor     cx,cx
    jmp     print_result
    
neg_result:
    mov     di,offset result
    push    ax
    mov     al,'-'
    stosb
    pop     ax
    neg     eax
    ;mov     eax,ebx
    xor     cx,cx
    jmp     print_result

print_result:
    cmp     ax,10          ;cmp     eax,10
    js     print_result2
    mov     ebx,10
    push    ax
    shr     eax,16
    mov     dx,ax
    pop     ax
    div     bx
    add     dl,'0'
    push    dx
    inc     cx
    jmp     print_result
print_result2:
    ;cmp     eax,10
    ;jns     print_result
    add     al,'0'
    push    ax
    inc     cx
    mov     di,offset result
    ;inc     di
    cmp     byte ptr [di],'-'
    jz     print_result3
    jmp     write
    ;dec     di
print_result3: 
    inc     di
write:      
    pop     ax
    stosb
    loop    write
    mov     al,'$'
    stosb
    jmp     end_program
    
    
negative1:    
    neg     eax
    jmp     calculator2
negative2:    
    neg     ebx
    jmp     calculator3
end_program:
    
    mov     ah,09h
    mov     dx,offset message5
    int     21h
    ;comment *
    mov     ah,09h
    mov     dx,offset result
    int     21h
    mov     ah,09h
    mov     dx,offset message6
    int     21h
repeat_meet:
    mov     ah,09h
    mov     dx,offset message7
    int     21h
    mov     ah,0Ah
    mov     dx,offset answer
    int     21h
    mov     si,offset answer
    add     si,2
    lodsb
    cmp     al,'Y'
    jz      answer1
    cmp     al,'y'
    jz      answer1
    cmp     al,'N'
    jz      answer2
    cmp     al,'n'
    jz      answer2
    jmp     repeat_meet
answer1:
    lodsb
    cmp     al,0Dh
    jz     start1
    cmp     al,'e'
    jnz     wrong_answer
    lodsb
    cmp     al,'s'
    jnz     wrong_answer
    
    
    
    jmp     start1
    
   ; *
answer2:
    lodsb
    cmp     al,0Dh
    jz      its_end
    cmp     AL,'o'
    jnz     wrong_answer
its_end:   
    mov     ah,4ch
    int     21h
wrong_answer:
    jmp     repeat_meet  
    
    end     start
