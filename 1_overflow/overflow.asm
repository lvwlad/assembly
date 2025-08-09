; lab-1.asm
; JO Short jump if overflow (OF=1)
; JNO is a short transition, if not an overflow (OF=0)
; STOS m8 -- ????????? AL ?? ?????? ES:(E)DI

.model small

.stack 100h

.data

    A           dw      -120
    B           dw      -115
    C           dw      -100
    combo       db      ?
    znam        dw      ?
    filename    db      'lab-1_ow.txt',0
    handle      dw      ?
    combo_dec   db      ?
    len         dw      ?
    output      db      'The end :)','$'
    

.code

.386

start:
    mov     ax,@data
    mov     ds,ax
    mov     es,ax
    mov     di,A
    mov     bx,B
    mov     si,C
    mov     ah,3Ch                  ; create a file
    mov     cx,0
    mov     dx,offset filename
    int     21h
    mov     handle,ax
    mov     cx,256
    ;push    cx
    ;push    cx
    jmp     for_C
    
for_A:
    mov     bx,B
    cmp     di,128          ; if A > 127 terminate the program
    JGE      end_program
    ;push    cx
    inc     di
    call    for_B           ; otherwise call for_B
    ;pop     cx
    ;jmp    for_A  
    
for_B:
    mov     si,C
    cmp     bx,128
    JGE      for_A
    ;push    cx
    inc     bx
    call    for_C
    ;pop     cx
    ;cmp     cx,0
    ;jz      ret_for
    ;jmp    for_B
    
for_C:
    xor     eax,eax
    xor     edx,edx
    cmp     si,128          
    JGE      for_B
    call    result
    inc     si     ; the C variable to SI
    jmp    for_C  ; 
  
ret_for:
        ret

result:
    ; ??????? ?????????
    ; A di
    ; B bx
    ; C si
    mov     ax,bx           ; B in AX
    ;push    bx              ; save B to stack
    mov     cl,12h          
    imul    cl              ; ax = B*18 
    jo      overflow_is
    ;pop     bx              ; load B in bx
    push    ax              ; save ax = B*18 to stack
    mov     dx,di           ; dx = A
    mov     ax,dx           ; AX = A
    imul    dl              ; ax = A^2
    jo      overflow_is
    mov     dx,si           ; dx = C
    imul    dx              ; dx:ax = A^2*C
    jo      overflow_is
    push    ax              
    mov     eax,edx
    shl     eax,16
    pop     ax
    shl     eax,3       ; EAX = 8*C*A^2
    pop     dx          ; load dx = B*18 from stack
    add     eax,edx
    jo      overflow_is
    add     eax,0Eh     ; the numerator is calculated in EAX
    jo      overflow_is
    push    ax
    shr     eax,16
    push    ax          ; placed on the EAX stack 
    xor     eax,eax
    
    ; counting the denominator
    mov     ax,si               ; ax = C
    mov     dx,0002h
    imul    al                  ; AX = C^2
    jo      overflow_is
    imul    dx                  ; DX:AX = C^2*2
    jo      overflow_is
    push    ax                  ; save AX to stack
    mov     ax,dx               ; 
    shl     eax,16
    pop     ax                  ; EAX = C^2*2
    mov     dx,di               ; DX = A
    sub     eax,edx             ; EAX = EAX - EDX (denominator)
    jo      overflow_is
    xor     dx,dx
    mov     dx,offset znam
    push    si                  ; save C to stack
    mov     si,dx               ; SI = offset where store denominator
    mov     word ptr ds:[si],ax     ; save denominator to memory
    
    ; dividing the numerator by the denominator
    pop     si                  ; Si = C 
    mov     ax,si               ; AX = C
    shl     eax,16              ; older world of EAX = C
    mov     si,dx               ; SI offset where store denominator
    pop     dx                  ; load dx from stack
    pop     ax                  ; loaad ax from stack
    idiv    word ptr ds:[si]    ; 
    jo      overflow_is
    push    ax
    shr     ax,16
    mov     si,ax
    pop     ax
    ;pop     si
    ret             ; return to for_C
    
overflow_is:    
  
    ; stosb: save AL to ES:(E)DI
    
    add     sp,4                ; clear the stack
    push    di
    mov     ax,di               ; AX = A
    ;add     al,'0'
    mov     di,offset combo
    cld
    stosb   
    mov     al,20h
    stosb
    mov     ax,bx
    ;add     al,'0'
    stosb
    mov     al,20h
    stosb
    mov     ax,si
    ;add     al,'0'
    stosb
    mov     al,0Dh
    stosb
    mov     al,0Ah
    stosb
    pop     di
    
    ; write to file my combo when overflow become
    ;comment *
    push    di
    push    si
    push    bx
    mov     di, offset combo
    mov     si, offset combo_dec
    jmp     asc2dec
    
end_asc2dec:
    
    ;call    calc_length
    
    mov     ah,40h
    ;push    bx
    xor     bx,bx
    mov     bx,handle
    mov     dx,offset combo_dec
    mov     cx,len
    int     21h
    pop     bx
    pop     si
    pop     di
    inc     si
    jmp     for_C
    ;*
    comment *
    mov     ah,40h
    push    bx
    xor     bx,bx
    mov     bx,handle
    mov     dx,offset combo
    mov     cx,7
    int     21h
    pop     bx
    inc     si
    jmp     for_C
    *
    ;comment * 
asc2dec:
   ;mov     di, offset combo
    xor      ah,ah
    mov     al, byte ptr ds:[di]    ; number to Al
    mov     cx, 0                ;      counter of numbers
    mov     bx, 10                     ; delitel
    cmp     al,0
    js      asc2dec_neg
    cmp     ax,20h
    jz      space
    cmp     al,0Dh
    jz      calc_length
    jmp     dec_loop
dec_loop:
    xor     dx, dx              ;
    div     bx             ; dx:ax / bx = dx = remainder, ax =quotient
    push    dx              ; save remainder (number)
    inc     cx              
    test    ax, ax          
    jnz     dec_loop

print_loop:
    pop     dx
    add     dl, '0'          ; ??????????? ? ASCII
    ;mov     si, offset combo_dec
    mov     byte ptr es:[si],dl
    inc     si
    loop    print_loop
    ;--------
    inc     di
    jmp     asc2dec
    ;pop     bx
    ;pop     si
    ;pop     di
    

space:
    mov     byte ptr es:[si],al
    inc     di
    inc     si
    jmp     asc2dec
    
calc_length:
    mov     byte ptr es:[si],al
    inc     si
    mov     byte ptr es:[si],0Ah
    inc     si
    sub     si,offset combo_dec
    mov     len,si
    ;mov     len, si - offset combo_dec
    jmp     end_asc2dec
    ;*
asc2dec_neg:
    mov     byte ptr es:[si],'-'
    inc     si
    neg     al
    jmp     dec_loop
end_program:
    MOV     AH, 3Eh
    INT     21h
    mov     ah,09h
    mov     dx,offset output
    int     21h
           
    MOV     AH, 4Ch
    INT     21h 

    end start
