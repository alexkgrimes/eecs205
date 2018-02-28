; #########################################################################
;
;  fighter_001.asm - Assembly file for EECS205 Assignment 4/5
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

;; If you need to, you can place global variables here

fighter_001 EECS205BITMAP <41, 45, 255,, offset fighter_001 + sizeof fighter_001>
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,049h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,049h,0b6h,049h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,0ffh,0e0h,0e0h
	BYTE 080h,080h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,0e0h,080h,080h,080h,080h,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,049h
	BYTE 013h,049h,00ah,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,049h,013h,0ffh,00ah,024h,049h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h
	BYTE 091h,013h,013h,0ffh,00ah,00ah,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,013h,013h,013h,00ah,00ah,049h
	BYTE 024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,049h,0b6h,013h,013h,013h,00ah,00ah,091h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,091h,0b6h,049h,013h,013h,00ah
	BYTE 024h,091h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,049h,091h,091h,0b6h,049h,0ffh,024h,091h,049h,049h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,049h,091h,091h,0b6h
	BYTE 091h,091h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,049h,049h,091h,091h,091h,049h,049h,049h,049h,024h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,080h,0ffh,0ffh,0ffh,049h,091h,049h
	BYTE 049h,091h,049h,049h,024h,024h,049h,024h,0ffh,0ffh,0ffh,080h,080h,080h,080h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0ffh
	BYTE 0e0h,0e0h,080h,080h,0ffh,049h,091h,091h,0b6h,091h,049h,049h,024h,049h,049h,049h
	BYTE 049h,024h,0ffh,0e0h,080h,080h,080h,080h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,049h,049h,049h,024h,080h,0ffh,049h,091h
	BYTE 0b6h,0b6h,091h,091h,049h,049h,049h,049h,049h,049h,024h,0ffh,0e0h,024h,024h,024h
	BYTE 024h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0b6h,091h,091h,091h,049h,024h,049h,091h,091h,0b6h,091h,091h,091h,049h,049h,049h
	BYTE 049h,049h,049h,049h,024h,091h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h,091h,049h,024h,0ffh
	BYTE 049h,0b6h,091h,091h,091h,091h,049h,049h,049h,049h,049h,049h,024h,0e0h,091h,049h
	BYTE 049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0b6h,091h,091h,091h,049h,024h,0e0h,0ffh,049h,049h,091h,091h,091h,049h
	BYTE 049h,049h,049h,024h,024h,0e0h,080h,091h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h,091h,049h
	BYTE 024h,0e0h,0e0h,049h,091h,049h,049h,049h,049h,024h,024h,024h,049h,024h,080h,080h
	BYTE 091h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,091h,049h,049h,049h,049h,024h,024h,0e0h,0e0h,0b6h,049h,0b6h,0b6h
	BYTE 091h,080h,049h,049h,049h,024h,049h,080h,080h,049h,024h,024h,024h,024h,024h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,091h,091h
	BYTE 091h,091h,049h,024h,0e0h,0b6h,049h,091h,0b6h,091h,080h,049h,049h,024h,024h,049h
	BYTE 080h,091h,049h,049h,049h,049h,049h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,049h,0b6h,091h,091h,091h,091h,091h,049h,024h,0e0h,0b6h,049h
	BYTE 0b6h,091h,049h,080h,024h,024h,049h,024h,049h,080h,091h,049h,049h,049h,049h,049h
	BYTE 024h,024h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,049h,0b6h,091h
	BYTE 091h,000h,091h,091h,049h,024h,0e0h,0b6h,091h,049h,0b6h,091h,080h,049h,049h,024h
	BYTE 049h,049h,080h,091h,049h,049h,000h,049h,049h,024h,024h,024h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,091h,091h,049h,0b6h,091h,000h,0fch,000h,091h,049h,024h,0e0h
	BYTE 0b6h,091h,049h,091h,091h,080h,049h,024h,024h,049h,049h,080h,091h,049h,000h,090h
	BYTE 000h,049h,024h,024h,024h,049h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,091h,0b6h,091h,049h
	BYTE 0b6h,000h,0fch,000h,0fch,000h,049h,024h,0e0h,0b6h,091h,049h,0b6h,049h,080h,024h
	BYTE 049h,024h,049h,049h,080h,091h,000h,090h,000h,090h,000h,024h,024h,024h,049h,024h
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,049h,0e0h,0b6h,000h,000h,000h,000h,000h,049h
	BYTE 024h,080h,0b6h,091h,091h,049h,091h,080h,049h,024h,049h,049h,049h,080h,091h,000h
	BYTE 000h,000h,000h,000h,024h,024h,024h,049h,049h,024h,0ffh,0ffh,0ffh,091h,091h,0e0h
	BYTE 0e0h,080h,0b6h,091h,091h,091h,091h,091h,049h,024h,080h,0b6h,091h,0b6h,091h,049h
	BYTE 080h,024h,049h,049h,049h,049h,080h,091h,049h,049h,049h,049h,049h,024h,024h,080h
	BYTE 080h,080h,049h,024h,0ffh,0ffh,0ffh,0e0h,080h,080h,0ffh,0ffh,049h,049h,049h,049h
	BYTE 049h,024h,0e3h,0b6h,0b6h,091h,091h,0b6h,091h,024h,049h,049h,049h,049h,049h,024h
	BYTE 0e3h,024h,024h,024h,024h,024h,024h,0ffh,0ffh,080h,080h,080h,080h,0ffh,0ffh,0e0h
	BYTE 080h,0ffh,0ffh,0ffh,0e0h,0ffh,0e0h,0e0h,0e0h,0e0h,080h,080h,0ffh,0b6h,049h,049h
	BYTE 049h,0b6h,091h,024h,024h,024h,024h,024h,0ffh,0e0h,0e0h,080h,080h,080h,080h,080h
	BYTE 080h,0ffh,0ffh,0ffh,080h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h
	BYTE 0e0h,0e0h,0e0h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0e0h,080h,080h,080h,080h,080h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 00fh,00fh,00fh,00fh,00fh,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,024h,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,00fh,00fh,00fh,00fh,00fh,00fh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,017h,017h,017h,017h,00fh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0b6h,091h,024h,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h
	BYTE 017h,017h,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,00fh,017h,017h,0ffh,0ffh,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,024h
	BYTE 080h,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,0ffh,0ffh,017h,017h,00fh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,0ffh,0ffh,0ffh,0ffh
	BYTE 017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,080h,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h
	BYTE 017h,0ffh,0ffh,0ffh,0ffh,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,00fh,017h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,017h,00fh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,017h
	BYTE 00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,0ffh,0ffh
	BYTE 0ffh,0ffh,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 00fh,017h,017h,0ffh,0ffh,0ffh,0ffh,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,0ffh,0ffh,0ffh,0ffh,017h,00fh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,0ffh,0ffh,0ffh,0ffh
	BYTE 017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h
	BYTE 017h,0ffh,0ffh,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,00fh,017h,017h,0ffh,0ffh,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,017h,017h,00fh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h
	BYTE 017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,00fh,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,017h,017h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,00fh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,00fh,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh

END