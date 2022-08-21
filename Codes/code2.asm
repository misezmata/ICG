;Error at line 13: Type mismatch, function is not void

.MODEL SMALL
.STACK 400h

.DATA

.CODE
fib PROC

; preserving sp(in BP), ax, bx, cx, flags
PUSH BP
MOV BP, SP

PUSH AX
PUSH BX
PUSH CX
PUSHF
; function definition here

MOV BX, [BP + 4]
PUSH BX
PUSH 1
POP BX
POP AX
CMP AX, BX
MOV BX, 1
JE @L_2
MOV BX, 0
@L_2: 
PUSH BX

MOV BX, [BP + 4]
PUSH BX
PUSH 2
POP BX
POP AX
CMP AX, BX
MOV BX, 1
JE @L_3
MOV BX, 0
@L_3: 
PUSH BX

;logical or
POP BX
POP AX
OR BX, AX
PUSH BX
POP BX
CMP BX, 0
JE @L_6
PUSH 1
POP BX
MOV DX, BX
JMP @L_1
@L_6:
MOV BX, [BP + 4]
PUSH BX
PUSH 1

POP BX
POP AX
SUB AX, BX
MOV BX, AX
PUSH BX

CALL fib
MOV BX, DX
PUSH BX
MOV BX, [BP + 4]
PUSH BX
PUSH 2

POP BX
POP AX
SUB AX, BX
MOV BX, AX
PUSH BX

CALL fib
MOV BX, DX
PUSH BX

POP BX
POP AX
ADD BX, AX
PUSH BX

POP BX
MOV DX, BX
JMP @L_1
;terminating function
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

main PROC

MOV AX, @DATA
MOV DS, AX
; data segment loaded

PUSH 0 ; var declared: a offset: 0
;for started
MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
PUSH 1

POP AX
MOV [BP + -10], AX
MOV BX, AX
PUSH BX

POP BX; a=1;

@L_9:
MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
PUSH 10
POP BX
POP AX
CMP AX, BX
MOV BX, 1
JL @L_13
MOV BX, 0
@L_13: 
PUSH BX

POP BX; a<10;

CMP BX, 0
JE @L_12
JMP @L_11
@L_10:
MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
POP AX
PUSH AX
INC AX
MOV [BP + -10], AX
JMP @L_9
@L_11:
PUSH 0 ; var declared: c offset: 0
MOV BX, [BP - 12] ; loaded c
PUSH BX ;stored in stack
MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
CALL fib
MOV BX, DX
PUSH BX

POP AX
MOV [BP + -12], AX
MOV BX, AX
PUSH BX

POP BX; c=fib(a);

MOV BX, [BP - 12]
PUSH BX
CALL PRINT_DECIMAL_INTEGER
JMP @L_10
@L_12:

@L_8:
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
