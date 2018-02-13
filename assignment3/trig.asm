; #########################################################################
;
;   trig.asm - Assembly file for EECS205 Assignment 3
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include trig.inc

.DATA

;;  These are some useful constants (fixed point values that correspond to important angles)
PI_HALF = 102943           	;;  PI / 2
PI =  205887	                ;;  PI 
TWO_PI	= 411774                ;;  2 * PI 
PI_INC_RECIP =  5340353        	;;  Use reciprocal to find the table entry for a given angle
	                        ;;              (It is easier to use than divison would be)


	;; If you need to, you can place global variable shere
	
.CODE

FixedSin PROC angle:FXPT

	LOCAL index:DWORD, negIt:DWORD
 
	mov index, 0					;;initialize these locals
	mov negIt, 0

	mov eax, angle
	;;mov eax, 0ffff0000h			;; for testing

	jmp conditionSub

doSub:								;; get angle in 0 to 2pi range
	sub eax, TWO_PI					;; if > 2pi

conditionSub:
	cmp eax, TWO_PI
	jge doSub

jmp conditionAdd

doAdd:								;; get angle in range 0 to 2pi
	add eax, TWO_PI					;; if < 0

conditionAdd:
	cmp eax, 0
	jl  doAdd
	
piTo2Pi:
	cmp eax, PI 					;; if pi < x < 2pi
	jle piOver2ToPi
	cmp eax, TWO_PI
	jge piOver2ToPi

	mov negIt, 1					;; must take neg of sin(x)
	sub eax, PI 					;; angle  = angle - PI


piOver2ToPi:
	cmp eax, PI_HALF				;; if pi/2 < x < pi
	jle rawAngle
	cmp eax, PI 
	jg rawAngle
	neg eax
	add eax, PI 					;; angle = PI - angle
	jmp rawAngle
 

rawAngle:							;; YAY! it's in range for the table
	mov edx, PI_INC_RECIP			;; {edx:eax} = angle * reciprocal
	imul edx						;; index <- edx
	
	xor eax, eax					;; clear eax before loading
	mov ax, [SINTAB + 2 * edx]		;; SINTAB[index] -> eax

	cmp negIt, 0					;; gotta neg the value for pi to 2pi
	je return
	neg eax

return:
	ret			; Don't delete this line!!!
FixedSin ENDP 

FixedCos PROC USES edi angle:FXPT

	mov edi, angle
	add edi, PI_HALF
	invoke FixedSin, edi

	ret			; Don't delete this line!!!	
FixedCos ENDP	
END
