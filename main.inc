include \masm32\include\masm32rt.inc

includelib \masm32\lib\winmm.lib
include RangedRand.asm

Main				proto
SetWindowSize		proto :DWORD,:DWORD
HideCursor			proto
gotoxy				proto :DWORD,:DWORD
SetColor 			proto :DWORD
CheckPosition		proto :DWORD,:DWORD

;list of colors
	cBlack 				= 0
	cBlue				= 1
	cGreen				= 2
	cCyan				= 3
	cRed				= 4
	cMagenta			= 5
	cBrown				= 6
	LightGray 			= 7
	DarkGray			= 8
	LightBlue 			= 9
	LightGreen			= 10
	LightCyan 			= 11
	LightRed			= 12
	LightMagenta 		= 13
	cYellow				= 14
	cWhite 				= 15
	cPanel				= 48

.const
	MAX_WIDTH 		equ 82	;width of window
	MAX_HEIGHT		equ 37	;height of window
	



.data?




.data
srect				SMALL_RECT <0,0, 81, 36> ;small_rectangle 
											 ;size of window (x,y,width,height) x,y - left top corner
szCls		db "cls",0		;for clear screen		 