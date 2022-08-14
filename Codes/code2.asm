.MODEL SMALL
.STACK 400h

.DATA
	x	DW	10	DUP(0)
	y	DW	0

.CODE
PROC bar

; preserving sp(in BP), ax, bx, cx, flags
PUSH BP
MOV BP, SP

PUSH AX
PUSH BX
PUSH CX
PUSHF
; function definition here

; var declared: a[10]
MOV CX, 10
@L_0:
JCXZ @L_1
PUSH 0
DEC CX
JMP @L_0
@L_1:

PUSH 0 ; var declared: b
;terminating function
POPF
POP CX
POP BX
POP AX
POP BP

bar ENDP

PROC main

main ENDP


