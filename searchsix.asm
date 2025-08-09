; TASM
.model small 

.stack 100h
.data
    resultfile          db          "lapa.txt", 0
    message1            db          "Enter words sep by space: $"
    message2            db          0Dh,0Ah,"Your 6th words are: $"
    newline             db          0Dh, 0Ah, '$'
    input               db          255, 0, 255 DUP('$')
    collectbuffer       db          256 DUP ('$')
.code
start: ;
    MOV     AX, @data
    MOV     DS, AX
    MOV     ES, AX

    ;MOV    AH,03H
    ;INT    10H

    
    MOV     AH, 09h
    LEA     DX, message1
    INT     21h


    MOV     AH, 0Ah
    LEA     DX, input
    INT     21h


    LEA     SI, input + 2    
    LEA     DI, collectbuffer
    XOR     CX, CX           
    XOR     BX, BX
    CLD

proverka:     ; searching for a space or the end of a line
    LODSB                
    CMP     AL, 0Dh         
    JE      check_word       
    CMP     AL, ' '          
    JNE     proverka         
    INC     CX      
    CMP     CX, 5h            
    JNE     proverka         
    JMP     copy_word        

save_adress:
    JMP     find_end
    
find_end:     ; finding the end of the seventh word
    LODSB
    CMP     AL, ' '
    JE      invert_flag
    JMP     find_end
    
invert_flag:     ; saving an address and changing directions
    MOV     DX, SI
    SUB     SI, 02h
    STD  
    JMP copy_invert 
    
copy_invert:     ; copying the letters in reverse order
    LODSB
    CMP     AL, ' '
    JE      vozvrat
    CLD
    STOSB
    STD
    JMP     copy_invert
    
vozvrat:      ; return to the starting direction and reset the counter responsible for searching for every sixth word.
    MOV     SI, DX
    CLD
    MOV     BX, 25
    XOR     CX, CX
    MOV     AL,' '
    STOSB
    JMP     proverka

copy_word:     ; copy every sixth word.
    CMP     BX, 6h
    JE      save_adress
    CLD  
    LODSB                
    CMP     AL, ' '          
    JE      reset_counter     
    CMP     AL, 0Dh          
    je      end_copy
    STOSB                
    JMP     copy_word

reset_counter:     ; resetting counters
    STOSB                
    XOR     CX, CX           
    INC     BX
    JMP     proverka         

end_copy:     ; completing the copy
    MOV     AL, '$'          
    STOSB
    JMP     proverka         

check_word:     ; output to the screen and creating a file
    MOV     AH, 09h
    LEA     DX, message2
    INT     21h
    LEA     DX, newline
    INT     21h
    LEA     DX, collectbuffer
    INT     21h
    MOV     AH, 3Ch
    LEA     DX, resultfile
    XOR     CX, CX
    INT     21h  
    MOV     BX, AX        
    LEA     SI, collectbuffer
    
calc_len:        ; calculating the length of text to write to a file         
    CMP     byte ptr [SI], '$'
    JE      write_data
    INC     CX
    INC     SI
    JMP     calc_len
    
write_data:       ; writing the collected text to a file
    MOV     AH, 40h
    LEA     DX, collectbuffer
    INT     21h
    MOV     AH, 3Eh
    INT     21h

no_word:  ;
    MOV     AH, 08h    
    INT     21h        
    MOV     AH, 4Ch
    INT     21h 

end start
