; #########################################################################
;
;   blit.asm - Assembly file for EECS205 Assignment 3
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc


.DATA

	;; If you need to, you can place global variables here
	
.CODE

DrawPixel PROC USES edi esi eax x:DWORD, y:DWORD, color:DWORD

	LOCAL width_:DWORD, height_:DWORD, index:DWORD

	mov width_, 640				;; initialize values
	mov height_, 480
	mov ecx, color				;; ecx = color
	mov index, 0

	mov edi, width_				;; edi = height
	mov esi, height_			;; esi = width
	mov eax, ScreenBitsPtr

	cmp x, edi				;; checks for out of bounds
	jge return

	cmp y, esi
	jge return

	imul edi, y
	add edi, x 				;; width * row + col
	mov BYTE PTR[eax + edi], cl

return:
	ret 			; Don't delete this line!!!
DrawPixel ENDP

BasicBlit PROC ptrBitmap:PTR EECS205BITMAP , xcenter:DWORD, ycenter:DWORD

	ret 			; Don't delete this line!!!	
BasicBlit ENDP


RotateBlit PROC lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT

	ret 			; Don't delete this line!!!		
RotateBlit ENDP



END
