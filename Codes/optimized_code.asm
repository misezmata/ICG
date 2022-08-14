.MODEL SMALL

.STACK 400h; 1KB stack

.DATA

	
	x		DW		10 DUP(0); line no 1 : x declared
	y		DW		0; line no 6 : y declared
		
.CODE
		

	bar  PROC
		
		PUSH BP
        MOV BP, SP
        
        ; STORING THE GPRS
        ; DX for returning results
        PUSH AX
        PUSH BX
        PUSH CX
        PUSHF
        
        
		
		MOV CX, 10; line no 3 : ; new array of size 10
		@L_2:
		JCXZ @L_3
		PUSH BX
		DEC CX
		JMP @L_2
		@L_3: 
		PUSH BX ; line no 3 : b declared
		
		
		MOV BX, [ BP-30 ]
; peepholed 40		PUSH BX; line no 4 : b loaded
; peepholed 39		POP BX; line no 4 : ; Array index in BX
		SHL BX, 1; line no 4 :  ; because 2 byte element
		NEG BX
		ADD BX, -10; Array from BP/or data segment
		ADD BX,BP
		PUSH [BX]
		PUSH BX; line no 4 : ; address pushed to stack
		
		MOV BX, [ BP-30 ]
		PUSH BX; line no 4 : b loaded
		POP AX
		POP BX
		POP DX; line no 4 :  ;array value popped
		MOV [BX], AX; line no 4 : a assined
		MOV BX, AX
; peepholed 57		PUSH BX

; peepholed 55		POP BX; line no 4 : ; previously pushed value on stack is removed
		
		; return point bar
		@L_1: 
		MOV SP, BP
		SUB SP, 8
		POPF  
        
        POP CX
        POP BX
        POP AX
        
        POP BP
		RET 0
		

	bar ENDP

	main  PROC
		
		mov AX, @DATA
		mov DS, AX
		; data segment loaded
		
		
		; return point main
		@L_4: 
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
