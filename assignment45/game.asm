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

;; constant declarations ;; 
welcomeStr BYTE "WELCOME TO ASTEROIDS!", 0
startStr BYTE "PRESS SPACEBAR TO PLAY", 0
pausedStr BYTE "PAUSED: PRESS SPACEBAR TO CONTINUE", 0

status DWORD 0				;; 0:start, 1:play, 2:paused, 3:gameover
angle DWORD 0				;; current angle of fighter
xcenter DWORD 320
ycenter DWORD 240			;; x and y where the fighter sits

PI_HALF = 102943           	;;  PI / 2
PI =  205887	            ;;  PI 
TWO_PI	= 411774            ;;  2 * PI 

;; struct declarations ;;
Sprite STRUCT
	x DWORD ?
	y DWORD ?
	bitmap DWORD ? ;; pointer to the bitmap
Sprite ENDS

Player STRUCT	
	lastPressed DWORD ?
	x DWORD ?
	y DWORD ?
	angle DWORD ?
	bitmap DWORD ?
Player ENDS

;; object declarations ;;
p1 Player <?, 590, 240, -PI_HALF, OFFSET fighter_001>
p2 Player <?, 50, 240, PI_HALF, OFFSET fighter_001>
p1Sprites Sprite 1 DUP (<400, 400, OFFSET nuke_000>)

.CODE
	

GameInit PROC 

	;; draw the background and fighters ;;
	invoke DrawStarField
	invoke RotateBlit, p1.bitmap, p1.x, p1.y, p1.angle
	invoke RotateBlit, p2.bitmap, p2.x, p2.y, p2.angle

	;; print welcome messages ;;
	invoke DrawStr, OFFSET welcomeStr, 240, 100, 0ffh
	invoke DrawStr, OFFSET startStr, 230, 300, 0ffh

	ret         ;; Do not delete this line!!!
GameInit ENDP

GamePlay PROC USES eax ebx
	;; clear the screen to make things easier ;;
	invoke ClearScreen

	;; update status (start, play, paused, game over) ;;
	;; update players keyPressed values ;;
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

	;; draw background and fighters ;;
	invoke DrawStarField
	invoke RotateBlit, p1.bitmap, p1.x, p1.y, p1.angle
	invoke RotateBlit, p2.bitmap, p2.x, p2.y, p2.angle
	jmp DONE

PLAY:
	;; find out what key was last pressed to update lastPressed for the players ;;
	invoke KeyHandler

	;; JUST FOR NOW: move the asteroid around with mouse;;
	;; invoke MouseHandler

	;;mov ebx, OFFSET asteroid_mouse
	;;invoke CheckIntersect, xcenter, ycenter, OFFSET fighter_001, (Asteroid PTR [ebx]).curr_x, (Asteroid PTR [ebx]).curr_y, OFFSET asteroid_001

	;;cmp eax, 1
	;;jne noCollision

	;;mov (Asteroid PTR [ebx]).bitmap, OFFSET nuke_002
	;;jmp continue

;;noCollision:
	;;mov (Asteroid PTR [ebx]).bitmap, OFFSET asteroid_001
	
continue:
	;; draw background and fighters ;;
	invoke UpdatePositions

	invoke DrawStarField
	invoke RotateBlit, p1.bitmap, p1.x, p1.y, p1.angle
	invoke RotateBlit, p2.bitmap, p2.x, p2.y, p2.angle


	mov eax, OFFSET p1Sprites
	invoke BasicBlit, (Sprite PTR [eax]).bitmap, (Sprite PTR [eax]).x, (Sprite PTR [eax]).y 
	jmp DONE
	
PAUSE:
	;; show pause screen and message ;;
	invoke DrawStarField
	invoke RotateBlit, OFFSET fighter_001, 50, 240, PI_HALF
	invoke RotateBlit, OFFSET fighter_001, 590, 240, - PI_HALF
	invoke DrawStr, OFFSET pausedStr, 200, 300, 0ffh
	jmp DONE

GAMEOVER:

DONE:
	ret         ;; Do not delete this line!!!
GamePlay ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;							 ;;
;; 	  UpdatePositions        ;;
;;							 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UpdatePositions PROC
	;; player1 ;;
	cmp p1.lastPressed, VK_UP
	je p1MoveUp
	cmp p1.lastPressed, VK_DOWN
	je p1MoveDown
	jmp player2

p1MoveUp:
	sub p1.y, 5
	jmp player2
p1MoveDown:
	add p1.y, 5
	jmp player2

player2:
	cmp p2.lastPressed, VK_S
	je p2MoveDown
	cmp p2.lastPressed, VK_W
	je p2MoveUp
	jmp done
p2MoveUp:
	sub p2.y, 5
	jmp done
p2MoveDown:
	add p2.y, 5
	jmp done

done:
	ret
UpdatePositions ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;							 ;;
;; 		  ClearScreen        ;;
;;							 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClearScreen PROC USES eax edi ecx
  mov eax, 0
  mov edi, ScreenBitsPtr
  mov ecx, 4b000h
  REP STOSB

  ret
ClearScreen ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;							 ;;
;; 		  KeyHandler         ;;
;;							 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

KeyHandler PROC USES eax
    mov eax, KeyDown
    cmp eax, VK_SPACE 				;; a spacebar
    je spaceBar
    cmp eax, VK_P				;; the P key
    je pKey
 
    cmp eax, VK_UP				;; an up arrow
    je upArrow
    cmp eax, VK_DOWN
    je downArrow
    cmp eax, VK_W
    je wKey
    cmp eax, VK_S
    je sKey
    jmp done

spaceBar:
	mov status, 1			;; play mode
    jmp done
pKey:
	mov status, 2			;; paused game
	jmp done

upArrow:					;; update p1 lastPressed
	mov p1.lastPressed, VK_UP
	jmp done
downArrow:					;; update p2 lastPressed		
	mov p1.lastPressed, VK_DOWN
	jmp done
wKey:
	mov p2.lastPressed, VK_W
	jmp done
sKey:
	mov p2.lastPressed, VK_S
	jmp done

done:
      ret
KeyHandler ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;							 ;;
;; 		CheckIntersect       ;;
;;							 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

END
