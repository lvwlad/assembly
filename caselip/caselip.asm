; caselip.asm
; start 41
; end 5A

.model tiny
.code
    org     100h
    
start:
    cld
    mov     ah,09h
    mov     dx,offset msg
    int     21h
    mov     ah,0Ah
    mov     dx,offset input
    int     21h
    mov     ah,09h
    mov     dx,offset msg1
    int     21h
    mov     di,offset input
    mov     si,di
    add     si,2
    inc     di
    mov     cl,byte ptr [di]
    inc     di
         
char:
    lodsb
    call    caselip
    stosb
    loop    char
    mov     di,si
    mov     al,'$'
    stosb
    mov     ah,09h
    mov     dx,offset input
    add     dx,2
    int     21h
    ret
    
caselip     proc
    cmp     al,41h
    js      case2
    cmp     al,5Ah
    jg      case2
    add     al,20h      ; xor   al,20h 
    ret
case2: 
    cmp     al,61h
    js      end_lip
    cmp     al,7Ah
    jg      end_lip
    sub     al,20h
end_lip:
    ret
    
    endp
    
    
 msg      db    'enter your text (80 chars max): ','$' 
 msg1      db    0Dh,0Ah,'$'  
 input    db      80,?
     
    end     start
