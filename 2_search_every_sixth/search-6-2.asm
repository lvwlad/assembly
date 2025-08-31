; search-6-2.asm

.model small
.stack 100h
.data

msg0        db      'Enter some words separated by space: $'
msg1        db      0Dh,0Ah,'Selected words: $'
msg2        db      0Dh,0Ah,'$'
buffer      db      255,?,255 dup(?)
everysix    db      ?
.code
start: mov  AX,@data
    mov     DS,AX
    MOV     ES,AX
    CLD
    xor     cx,cx
    call meeting
    ; find every sixth word then push them to buffer
    mov     si,offset buffer
    add     si,2
    mov     di,offset everysix
start1:
    cmp     cx,5
    jz      write_word
    lodsb   
    cmp     al,20h
    jz      next_word
    cmp     al,0Dh
    jz      end_line
    
    jmp     start1 
next_word:
    inc     cx     ; cx is a counter of words
    jmp     start1

write_word:
    lodsb
    cmp     al,20h
    jz      reset_counter
    cmp     al,0Dh
    jz      end_line
    stosb
    jmp     write_word

reset_counter:
    xor     cx,cx
    stosb
    jmp     start1
    
end_line:
    
    mov     byte ptr es:[di],24h
    call    revers
    
    mov     ah,09h
    mov     dx,offset msg1
    int     21h
    mov     dx,offset msg2
    int     21h
    mov     dx,offset everysix
    int     21h

    mov     ax,4C00h
    int     21h

revers      proc
    ; procedure finds the seventh word of collect buffer and reverses it
    mov     si,offset everysix
    xor     cx,cx
start_rev:
    cmp     cx,6
    jz      seven_in_six
    lodsb
    cmp     al,20h
    jz      next
    cmp     al,24h
    jz      end_collect
    jmp     start_rev
next:
    inc     cx
    jmp     start_rev
  
seven_in_six:
    push    si
sins:
    lodsb
    cmp     al,20h
    jz      end_word
    cmp     al,0Dh
    jz      end_word
    jmp     sins
end_word:
    dec     si
    mov     di,si
    mov     dx,si
    pop     si
    mov     bx,si
    ; si - start of seventh word
    ; bx - start of seventh word
    ; di -end of seventh word
    ; dx -end of seventh word
ew_1:
    
    lodsb
    push    ax
    cmp     si,di
    jnz     ew_1
    
    mov     di,bx
ew_2:    
    pop     ax
    stosb
    cmp     di,dx
    jnz     ew_2
    
end_collect:
    ret
revers      endp

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
