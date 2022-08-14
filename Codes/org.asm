PUSH BX ;x,1 offset 0
PROC foo

; preserving sp(in BP), ax, bx, cx, flags
PUSH BP
MOV BP, SP

PUSH AX
PUSH BX
PUSH CX
PUSHF
; function definition here

PUSH BX ;a,1_1 offset 0
PUSH BX ;b,1_1_1 offset 0
PUSH BX ;b,1_1 offset 1
;terminating function
POPF
POP CX
POP BX
POP AX
POP BP

foo ENDP

PROC main

PUSH BX ;a,1_2 offset 0
main ENDP

