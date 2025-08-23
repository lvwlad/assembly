; REVSTR.ASM
.model small
.data
line        db      0Dh,0Ah,'$'
msg         db      'Enter your text (80 chars max): $'
msg1        db      80,?,80 DUP('$')
buffer      db       ?
.stack  100h
.code

start:
    mov     ax,@data
    mov     ds,ax
    mov     es,ax
    mov     ah,09h
    mov     dx,offset msg
    int     21h
    mov     ah,0Ah
    mov     dx,offset msg1
    int     21h
    mov     ah,09h
    mov     dx,offset line
    int     21h
    cld
    mov     si,offset msg1
    mov     di, offset buffer
    add     si,2
    mov     ax,si
    dec     si
    mov     cl,byte ptr [si]
    push    si
increment:
    inc     ax
    loop    increment          
    mov     si,ax                ; SI has address the last char of input string
    pop     cx
colect_buffer:
    std
         
    lodsb
    cmp     si,cx
    cld
    stosb
    jz      print_line
    jmp     colect_buffer
    
print_line:
    ; print reverse str
    mov     al,24h
    stosb
    mov     ah,09h
    mov     dx,offset buffer
    int     21h
    mov     ax,4C00h
    int     21h
    
    
    

end start 