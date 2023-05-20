include \masm32\include\masm32rt.inc

Main				proto
SetWindowSize		proto :DWORD,:DWORD


.const
	MAX_WIDTH 		equ 82	;width of window
	MAX_HEIGHT		equ 37	;height of window
	



.data?




.data
srect				SMALL_RECT <0,0, 81, 36> ;small_rectangle 
											 ;size of window (x,y,width,height) x,y - left top corner