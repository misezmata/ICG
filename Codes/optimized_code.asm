.MODEL SMALL

.STACK 400h; 1KB stack

.DATA

	
		
.CODE
		

	fib  PROC
		
		PUSH BP
        MOV BP, SP
        
        ; STORING THE GPRS
        ; DX for returning results
        PUSH AX
        PUSH BX
        PUSH CX
        PUSHF
        
        
		
		; if statement
		
		MOV BX, [ BP+4 ]
		PUSH BX; line no 2 : a loaded
		
		PUSH 1
		

		POP BX
		POP AX
		CMP AX, BX; line no 2 :  relop operation
		MOV BX, 1; line no 2 :  First let it assume positive
		JE @L_2
		MOV BX, 0; line no 2 :  the condition is false
		@L_2: 

		PUSH BX

		
		MOV BX, [ BP+4 ]
		PUSH BX; line no 2 : a loaded
		
		PUSH 2
		

		POP BX
		POP AX
		CMP AX, BX; line no 2 :  relop operation
		MOV BX, 1; line no 2 :  First let it assume positive
		JE @L_3
		MOV BX, 0; line no 2 :  the condition is false
		@L_3: 

; peepholed 64		PUSH BX

		

		; OR OPERATION
; peepholed 59		POP BX
		POP AX
		OR BX, AX
; peepholed 68		PUSH BX
; peepholed 67		POP BX
		CMP BX, 0
		JE @L_6 ; go to exit
		
		
		PUSH 1
		POP BX; line no 2 :  return value saved in DX 
		MOV DX, BX
		JMP @L_1; line no 2 :  ; exit from the function
		@L_6:  ; exit label

		
		
		MOV BX, [ BP+4 ]
		PUSH BX; line no 3 : a loaded
		
		PUSH 1

		POP BX
		POP AX
		SUB AX, BX
		MOV BX, AX
		PUSH BX

		CALL fib ; function fib called.; line no 3 : 
		MOV BX, DX; line no 3 :  return result in DX.
		PUSH BX
		
		MOV BX, [ BP+4 ]
		PUSH BX; line no 3 : a loaded
		
		PUSH 2

		POP BX
		POP AX
		SUB AX, BX
		MOV BX, AX
		PUSH BX

		CALL fib ; function fib called.; line no 3 : 
		MOV BX, DX; line no 3 :  return result in DX.
; peepholed 111		PUSH BX

; peepholed 109		POP BX
		POP AX
		ADD BX, AX
; peepholed 116		PUSH BX

; peepholed 114		POP BX; line no 3 :  return value saved in DX 
		MOV DX, BX
		JMP @L_1; line no 3 :  ; exit from the function
		
		; return point fib
		@L_1:
		MOV SP, BP
		SUB SP, 8
		POPF  
        
        POP CX
        POP BX
        POP AX
        
        POP BP
		RET 2
		

	fib ENDP

	main  PROC
		
		mov AX, @DATA
		mov DS, AX
		; data segment loaded
		
		PUSH BX ; line no 7 : a declared
		
		; line no 12 : ; for loop start
		
		MOV BX, [ BP-10 ]
		PUSH BX; line no 8 : a loaded
		
		PUSH 1
		POP AX
		MOV [BP + -10], AX; line no 8 : a assined
		MOV BX, AX
; peepholed 155		PUSH BX

; peepholed 153		POP BX; line no 12 :  ; previously pushed value should be popped
		@L_9: ; loop start label

		
		MOV BX, [ BP-10 ]
		PUSH BX; line no 8 : a loaded
		
		PUSH 10
		

		POP BX
		POP AX
		CMP AX, BX; line no 8 :  relop operation
		MOV BX, 1; line no 8 :  First let it assume positive
		JL @L_8
		MOV BX, 0; line no 8 :  the condition is false
		@L_8: 

; peepholed 175		PUSH BX

; peepholed 173		POP BX
		CMP BX, 0
		JE @L_10 ; condition false
		
		PUSH BX ; line no 9 : c declared
		
		MOV BX, [ BP-12 ]
		PUSH BX; line no 10 : c loaded
		
		MOV BX, [ BP-10 ]
		PUSH BX; line no 10 : a loaded
		CALL fib ; function fib called.; line no 10 : 
		MOV BX, DX; line no 10 :  return result in DX.
		PUSH BX
		POP AX
		MOV [BP + -12], AX; line no 10 : c assined
		MOV BX, AX
; peepholed 194		PUSH BX

; peepholed 192		POP BX; line no 10 : ; previously pushed value on stack is removed
		
		MOV BX, [ BP-12 ]
; peepholed 198		PUSH BX; line no 11 : c loaded
; peepholed 197		POP BX
		PUSH BX
		CALL PRINT_DECIMAL_INTEGER
		
		MOV BX, [ BP-10 ]
		PUSH BX; line no 8 : a loaded
		POP AX
		PUSH AX

		INC AX
		MOV [BP + -10], AX; line no 8 : 
		JMP @L_9 ; go to check point
		@L_10: ; exit loop 

		
		; return point main
		@L_7: 
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
