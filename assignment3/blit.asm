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


changeBlit PROC USES eax ebx edx, x:DWORD, y:DWORD, color:DWORD
  mov edx, 640         
  mov eax, y 				
  imul edx					;; eax = row * 640

  mov edx, ScreenBitsPtr
  mov ebx, color
  add eax, x              	
  add eax, edx            	;; eax = ScreenBitsPtr + index
  mov BYTE PTR [eax], bl    ;; update the color byte in the buffer 

  ret
changeBlit ENDP


DrawPixel PROC USES edi esi eax ecx x:DWORD, y:DWORD, color:DWORD

	LOCAL width_:DWORD, height_:DWORD

	mov width_, 640				;; initialize values
	mov height_, 480
	mov ecx, color				;; ecx = color

	mov edi, width_				;; edi = height
	mov esi, height_			;; esi = width
	mov eax, ScreenBitsPtr

	cmp x, edi					;; checks for out of bounds
	jge return

	cmp y, esi
	jge return

	cmp x, 0
	jl return

	cmp y, 0
	jl return

	imul edi, y
	add edi, x 					;; width * row + col
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


RotateBlit PROC USES eax ebx ecx edx esi edi lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT

	LOCAL tColor:BYTE, shiftX:DWORD, shiftY:DWORD, dstWidth:DWORD 
	LOCAL dstHeight:DWORD, dstX:DWORD, dstY:DWORD, srcX:DWORD, srcY:DWORD
	LOCAL x:DWORD, y:DWORD

	invoke FixedCos, angle
	mov ecx, eax									;; ecx = cos(angle)
	invoke FixedSin, angle
	mov edi, eax 									;; edi = sin(angle)

	mov esi, lpBmp									;; esi = bitmap
	mov bl, (EECS205BITMAP PTR [esi]).bTransparent	
	mov tColor, bl 									;; tColor = bTranspartent

	;; setting shiftX
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	sal eax, 16
	imul ecx
	mov shiftX, edx			
	sar shiftX, 1									;; shiftX <- dwWidth*cosa / 2
	mov eax, (EECS205BITMAP PTR [esi]).dwHeight
	sal eax, 16
	imul edi
	sar edx, 1
	sub shiftX, edx 								;; shiftX is DONE


	;; setting shiftY
	mov eax, (EECS205BITMAP PTR [esi]).dwHeight
	sal eax, 16
	imul ecx
	mov shiftY, edx
	sar shiftY, 1
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	sal eax, 16
	imul edi
	sar edx, 1
	add shiftY, edx									;; shiftY is DONE

	;; setting dstWidth and dstHeight
	mov eax, (EECS205BITMAP PTR [esi]).dwWidth
	add eax, (EECS205BITMAP PTR [esi]).dwHeight
	mov dstWidth, eax
	mov dstHeight, eax 

	;; initialize the loop variables
	neg eax
	mov dstX, eax					;; dstX = -dstWidth
	mov dstY, eax					;; dstY = -dstHeight

	jmp condition_x

loop_x:
	mov eax, dstHeight				;; reset loop_y vars
	neg eax
	mov dstY, eax 

	loop_y:
		;; setting srcX
		mov eax, dstX
		sal eax, 16
		imul ecx
		mov srcX, edx
		mov eax, dstY
		sal eax, 16
		imul edi
		add srcX, edx 				;; srcX = dstX * cosa + dstY * sina

		;; setting srcY
		mov eax, dstY
		sal eax, 16
		imul ecx
		mov srcY, edx
		mov eax, dstX
		sal eax, 16
		imul edi
		sub srcY, edx 				;; srcY = dstY * cosa - dstX * sina

		;; THE IF STATEMENTS 											

		cmp srcX, 0
		jl break					;; srcX >= 0

		mov eax, (EECS205BITMAP PTR [esi]).dwWidth
		cmp srcX, eax
		jge break					;; srcX < (EECS205BITMAP PTR [esi]).dwWidth

		cmp srcY, 0
		jl break					;; srcY >= 0

		mov eax, (EECS205BITMAP PTR [esi]).dwHeight
		cmp srcY, eax
		jge break 					;; srcY < dwHeight

		mov eax, xcenter
		add eax, dstX
		sub eax, shiftX
		cmp eax, 0
		mov x, eax
		jl break 					;; (xcenter + dstX - shiftX >= 0)

		cmp eax, 639
		jge break 					;; (xcenter + dstX - shiftX < 639)

		mov eax, ycenter
		add eax, dstY
		sub eax, shiftY
		cmp eax, 0
		mov y, eax
		jl break 					;; (ycenter + dstY - shiftY) >= 0 

		cmp eax, 479
		jge break 					;; (ycenter + dstY - shiftY) < 479

		;; find color and compare to trasnparent
		mov eax, srcY
	    imul (EECS205BITMAP PTR[esi]).dwWidth
	    add eax, srcX
	    add eax, (EECS205BITMAP PTR[esi]).lpBytes
	    mov al, BYTE PTR [eax]
	    cmp al, (EECS205BITMAP PTR[esi]).bTransparent
      	je break

      	movzx eax, al

		invoke changeBlit, x, y, eax

	break:
		inc dstY					;; something was false, inc and continue

	condition_y: 				
		mov eax, dstY				;; dstY < dstHeight
		cmp eax, dstHeight
		jl loop_y
		
	inc dstX						;; break out of loop_y, inc loop_x var

condition_x: 
	mov eax, dstX					;; dstX < dstWidth
	cmp eax, dstWidth
	jl loop_x

	ret 			; Don't delete this line!!!		

RotateBlit ENDP

END

