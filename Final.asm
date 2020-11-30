include macros2.asm
include number.asm

.MODEL SMALL
.386
.STACK 200h

.DATA
NEW_LINE DB 0AH,0DH,'$'
CWprevio DW ?
String0 db "Ingrese un valor pivot mayor o igual a 1: ", '$'
pivot dd ?
_1 dd 1
@pos dd ?
_2 dd 2
_0 dd 0
_3 dd 3
_7 dd 7
resul dd ?
String1 db "Elemento encontrado en posición: ", '$'
String2 db "El valor debe ser >=1", '$'
String3 db "La posicion no se encontro", '$'
String4 db "FIN PROGRAMA", '$'

.CODE
START:
MOV AX, @DATA
MOV DS, AX
FINIT

displayString String0
displayString NEW_LINE

getInteger pivot

FILD pivot
FILD _1
FXCH
FCOMP
FSTSW AX
SAHF
JB etiqueta179
FILD _0
FISTP @pos
FILD pivot
FILD _2
FXCH
FCOMP
FSTSW AX
SAHF
JNE etiqueta160
FILD @pos
FILD _0
FXCH
FCOMP
FSTSW AX
SAHF
JNE etiqueta160
FILD _1
FISTP @pos
etiqueta160:
FILD pivot
FILD _3
FXCH
FCOMP
FSTSW AX
SAHF
JNE etiqueta166
FILD @pos
FILD _0
FXCH
FCOMP
FSTSW AX
SAHF
JNE etiqueta166
FILD _2
FISTP @pos
etiqueta166:
FILD pivot
FILD _7
FXCH
FCOMP
FSTSW AX
SAHF
JNE etiqueta172
FILD @pos
FILD _0
FXCH
FCOMP
FSTSW AX
SAHF
JNE etiqueta172
FILD _3
FISTP @pos
etiqueta172:
FILD @pos
FILD _0
FXCH
FCOMP
FSTSW AX
SAHF
JE etiqueta182
FILD @pos
FISTP resul
displayString String1
displayString NEW_LINE

DisplayInteger resul
displayString NEW_LINE

JMP etiqueta184
etiqueta179:
displayString String2
displayString NEW_LINE

JMP etiqueta184
etiqueta182:
displayString String3
displayString NEW_LINE

etiqueta184:
displayString String4
displayString NEW_LINE


MOV AH, 1
INT 21h
MOV AX, 4C00h
INT 21h

END START
