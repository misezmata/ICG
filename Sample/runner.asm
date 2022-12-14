;Error at line 11: Type mismatch, function is not void

.MODEL SMALL
.STACK 400h

.DATA

.CODE
main PROC

MOV AX, @DATA
MOV DS, AX
; data segment loaded

PUSH 0 ; var declared: a offset: 0
PUSH 0
; if (expr) statement
POP BX
CMP BX, 0
JE @L_2
@L_2:
MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
PUSH 1

POP AX
MOV [BP + -10], AX
MOV BX, AX
PUSH BX

POP BX; a=1;

JMP @L_3
@L_2:
PUSH 2
; if (expr) statement
POP BX
CMP BX, 0
JE @L_4
@L_4:
MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
PUSH 2

POP AX
MOV [BP + -10], AX
MOV BX, AX
PUSH BX

POP BX; a=2;

JMP @L_5
@L_4:
MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
PUSH 3

POP AX
MOV [BP + -10], AX
MOV BX, AX
PUSH BX

POP BX; a=3;

@L_5:
@L_5:
MOV BX, [BP - 10]
PUSH BX
CALL PRINT_DECIMAL_INTEGER

@L_1:
MOV AH, 4CH
INT 21H
main ENDP


;Predefined Procedures
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
