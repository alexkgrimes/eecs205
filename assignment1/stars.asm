; #########################################################################
;
;   stars.asm - Assembly file for EECS205 Assignment 1
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive


include stars.inc

.DATA

	;; If you need to, you can place global variables here

.CODE

DrawStarField proc

	;; Place your code here
	invoke DrawStar, 445, 193 
	invoke DrawStar, 269, 205
	invoke DrawStar, 570, 280
	invoke DrawStar, 562, 210
	invoke DrawStar, 407, 274
	invoke DrawStar, 547, 120
	invoke DrawStar, 379, 26
	invoke DrawStar, 265, 248

	invoke DrawStar, 551, 255
	invoke DrawStar, 463, 446
	invoke DrawStar, 16, 11
	invoke DrawStar, 6, 278
	invoke DrawStar, 193, 457
	invoke DrawStar, 365, 160
	invoke DrawStar, 213, 117
	invoke DrawStar, 299, 279

	invoke DrawStar, 424, 449
	invoke DrawStar, 378, 411
	invoke DrawStar, 40, 267
	invoke DrawStar, 401, 341
	invoke DrawStar, 475, 239
	invoke DrawStar, 631, 202
	invoke DrawStar, 259, 183
	invoke DrawStar, 45, 105

	invoke DrawStar, 293, 359
	invoke DrawStar, 169, 202
	invoke DrawStar, 82, 92
	invoke DrawStar, 481, 170
	invoke DrawStar, 76, 115
	invoke DrawStar, 406, 18
	invoke DrawStar, 600, 309
	invoke DrawStar, 336, 206

	ret  			; Careful! Don't remove this line
DrawStarField endp



END
