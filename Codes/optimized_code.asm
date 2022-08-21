.MODEL SMALL

.STACK 400h; 1KB stack

.DATA

	
		
.CODE
		

	main  PROC
		
		mov AX, @DATA
		mov DS, AX
		; data segment loaded
		
		PUSH BX ; line no 2 : a declared
		PUSH BX ; line no 2 : b declared
		PUSH BX ; line no 2 : c declared
		
		MOV BX, [ BP-10 ]
		PUSH BX; line no 3 : a loaded
		
		PUSH 2
		POP AX
		MOV [BP + -10], AX; line no 3 : a assined
		MOV BX, AX
; peepholed 31		PUSH BX

; peepholed 29		POP BX; line no 3 : ; previously pushed value on stack is removed
		
		; line no 9 : ; for loop start
		
		MOV BX, [ BP-12 ]
		PUSH BX; line no 4 : b loaded
		
		PUSH 2
		POP AX
		MOV [BP + -12], AX; line no 4 : b assined
		MOV BX, AX
; peepholed 44		PUSH BX

; peepholed 42		POP BX; line no 9 :  ; previously pushed value should be popped
		@L_6: ; loop start label

		
		MOV BX, [ BP-12 ]
		PUSH BX; line no 4 : b loaded
		
		PUSH 4
		

		POP BX
		POP AX
		CMP AX, BX; line no 4 :  relop operation
		MOV BX, 1; line no 4 :  First let it assume positive
		JL @L_2
		MOV BX, 0; line no 4 :  the condition is false
		@L_2: 

; peepholed 64		PUSH BX

; peepholed 62		POP BX
		CMP BX, 0
		JE @L_7 ; condition false
		
		; line no 8 : ; for loop start
		
		MOV BX, [ BP-14 ]
		PUSH BX; line no 5 : c loaded
		
		PUSH 1
		POP AX
		MOV [BP + -14], AX; line no 5 : c assined
		MOV BX, AX
; peepholed 79		PUSH BX

; peepholed 77		POP BX; line no 8 :  ; previously pushed value should be popped
		@L_4: ; loop start label

		
		MOV BX, [ BP-14 ]
		PUSH BX; line no 5 : c loaded
		
		PUSH 5
		

		POP BX
		POP AX
		CMP AX, BX; line no 5 :  relop operation
		MOV BX, 1; line no 5 :  First let it assume positive
		JLE @L_3
		MOV BX, 0; line no 5 :  the condition is false
		@L_3: 

; peepholed 99		PUSH BX

; peepholed 97		POP BX
		CMP BX, 0
		JE @L_5 ; condition false
		
		MOV BX, [ BP-10 ]
		PUSH BX; line no 6 : a loaded
		
		MOV BX, [ BP-12 ]
		PUSH BX; line no 6 : b loaded
		
		MOV BX, [ BP-14 ]
; peepholed 111		PUSH BX; line no 6 : c loaded
; peepholed 110		POP BX; line no 6 :  ; multiplication start of integer
		MOV CX, BX
		POP AX
		IMUL CX
		MOV BX, AX; line no 6 :  ; only last 16 bit is taken in mul
		PUSH BX
		POP AX
		MOV [BP + -10], AX; line no 6 : a assined
		MOV BX, AX
; peepholed 122		PUSH BX

; peepholed 120		POP BX; line no 6 : ; previously pushed value on stack is removed
		
		MOV BX, [ BP-10 ]
; peepholed 126		PUSH BX; line no 7 : a loaded
; peepholed 125		POP BX
		PUSH BX
		CALL PRINT_DECIMAL_INTEGER
		
		MOV BX, [ BP-14 ]
		PUSH BX; line no 5 : c loaded
		POP AX
		PUSH AX

		INC AX
		MOV [BP + -14], AX; line no 5 : 
		JMP @L_4 ; go to check point
		@L_5: ; exit loop 

		
		MOV BX, [ BP-12 ]
		PUSH BX; line no 4 : b loaded
		POP AX
		PUSH AX

		INC AX
		MOV [BP + -12], AX; line no 4 : 
		JMP @L_6 ; go to check point
		@L_7: ; exit loop 

		
		; return point main
		@L_1: 
		mov AH, 4Ch
		int 21h
		; returned control to OS
		

	main ENDP
		

	PRINT_NEWLINE PROC
        ; PRINTS A NEW LINE WITH CARRIAGE RETURN
        PUSH AX
        PUSH DX
        MOV AH, 2
        MOV DL, 0Dh
        INT 21h
        MOV DL, 0Ah
        INT 21h
        POP DX
        POP AX
        RET
    PRINT_NEWLINE ENDP
    
    PRINT_CHAR PROC
        ; PRINTS A 8 bit CHAR 
        ; INPUT : GETS A CHAR VIA STACK 
        ; OUTPUT : NONE    
        PUSH BP
        MOV BP, SP
        
        ; STORING THE GPRS
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSHF
        
        
        
        MOV DX, [BP + 4]
        MOV AH, 2
        INT 21H
        
        
        
        POPF  
        
        POP DX
        POP CX
        POP BX
        POP AX
        
        POP BP
        RET 2
    PRINT_CHAR ENDP 

    PRINT_DECIMAL_INTEGER PROC NEAR
        ; PRINTS SIGNED INTEGER NUMBER WHICH IS IN HEX FORM IN ONE OF THE REGISTER
        ; INPUT : CONTAINS THE NUMBER  (SIGNED 16BIT) IN STACK
        ; OUTPUT : 
        
        ; STORING THE REGISTERS
        PUSH BP
        MOV BP, SP
        
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSHF
        
        MOV AX, [BP+4]
        ; CHECK IF THE NUMBER IS NEGATIVE
        OR AX, AX
        JNS @POSITIVE_NUMBER
        ; PUSHING THE NUMBER INTO STACK BECAUSE A OUTPUT IS WILL BE GIVEN
        PUSH AX

        MOV AH, 2
        MOV DL, 2Dh
        INT 21h

        ; NOW IT'S TIME TO GO BACK TO OUR MAIN NUMBER
        POP AX

        ; AX IS IN 2'S COMPLEMENT FORM
        NEG AX

        @POSITIVE_NUMBER:
            ; NOW PRINTING RELATED WORK GOES HERE

            XOR CX, CX      ; CX IS OUR COUNTER INITIALIZED TO ZERO
            MOV BX, 0Ah
            @WHILE_PRINT:
                
                ; WEIRD DIV PROPERTY DX:AX / BX = VAGFOL(AX) VAGSESH(DX)
                XOR DX, DX
                ; AX IS GUARRANTEED TO BE A POSITIVE NUMBER SO DIV AND IDIV IS SAME
                DIV BX                     
                ; NOW AX CONTAINS NUM/10 
                ; AND DX CONTAINS NUM%10
                ; WE SHOULD PRINT DX IN REVERSE ORDER
                PUSH DX
                ; INCREMENTING COUNTER 
                INC CX

                ; CHECK IF THE NUM IS 0
                OR AX, AX
                JZ @BREAK_WHILE_PRINT; HERE CX IS ALWAYS > 0

                ; GO AGAIN BACK TO LOOP
                JMP @WHILE_PRINT

            @BREAK_WHILE_PRINT:

            ;MOV AH, 2
            ;MOV DL, CL 
            ;OR DL, 30H
            ;INT 21H
            @LOOP_PRINT:
                POP DX
                OR DX, 30h
                MOV AH, 2
                INT 21h

                LOOP @LOOP_PRINT

        CALL PRINT_NEWLINE
        ; RESTORE THE REGISTERS
        POPF
        POP DX
        POP CX
        POP BX
        POP AX
        
        POP BP
        
        RET


    PRINT_DECIMAL_INTEGER ENDP

END MAIN
