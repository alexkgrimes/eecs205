; #########################################################################
;
;   game.asm - Assembly file for EECS205 Assignment 4/5
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
include game.inc

;; Has keycodes
include keys.inc

;; For Drawing Text
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib
	
.DATA

Asteroid STRUCT
	curr_x DWORD ?
	curr_y DWORD ?
	dest_x DWORD ?
	dest_y DWORD ?
	bitmap DWORD ? ;; pointer to the bitmap
Asteroid ENDS

welcomeStr BYTE "WELCOME TO ASTEROIDS!", 0
startStr BYTE "PRESS SPACEBAR TO PLAY", 0
pausedStr BYTE "PAUSED: PRESS SPACEBAR TO CONTINUE", 0

status DWORD 0				;; 0:start, 1:play, 2:paused, 3:gameover
angle DWORD 0				;; current angle of fighter
xcenter DWORD 320
ycenter DWORD 240			;; x and y where the fighter sits

;; asteroids 
asteroid_1 Asteroid <400, 400, 0, 0, OFFSET asteroid_001> 		;; asteroid at 400, 400 with dest 0,0
asteroid_mouse Asteroid <450, 450, 0, 0, ?>  	;; for testing and mouse req

.CODE
	

GameInit PROC 

	;; draw the background and fighter ;;
	invoke BlackStarField				
	invoke DrawStarField
	invoke BasicBlit, OFFSET fighter_001, 320, 240

	;; print welcome messages ;;
	invoke DrawStr, OFFSET welcomeStr, 240, 100, 0ffh
	invoke DrawStr, OFFSET startStr, 230, 300, 0ffh

	ret         ;; Do not delete this line!!!
GameInit ENDP

GamePlay PROC USES eax ebx
	;; clear the screen to make things easier ;;
	invoke ClearScreen

	;; update status (start, play, paused, game over);;
	invoke KeyHandler 	

	;; decide what to do based on your game status ;;		
	cmp status, 0
	je  START
	cmp status, 1
	je  PLAY
	cmp status, 2
	je PAUSE
	cmp status, 3
	je GAMEOVER

START:
	;; simply continue to draw the start screen ;;
	invoke DrawStr, OFFSET welcomeStr, 240, 100, 0ffh
	invoke DrawStr, OFFSET startStr, 230, 300, 0ffh
	invoke DrawStarField
	invoke BasicBlit, OFFSET fighter_001, 320, 240
	jmp DONE

PLAY:
	;; find out what key was last pressed to update angle ;;
	invoke KeyHandler

	;; JUST FOR NOW: move the asteroid around with mouse;;
	invoke MouseHandler

	mov ebx, OFFSET asteroid_mouse
	invoke CheckIntersect, xcenter, ycenter, OFFSET fighter_001, (Asteroid PTR [ebx]).curr_x, (Asteroid PTR [ebx]).curr_y, OFFSET asteroid_001

	cmp eax, 1
	jne noCollision

	mov (Asteroid PTR [ebx]).bitmap, OFFSET nuke_002
	jmp continue

noCollision:
	mov (Asteroid PTR [ebx]).bitmap, OFFSET asteroid_001
	
continue:

	;; JUST FOR NOW: draw a random asteroid for now ;;
	mov eax, OFFSET asteroid_1

	;; Stuff you always do ;;
	invoke BasicBlit, (Asteroid PTR [ebx]).bitmap, (Asteroid PTR [ebx]).curr_x, (Asteroid PTR [ebx]).curr_y
	invoke BasicBlit, (Asteroid PTR [eax]).bitmap, (Asteroid PTR [eax]).curr_x, (Asteroid PTR [eax]).curr_y
	invoke RotateBlit, OFFSET fighter_001, 320, 240, angle
	invoke DrawStarField

	jmp DONE
	
PAUSE:
	;; show pause screen and message ;;
	invoke DrawStarField
	invoke BasicBlit, OFFSET fighter_001, 320, 240
	invoke DrawStr, OFFSET pausedStr, 200, 300, 0ffh
	jmp DONE

GAMEOVER:

DONE:
	ret         ;; Do not delete this line!!!
GamePlay ENDP

CheckIntersect PROC USES ebx ecx edx esi oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP
	
	LOCAL oneLeft:DWORD, oneRight:DWORD, oneTop:DWORD, oneBottom:DWORD
	LOCAL twoLeft:DWORD, twoRight: DWORD, twoTop:DWORD, twoBottom:DWORD

	;; Handle oneBitmap ;;
	mov eax, oneBitmap							;; eax <- oneBitmap
	mov ebx, (EECS205BITMAP PTR [eax]).dwWidth	
	shr ebx, 1 									;; ebx <- width / 2

	mov ecx, oneX								;; ecx <- oneX
	sub ecx, ebx								;; ecx <- (oneX - width / 2)
	mov oneLeft, ecx   ;; set oneLeft
	mov ecx, oneX
	add ecx, ebx								;; ecx <- (oneX + width / 2)
	mov oneRight, ecx  ;; set oneRight

	mov ebx, (EECS205BITMAP PTR [eax]).dwHeight
	shr ebx, 1									;; ebx <- (height / 2)

	mov ecx, oneY				
	sub ecx, ebx								;; ecx <- (oneY - height / 2)
	mov oneBottom, ecx	;; set oneButtom
	mov ecx, oneY
	add ecx, ebx								;; ecx <- (oneY + height / 2)
	mov oneTop, ecx		;; set oneTop

	;; Handle twoBitmap ;;
	mov eax, twoBitmap
	mov ebx, (EECS205BITMAP PTR [eax]).dwWidth
	shr ebx, 1									;; ebx <- width / 2

	mov ecx, twoX								
	sub ecx, ebx								;; ecx <- (twoX - width / 2)
	mov twoLeft, ecx	;; set twoLeft
	mov ecx, twoX
	add ecx, ebx								;; ecx <- (twoX + width / 2)
	mov twoRight, ecx	;; set twoRight

	mov ebx, (EECS205BITMAP PTR [eax]).dwHeight
	shr ebx, 1									;; ebx <- height / 2

	mov ecx, twoY
	sub ecx, ebx								;; ecx <- (twoY - height / 2)
	mov twoBottom, ecx	;; set twoBottom
	mov ecx, twoY
	add ecx, ebx								;; ecx <- (twoY + height / 2)
	mov twoTop, ecx		;; set twoTop

	xor eax, eax		;; clear the result

	mov ebx, oneLeft
	mov ecx, oneRight
	mov edx, oneTop
	mov esi, oneBottom

bottomRight:
	cmp twoLeft, ebx 
	jle bottomLeft 	;; twoLeft > oneLeft
	cmp twoLeft, ecx	
	jge bottomLeft	;;twoLeft < oneRight
	cmp twoTop, edx
	jge	bottomLeft	;; twoTop < oneTop
	cmp twoTop, esi
	jle bottomLeft	;; twoTop > oneBottom

	mov eax, 1
	jmp done

bottomLeft: 
	cmp twoRight, ebx
	jle topLeft		;; twoRight > oneLeft
	cmp twoRight, ecx
	jge topLeft		;; twoRight < oneRight
	cmp twoTop, edx
	jge topLeft		;; twoTop < oneTop
	cmp twoTop, esi
	jle topLeft		;; twoTop > oneBottom

	mov eax, 1
	jmp done

topLeft:
	cmp twoBottom, edx
	jge topRight	;; twoBottom < oneTop
	cmp twoBottom, esi
	jle topRight	;; twoBottom > oneBottom
	cmp twoRight, ebx
	jle topRight	;; twoRight > oneLeft
	cmp twoRight, ecx
	jge topRight	;; twoRight < oneRight

	mov eax, 1
	jmp done

topRight:
	cmp twoLeft, ebx 
	jle done 	;; twoLeft > oneLeft
	cmp twoLeft, ecx	
	jge done	;;twoLeft < oneRight
	cmp twoBottom, edx
	jge done	;; twoBottom < oneTop
	cmp twoBottom, esi
	jle done	;; twoBottom > oneBottom

	mov eax, 1
	jmp done

done:

	ret  	;;  Do not delete this line!
CheckIntersect ENDP

ClearScreen PROC USES eax edi ecx
  mov eax, 0
  mov edi, ScreenBitsPtr
  mov ecx, 4b000h
  REP STOSB

  ret
ClearScreen ENDP

KeyHandler PROC USES eax
    mov eax, KeyPress
    cmp eax, 20h 				;; a spacebar
    je spaceBar
    cmp eax, 50h				;; escape
    je pKey
 
    cmp eax, 27h				;; a rightArrow
    je rightArrow
    cmp eax, VK_LEFT
    je leftArrow
    jmp done

spaceBar:
	mov status, 1			;; play mode
    jmp done
pKey:
	mov status, 2			;; paused game
	jmp done

rightArrow:
	add angle, 3000h		;; rotate figher right
	jmp done
leftArrow:					;; rotate fighter left
	sub angle, 3000h
	jmp done

done:
      ret
KeyHandler ENDP


MouseHandler PROC USES eax esi ebx ecx edx

	mov esi, OFFSET MouseStatus
    mov ebx, (MouseInfo PTR [esi]).horiz
    mov ecx, (MouseInfo PTR [esi]).vert

    mov eax, OFFSET asteroid_mouse
    mov (Asteroid PTR [eax]).curr_x, ebx
    mov (Asteroid PTR [eax]).curr_y, ecx

	ret
MouseHandler ENDP


END
