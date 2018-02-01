; #########################################################################
;
;   lines.asm - Assembly file for EECS205 Assignment 2
;	Name: Alexandra Grimes
;	NetID: akg434
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc

.DATA

	;; If you need to, you can place global variables here
	
.CODE
	

;; Don't forget to add the USES the directive here
;;   Place any registers that you modify (either explicitly or implicitly)
;;   into the USES list so that caller's values can be preserved
	
;;   For example, if your procedure uses only the eax and ebx registers
;;      DrawLine PROC USES eax ebx x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
DrawLine PROC USES edi esi ebx edx eax x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
	;; Feel free to use local variables...declare them here
	;; For example:
	;; 	LOCAL foo:DWORD, bar:DWORD
	LOCAL delta_x:DWORD, delta_y:DWORD, inc_x:DWORD, inc_y:DWORD, error:DWORD, prev_error: DWORD, curr_x:DWORD, curr_y:DWORD
	
	;; Place your code here

	mov edi, x0
	mov esi, x1
	sub esi, edi		;; x1 - x0 -> esi
	cmp esi, 0 			
	jg POS				;; if diff is positive, don't neg
	neg esi
POS:
	mov delta_x, esi	;; delta_x = x1 - x0

	mov edi, y0
	mov esi, y1
	sub esi, edi		;; y1 - y0 -> esi
	cmp esi, 0
	jg POS2				;; if diff is positive, don't neg
	neg esi
POS2:
	mov delta_y, esi	;; delta_y = y1 - y0

	mov edi, x0
	mov esi, x1
	cmp edi, esi		;; x0 < x1
	jge NEGATIVE
	mov inc_x, 1		;; inc_x = 1
	jmp CONT1
NEGATIVE:
	mov inc_x, -1		;; inc_y = -1

CONT1:
	mov edi, y0
	mov esi, y1
	sub edi, esi		;; y0 < y1
	jge NEGATIVE2
	mov inc_y, 1		;; inc_y = 1
	jmp CONT2
NEGATIVE2:
	mov inc_y, -1		;; inc_y = 1

CONT2:
	mov edi, delta_x
	mov esi, delta_y
	cmp edi, esi		;; delta_x > delta_y
	jle NEGERROR
	sar edi, 1			;; delta_x / 2
	mov error, edi		;; error = delta_x /2
	jmp CONT3
NEGERROR:
	sar esi, 1			;; delta_y / 2
	neg esi
	mov error, esi		;; error = - delta_y / 2

CONT3:
	mov edi, x0
	mov esi, y0
	mov curr_x, edi		;; curr_x = x0
	mov curr_y, esi		;; curr_y = y0

	invoke DrawPixel, curr_x, curr_y, color


BEGIN:
	mov edi, curr_x		;; curr_x -> edi
	mov esi, curr_y		;; curr_y -> esi
	cmp edi, x1			;; curr_x != x1
	jne CONTINUE
	cmp esi, y1			;; curr_y != y1
	jz  EXIT


CONTINUE:
	invoke DrawPixel, curr_x, curr_y, color

	mov edx, error 		;; error -> edx
	mov prev_error, edx	;; prev_error = error

	mov ebx, prev_error ;; prev_error -> ebx
	mov eax, delta_x	
	neg eax 			;; -delta_x -> eax
	cmp ebx, eax 		;; prev_error > - delta_x
	jle NEXT
	sub edx, delta_y	
	mov error, edx		;; error = error - delta_y
	add edi, inc_x
	mov curr_x, edi		;; curr_x = curr_x + inc_x

NEXT:

	cmp ebx, delta_y	;; prev_error < delta_y
	jge BEGIN
	add edx, delta_x
	mov error, edx		;; error = error + delta_x
	add esi, inc_y
	mov curr_y, esi		;; curr_y = curr_y _ inc_y

	jmp BEGIN

EXIT:
	ret        	;;  Don't delete this line...you need it
DrawLine ENDP




END
