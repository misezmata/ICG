.MODEL SMALL

.STACK 400h; 1KB stack

.DATA

	
		
.CODE
		

	main  PROC
		
		mov AX, @DATA
		mov DS, AX
		; data segment loaded
		
		PUSH BX ; line no 3 : i declared
		PUSH BX ; line no 3 : j declared
		PUSH BX ; line no 3 : k declared
		PUSH BX ; line no 3 : ll declared
		PUSH BX ; line no 3 : m declared
		PUSH BX ; line no 3 : n declared
		PUSH BX ; line no 3 : o declared
		PUSH BX ; line no 3 : p declared
		
		MOV BX, [ BP-10 ]
		PUSH BX; line no 5 : i loaded
		
		PUSH 1
		POP AX
		MOV [BP + -10], AX; line no 5 : i assined
		MOV BX, AX
; peepholed 36		PUSH BX

; peepholed 34		POP BX; line no 5 : ; previously pushed value on stack is removed
		
		MOV BX, [ BP-10 ]
; peepholed 40		PUSH BX; line no 6 : i loaded
; peepholed 39		POP BX
		PUSH BX
		CALL PRINT_DECIMAL_INTEGER
		
		MOV BX, [ BP-12 ]
		PUSH BX; line no 7 : j loaded
		
		PUSH 5
		
		PUSH 8

		POP BX
		POP AX
		ADD BX, AX
		PUSH BX

		POP AX
		MOV [BP + -12], AX; line no 7 : j assined
		MOV BX, AX
; peepholed 61		PUSH BX

; peepholed 59		POP BX; line no 7 : ; previously pushed value on stack is removed
		
		MOV BX, [ BP-12 ]
; peepholed 65		PUSH BX; line no 8 : j loaded
; peepholed 64		POP BX
		PUSH BX
		CALL PRINT_DECIMAL_INTEGER
		
		MOV BX, [ BP-14 ]
		PUSH BX; line no 9 : k loaded
		
		MOV BX, [ BP-10 ]
		PUSH BX; line no 9 : i loaded
		
		PUSH 2
		
		MOV BX, [ BP-12 ]
; peepholed 79		PUSH BX; line no 9 : j loaded
; peepholed 78		POP BX; line no 9 :  ; multiplication start of integer
		MOV CX, BX
		POP AX
		IMUL CX
		MOV BX, AX; line no 9 :  ; only last 16 bit is taken in mul
; peepholed 86		PUSH BX

; peepholed 84		POP BX
		POP AX
		ADD BX, AX
		PUSH BX

		POP AX
		MOV [BP + -14], AX; line no 9 : k assined
		MOV BX, AX
; peepholed 96		PUSH BX

; peepholed 94		POP BX; line no 9 : ; previously pushed value on stack is removed
		
		MOV BX, [ BP-14 ]
; peepholed 100		PUSH BX; line no 10 : k loaded
; peepholed 99		POP BX
		PUSH BX
		CALL PRINT_DECIMAL_INTEGER
		
		MOV BX, [ BP-18 ]
		PUSH BX; line no 12 : m loaded
		
		MOV BX, [ BP-14 ]
		PUSH BX; line no 12 : k loaded
		
		PUSH 9
		POP BX
		MOV CX, BX; line no 12 :  ; / or % operation
		XOR DX, DX
		POP AX
		IDIV CX
		MOV BX, DX
		PUSH BX
		POP AX
		MOV [BP + -18], AX; line no 12 : m assined
		MOV BX, AX
; peepholed 123		PUSH BX

; peepholed 121		POP BX; line no 12 : ; previously pushed value on stack is removed
		
		MOV BX, [ BP-18 ]
; peepholed 127		PUSH BX; line no 13 : m loaded
; peepholed 126		POP BX
		PUSH BX
		CALL PRINT_DECIMAL_INTEGER
		
		MOV BX, [ BP-20 ]
		PUSH BX; line no 15 : n loaded
		
		MOV BX, [ BP-18 ]
		PUSH BX; line no 15 : m loaded
		
		MOV BX, [ BP-16 ]
; peepholed 141		PUSH BX; line no 15 : ll loaded
		

; peepholed 138		POP BX
		POP AX
		CMP AX, BX; line no 15 :  relop operation
		MOV BX, 1; line no 15 :  First let it assume positive
		JLE @L_2
		MOV BX, 0; line no 15 :  the condition is false
		@L_2: 

		PUSH BX

		POP AX
		MOV [BP + -20], AX; line no 15 : n assined
		MOV BX, AX
; peepholed 156		PUSH BX

; peepholed 154		POP BX; line no 15 : ; previously pushed value on stack is removed
		
		MOV BX, [ BP-20 ]
; peepholed 160		PUSH BX; line no 16 : n loaded
; peepholed 159		POP BX
		PUSH BX
		CALL PRINT_DECIMAL_INTEGER
		
		MOV BX, [ BP-22 ]
		PUSH BX; line no 18 : o loaded
		
		MOV BX, [ BP-10 ]
		PUSH BX; line no 18 : i loaded
		
		MOV BX, [ BP-12 ]
; peepholed 174		PUSH BX; line no 18 : j loaded
		

; peepholed 171		POP BX
		POP AX
		CMP AX, BX; line no 18 :  relop operation
		MOV BX, 1; line no 18 :  First let it assume positive
		JNE @L_3
		MOV BX, 0; line no 18 :  the condition is false
		@L_3: 

		PUSH BX

		POP AX
		MOV [BP + -22], AX; line no 18 : o assined
		MOV BX, AX
; peepholed 189		PUSH BX

; peepholed 187		POP BX; line no 18 : ; previously pushed value on stack is removed
		
		MOV BX, [ BP-22 ]
; peepholed 193		PUSH BX; line no 19 : o loaded
; peepholed 192		POP BX
		PUSH BX
		CALL PRINT_DECIMAL_INTEGER
		
		MOV BX, [ BP-24 ]
		PUSH BX; line no 21 : p loaded
		
		MOV BX, [ BP-20 ]
		PUSH BX; line no 21 : n loaded
		
		MOV BX, [ BP-22 ]
; peepholed 208		PUSH BX; line no 21 : o loaded
		

		; OR OPERATION
; peepholed 204		POP BX
		POP AX
		OR BX, AX
		PUSH BX
		POP AX
		MOV [BP + -24], AX; line no 21 : p assined
		MOV BX, AX
; peepholed 217		PUSH BX

; peepholed 215		POP BX; line no 21 : ; previously pushed value on stack is removed
		
		MOV BX, [ BP-24 ]
; peepholed 221		PUSH BX; line no 22 : p loaded
; peepholed 220		POP BX
		PUSH BX
		CALL PRINT_DECIMAL_INTEGER
		
		MOV BX, [ BP-24 ]
		PUSH BX; line no 24 : p loaded
		
		MOV BX, [ BP-20 ]
		PUSH BX; line no 24 : n loaded
		
		MOV BX, [ BP-22 ]
; peepholed 235		PUSH BX; line no 24 : o loaded
		

; peepholed 232		POP BX
		CMP BX, 0
		JE @L_6; line no 24 :  ; not true
		POP BX
		CMP BX, 0
		JE @L_6; line no 24 :  ; not true
		PUSH 1; line no 24 : ; conditioin is true
		JMP @L_7
		@L_6: 
		PUSH 0
		@L_7: ; line no 24 :  ; exiting and operation
		POP AX
		MOV [BP + -24], AX; line no 24 : p assined
		MOV BX, AX
; peepholed 251		PUSH BX

; peepholed 249		POP BX; line no 24 : ; previously pushed value on stack is removed
		
		MOV BX, [ BP-24 ]
; peepholed 255		PUSH BX; line no 25 : p loaded
; peepholed 254		POP BX
		PUSH BX
		CALL PRINT_DECIMAL_INTEGER
		
		MOV BX, [ BP-24 ]
		PUSH BX; line no 27 : p loaded
		POP AX
		PUSH AX

		INC AX
		MOV [BP + -24], AX; line no 27 : 
		POP BX; line no 27 : ; previously pushed value on stack is removed
		
		MOV BX, [ BP-24 ]
; peepholed 270		PUSH BX; line no 28 : p loaded
; peepholed 269		POP BX
		PUSH BX
		CALL PRINT_DECIMAL_INTEGER
		
		MOV BX, [ BP-14 ]
		PUSH BX; line no 30 : k loaded
		
		MOV BX, [ BP-24 ]
; peepholed 279		PUSH BX; line no 30 : p loaded
; peepholed 278		POP BX
		NEG BX
		PUSH BX
		POP AX
		MOV [BP + -14], AX; line no 30 : k assined
		MOV BX, AX
; peepholed 287		PUSH BX

; peepholed 285		POP BX; line no 30 : ; previously pushed value on stack is removed
		
		MOV BX, [ BP-14 ]
; peepholed 291		PUSH BX; line no 31 : k loaded
; peepholed 290		POP BX
		PUSH BX
		CALL PRINT_DECIMAL_INTEGER
		
		
		PUSH 0
		POP BX; line no 36 :  return value saved in DX 
		MOV DX, BX
		JMP @L_1; line no 36 :  ; exit from the function
		
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
