; MULTAB.ASM
;1*1=1
;1*2=2
;...

.model small
.data
msg     db      'THERE IS MULTAB HERE: $'    
msg1    db      0Dh,0Ah,'$' 
msg2     db      ?
.stack 100h
.code

start:
    mov     ax,@data
    mov     ds,ax
    mov     es,ax
    cld
    ;mov     ax,1        ; start num
    mov     bx,1        ; start factor
    mov     cx,5        ; for loop
    comment *
    mov     ah,09h
    mov     dx,offset msg
    int     21h 
    mov     dx,offset msg1
    int     21h 
    *
build_line:
    mov     ax,1
    push    ax              ;
    call    print_line      ;
    add     sp,2            ; 
    cmp     bx,11
    jz      return_factor
    jmp     build_line
return_factor:
    mov     bx,1
    mov     ah,9
    mov     dx,offset msg1
    int     21h
ax_same_6:
    mov     ax,6
    push    ax
    call    print_line
    cmp     bx,11
    jz      end_prog
    jmp     ax_same_6
end_prog:
    mov     ax,4C00h
    int     21h
    print_line  proc
    
    
    mov     cx,5
    mov     bp,sp
    mov     ax,  [bp+2]
    
    mov     di,offset msg2  ; DI has a offset of message where string is saving 
start_proc:    
    
    cmp     ax,10
    jz      numeral_is_ten

    add     ax,'0'
    stosb
    sub     ax,'0'
num_ten:
    mov     byte ptr [di],'*'
    inc     di
    
    xchg    dx,ax
    
    cmp     bx,10           ; if factor has more than one numeral
    jz      factor_is_ten   ; then prog go to this block
    mov     ax,bx
    add     ax,'0'
    stosb
factor_ten:
    mov     byte ptr [di],'='
    inc     di
    sub     ax,'0'
    xchg    dx,ax
    mov     dx,ax
    mul     bl
    cmp     ax,10
    js      write
    cmp     ax,100
    jz      ax_is100
    push    dx
    mov     dl,10
    div     dl
    pop     dx
    ; ah is a youngest numeral
    ; al is a older numeral
    add     al,'0'
    stosb
    xchg    ah,al
write: 
    add     al,'0'     
    stosb
    sub     al,'0'
    xchg    ax,dx
    mov     word ptr [di],2020h
    add     di,2
    xor     dx,dx
    
    ; next number 
    inc     ax
ax_was100:
    loop    start_proc
    mov     byte ptr [di],24h
    mov     ah,09h
    mov     dx,offset msg2
    int     21h
    mov     dx,offset msg1
    int     21h
    ;inc     di
    inc     bx
    ret
factor_is_ten:
    ; that code block traslates a factor
    ; who have more then one numerals
    ; bx == 000Ah
    mov     byte ptr [di],'1'
    inc     di
    mov     byte ptr [di],'0'
    inc     di
    jmp     factor_ten 
numeral_is_ten:
    mov     byte ptr [di],'1'
    inc     di
    mov     byte ptr [di],'0'
    inc     di
    jmp     num_ten
ax_is100:
    mov     byte ptr [di],'1'
    inc     di
    mov     word ptr [di],3030h
    add     di,2
    jmp     ax_was100
    jmp     factor_ten 
    endp
    end     start
