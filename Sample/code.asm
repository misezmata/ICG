.MODEL SMALL
.STACK 400h

.DATA

.CODE
f PROC

; preserving sp(in BP), ax, bx, cx, flags
PUSH BP
MOV BP, SP

PUSH AX
PUSH BX
PUSH CX
PUSHF
; function definition here

PUSH 0 ; var declared: k offset: 0
MOV BX, [BP - 10] ; loaded k
PUSH BX ;stored in stack
PUSH 5

POP AX
;k
; si: k
; search key: k
MOV [BP + -10], AX
MOV BX, AX
PUSH BX

POP BX; k=5;

; while statement started
@L_2:
MOV BX, [BP - 10] ; loaded k
PUSH BX ;stored in stack
PUSH 0
POP BX
POP AX
CMP AX, BX
MOV BX, 1
JG @L_4
MOV BX, 0
@L_4: 
PUSH BX

CMP BX, 0
JE @L_3
MOV BX, [BP + 4]
PUSH BX
;a
POP AX
PUSH AX
INC AX
MOV [BP + 4], AX
POP BX; a++;

MOV BX, [BP - 10] ; loaded k
PUSH BX ;stored in stack
;k
POP AX
PUSH AX
DEC AX
MOV [BP + -10], AX
POP BX; k--;

JMP @L_2
@L_3:
;while loop ended
PUSH 3
MOV BX, [BP + 4]
PUSH BX
; MULTIPLICATION STARTS
POP BX
MOV CX, BX
POP AX
IMUL CX
MOV BX, AX
PUSH BX
; MULTIPLICATION ENDS
PUSH 7

POP BX
POP AX
SUB AX, BX
MOV BX, AX
PUSH BX

POP BX
MOV DX, BX
JMP @L_1
MOV BX, [BP + 4]
PUSH BX
PUSH 9

POP AX
;a
; si: a
; search key: a
MOV [BP + 4], AX
MOV BX, AX
PUSH BX

POP BX; a=9;

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

f ENDP

g PROC

; preserving sp(in BP), ax, bx, cx, flags
PUSH BP
MOV BP, SP

PUSH AX
PUSH BX
PUSH CX
PUSHF
; function definition here

PUSH 0 ; var declared: x offset: 0
PUSH 0 ; var declared: i offset: 0
MOV BX, [BP - 10] ; loaded x
PUSH BX ;stored in stack
MOV BX, [BP + 6]
PUSH BX
CALL f
MOV BX, DX
PUSH BX
MOV BX, [BP + 6]
PUSH BX

POP BX
POP AX
ADD BX, AX
PUSH BX

MOV BX, [BP + 4]
PUSH BX

POP BX
POP AX
ADD BX, AX
PUSH BX


POP AX
;x
; si: x
; search key: x
MOV [BP + -10], AX
MOV BX, AX
PUSH BX

POP BX; x=f(a)+a+b;

;for started
MOV BX, [BP - 12] ; loaded i
PUSH BX ;stored in stack
PUSH 0

POP AX
;i
; si: i
; search key: i
MOV [BP + -12], AX
MOV BX, AX
PUSH BX

POP BX; i=0;

@L_6:
MOV BX, [BP - 12] ; loaded i
PUSH BX ;stored in stack
PUSH 7
POP BX
POP AX
CMP AX, BX
MOV BX, 1
JL @L_10
MOV BX, 0
@L_10: 
PUSH BX

POP BX; i<7;

CMP BX, 0
JE @L_9
JMP @L_8
@L_7:
MOV BX, [BP - 12] ; loaded i
PUSH BX ;stored in stack
;i
POP AX
PUSH AX
INC AX
MOV [BP + -12], AX
JMP @L_6
@L_8:
MOV BX, [BP - 12] ; loaded i
PUSH BX ;stored in stack
PUSH 3
; MOD STARTS
POP BX
MOV CX, BX
XOR DX, DX
POP AX
IDIV CX
MOV BX, DX
PUSH BX
; MOD ENDS
PUSH 0
POP BX
POP AX
CMP AX, BX
MOV BX, 1
JE @L_11
MOV BX, 0
@L_11: 
PUSH BX

POP BX
CMP BX, 0
JE @L_12
MOV BX, [BP - 10] ; loaded x
PUSH BX ;stored in stack
MOV BX, [BP - 10] ; loaded x
PUSH BX ;stored in stack
PUSH 5

POP BX
POP AX
ADD BX, AX
PUSH BX


POP AX
;x
; si: x
; search key: x
MOV [BP + -10], AX
MOV BX, AX
PUSH BX

POP BX; x=x+5;

JMP @L_13
@L_12:
MOV BX, [BP - 10] ; loaded x
PUSH BX ;stored in stack
MOV BX, [BP - 10] ; loaded x
PUSH BX ;stored in stack
PUSH 1

POP BX
POP AX
SUB AX, BX
MOV BX, AX
PUSH BX


POP AX
;x
; si: x
; search key: x
MOV [BP + -10], AX
MOV BX, AX
PUSH BX

POP BX; x=x-1;

@L_13:
JMP @L_7
@L_9:
MOV BX, [BP - 10] ; loaded x
PUSH BX ;stored in stack
POP BX
MOV DX, BX
JMP @L_5
;terminating function
@L_5:
MOV SP, BP
SUB SP, 8
POPF
POP CX
POP BX
POP AX
POP BP

RET 4

g ENDP

main PROC

MOV AX, @DATA
MOV DS, AX
; data segment loaded

PUSH 0 ; var declared: a offset: 0
PUSH 0 ; var declared: b offset: 0
PUSH 0 ; var declared: i offset: 0
MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
PUSH 1

POP AX
;a
; si: a
; search key: a
MOV [BP + -10], AX
MOV BX, AX
PUSH BX

POP BX; a=1;

MOV BX, [BP - 12] ; loaded b
PUSH BX ;stored in stack
PUSH 2

POP AX
;b
; si: b
; search key: b
MOV [BP + -12], AX
MOV BX, AX
PUSH BX

POP BX; b=2;

MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
MOV BX, [BP - 12] ; loaded b
PUSH BX ;stored in stack
CALL g
MOV BX, DX
PUSH BX

POP AX
;a
; si: a
; search key: a
MOV [BP + -10], AX
MOV BX, AX
PUSH BX

POP BX; a=g(a,b);

MOV BX, [BP - 10]
PUSH BX
CALL PRINT_DECIMAL_INTEGER
;for started
MOV BX, [BP - 14] ; loaded i
PUSH BX ;stored in stack
PUSH 0

POP AX
;i
; si: i
; search key: i
MOV [BP + -14], AX
MOV BX, AX
PUSH BX

POP BX; i=0;

@L_15:
MOV BX, [BP - 14] ; loaded i
PUSH BX ;stored in stack
PUSH 4
POP BX
POP AX
CMP AX, BX
MOV BX, 1
JL @L_19
MOV BX, 0
@L_19: 
PUSH BX

POP BX; i<4;

CMP BX, 0
JE @L_18
JMP @L_17
@L_16:
MOV BX, [BP - 14] ; loaded i
PUSH BX ;stored in stack
;i
POP AX
PUSH AX
INC AX
MOV [BP + -14], AX
JMP @L_15
@L_17:
MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
PUSH 3

POP AX
;a
; si: a
; search key: a
MOV [BP + -10], AX
MOV BX, AX
PUSH BX

POP BX; a=3;

; while statement started
@L_20:
MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
PUSH 0
POP BX
POP AX
CMP AX, BX
MOV BX, 1
JG @L_22
MOV BX, 0
@L_22: 
PUSH BX

CMP BX, 0
JE @L_21
MOV BX, [BP - 12] ; loaded b
PUSH BX ;stored in stack
;b
POP AX
PUSH AX
INC AX
MOV [BP + -12], AX
POP BX; b++;

MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
;a
POP AX
PUSH AX
DEC AX
MOV [BP + -10], AX
POP BX; a--;

JMP @L_20
@L_21:
;while loop ended
JMP @L_16
@L_18:
MOV BX, [BP - 10]
PUSH BX
CALL PRINT_DECIMAL_INTEGER
MOV BX, [BP - 12]
PUSH BX
CALL PRINT_DECIMAL_INTEGER
MOV BX, [BP - 14]
PUSH BX
CALL PRINT_DECIMAL_INTEGER
PUSH 0
POP BX
MOV DX, BX
JMP @L_14

@L_14:
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
