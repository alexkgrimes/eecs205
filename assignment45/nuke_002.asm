; #########################################################################
;
;  nuke_001.asm - Assembly file for EECS205 Assignment 4/5
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

.DATA


nuke_002 EECS205BITMAP <22, 21, 255,, offset nuke_002 + sizeof nuke_002>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,01ch,01ch,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch
	BYTE 01ch,01ch,01ch,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,01ch,01ch,01ch,01ch,01ch,01ch,01ch,01ch,01ch,01ch,01ch,01ch,01ch,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 01ch,01ch,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,01ch,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch
	BYTE 01ch,01ch,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh
	BYTE 0ffh,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh,01ch,01ch,01ch
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch
	BYTE 01ch,01ch,0ffh,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh,0ffh
	BYTE 01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 01ch,01ch,01ch,0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,01ch,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 01ch,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,01ch,01ch,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,01ch,01ch,01ch,01ch,01ch,01ch,01ch,01ch,01ch,01ch,01ch,01ch,01ch,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01ch,01ch,01ch,01ch,01ch,01ch,01ch
	BYTE 01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,01ch,01ch,01ch,01ch,01ch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

END