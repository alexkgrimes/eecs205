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

BasicBlit PROC USES eax ebx ecx edx edi esi ptrBitmap:PTR EECS205BITMAP , xcenter:DWORD, ycenter:DWORD
	
	LOCAL x:DWORD, y:DWORD

	mov ebx, ptrBitmap								;; ebx = ptrBitmap
	mov eax, (EECS205BITMAP PTR [ebx]).lpBytes		;; eax = lpBytes

	mov ecx, xcenter								;; tmp: ecx = centerx
	mov edi, (EECS205BITMAP PTR [ebx]).dwWidth
	sar edi, 1					
	sub ecx, edi				
	mov x, ecx										;; x = start position in loop

	mov edx, ycenter								;; tmp: edx = centery
	mov edi, (EECS205BITMAP PTR [ebx]).dwHeight
	sar edi, 1
	sub edx, edi				
	mov y, edx										;; y = start position in loop

	xor esi, esi									;; clear the loop variables
	xor edi, edi
	mov ecx, (EECS205BITMAP PTR [ebx]).dwWidth		;; ecx = dwWidth

	;; x and y hold values for point placement
	;; esi and edi are counters through the EECS205BITMAP

	jmp conditionx

loopx:
	mov edi, 0										;; reset the inner loops variables
	mov y, edx
	jmp conditiony

	loopy:
		mov ecx, (EECS205BITMAP PTR [ebx]).dwWidth
		imul ecx, edi
		add ecx, esi
		mov cl, BYTE PTR[eax + ecx]					;; ecx = 8-bit color
		
		cmp cl, (EECS205BITMAP PTR [ebx]).bTransparent
		je over
		invoke DrawPixel, x, y, ecx					;; drawPixel if not transparent
	over:	
		inc y 										;; inc inner loop vars
		inc edi	

	conditiony:
		cmp edi, (EECS205BITMAP PTR [ebx]).dwHeight	;; if within the height
		jl loopy
	
	inc esi 										;; inc outer loop vars
	inc x
conditionx:
	cmp esi, (EECS205BITMAP PTR [ebx]).dwWidth		;; if within the width
	jl loopx


	ret 			; Don't delete this line!!!	
BasicBlit ENDP


RotateBlit PROC lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT

	ret 			; Don't delete this line!!!		
RotateBlit ENDP



END
