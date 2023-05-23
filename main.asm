include main.inc
include obj_snake.asm
include engine.asm
include interface.asm

.code


start:
	fn SetConsoleTitle,"Snake"	;Title of project
	fn SetWindowSize,MAX_WIDTH,MAX_HEIGHT
	fn HideCursor
	fn Main						
	
	fn SetConsoleTextAttribute,rv(GetStdHandle,-11),LightGreen ;set color of 'press any key to continue...'
	inkey
	exit
Main proc
	fn MainMenu 					;show and process menu
	.while closeConsole == 0   		;while user in menu
		fn GameInit
		.while gameOver == 1        ;while game is runnig
			
			
			fn GameUpdate
			fn GameController
				
			
		.endw
		;when game is over show menu
		fn MainMenu 
	.endw
	fn gotoxy,25,35 	;set Cursor on x,y for showing 'press any key to continue...' on the center bottom

	Ret
Main endp

SetWindowSize proc uses ebx esi edi wd:DWORD,ht:DWORD
	fn GetStdHandle,-11						;to get handle of output descriptor 
	push eax								;push the handle in the stack
	mov ebx,ht
	shl ebx,16								;shift the value to the left so that the height value is in highest word
	or ebx,wd								;bit by bit add the width
	fn SetConsoleScreenBufferSize,eax,ebx	;set buffer size
	pop eax									;get handle of output descriptor from stack
	fn SetConsoleWindowInfo,eax,1,offset srect	;set window size
	Ret
SetWindowSize endp

HideCursor proc uses ebx esi edi
	LOCAL ci:CONSOLE_CURSOR_INFO 	
	fn GetStdHandle,-11						;to get handle of output descriptor 
	push eax								;push the handle in the stack
	lea ebx, ci
	fn GetConsoleCursorInfo,eax,ebx
	mov ci.bVisible,0						;set field of visibility cursor into 0
	pop eax									;get handle of output descriptor from stack
	fn SetConsoleCursorInfo,eax,ebx
	Ret
HideCursor endp
gotoxy proc uses ebx esi edi x:DWORD,y:DWORD ;to set cursor coordinates
	mov ebx,y
	shl ebx,16
	or ebx,x
	fn SetConsoleCursorPosition,rv(GetStdHandle,-11),ebx	
	Ret
gotoxy endp


end start






