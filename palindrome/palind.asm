; PALIND.ASM

.model small 
.data
msg         db      'Enter your word (or string): $'
msg1        db      0Dh,0Ah,'The string IS a palindrome.$'
msg2        db      0Dh,0Ah,'The string is NOT a palindrome.$'
msg3        db      0Dh,0Ah,'Do you want to check another word? (Y(es) or N(o)): $'
msg4        db      0Dh,0Ah,'$'
buffer0     db      4,?,4 dup(?)
buffer      db      80,?
.stack       100h
.code
start:
    mov     ax,@data
    mov     ds,ax
    mov     es,ax
    ;
start1:
    call    meeting
    
read_str:
    lodsb
    cmp     al,0Dh
    jnz     read_str
    sub     si,2
    mov     di,si
    mov     si,offset buffer
    add     si,2
    ;
check:
    cld
    lodsb
    cmp     al,20h
    jnz     check1
    
    jmp     check
check1:
    cmp     al,0Dh
    jz      palindrome
    std
    ;scasb
    cmp     byte ptr [di],20h
    jnz     check2
    dec     di
check2:
    scasb

    jnz     not_palindrome
    jmp     check
not_palindrome:
    mov     ah,09h
    mov     dx,offset msg2
    int     21h
    mov     dx,offset msg3
    int     21h
    mov     ah,0Ah
    mov     dx,offset buffer0
    int     21h
    jmp     end_prog
     
palindrome:
    mov     si,offset buffer
    inc     si
    mov     bl,byte ptr [si]
    cmp     bl,0
    jz      not_palindrome
    mov     ah,09h
    mov     dx,offset msg1
    int     21h
    mov     dx,offset msg3
    int     21h
    mov     ah,0Ah
    mov     dx,offset buffer0
    int     21h
    jmp     end_prog
    
end_prog:
    call    cont
    mov     ah,09h
    mov     dx,offset msg4
    int     21h
    cmp     bx,1
    jz     start1
    mov     ax,4C00h
    int     21h
    meeting     proc
    mov     ah,09h
    mov     dx,offset msg
    int     21h
    mov     ah,0Ah
    mov     dx, offset buffer
    int     21h
    ;
    mov     si,offset buffer
    add     si,2
    ret
    meeting     endp
cont    proc
    mov     si,offset buffer0
    add     si,2
    lodsb
    cmp     al,'Y'
    jz      yes
    cmp     al,'y'
    jz      yes
    cmp     al,'N'
    jz      no
    cmp     al,'n'
    jz      no
    
yes:
     mov    bx,1
     cld
     ret
no:
    mov     bx,2
    ret

  
 cont   endp
    end     start