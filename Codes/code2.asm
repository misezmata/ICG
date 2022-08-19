.MODEL SMALL
.STACK 400h

.DATA

.CODE
main PROC

MOV AX, @DATA
MOV DS, AX
; data segment loaded

PUSH 0 ; var declared: a offset: 0
MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
PUSH 10

POP AX
MOV [BP + -10], AX
MOV BX, AX
PUSH BX

POP BX; kijani ekta pop!


PUSH 0 ; var declared: a offset: 0
MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
PUSH 0

POP AX
MOV [BP + -10], AX
MOV BX, AX
PUSH BX

POP BX; kijani ekta pop!


MOV BX, [BP - 10] ; loaded a
PUSH BX ;stored in stack
POP BX
MOV DX, BX
JMP @L_0

@L_0:
MOV AH, 4CH
INT 21H
main ENDP


