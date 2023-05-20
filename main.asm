include main.inc


.code


start:
	fn SetConsoleTitle,"Snake"	;Title of project
	fn SetWindowSize,MAX_WIDTH,MAX_HEIGHT
	
	
	fn Main						
	inkey
	exit
Main proc




	Ret
Main endp

SetWindowSize proc uses ebx esi edi wd:DWORD,ht:DWORD
	fn GetStdHandle,-11			;to get handle of output descriptor 
	push eax					;push the handle in the stack
	mov ebx,ht
	shl ebx,16					;shift the value to the left so that the height value is in highest word
	or ebx,wd								;bit by bit add the width
	fn SetConsoleScreenBufferSize,eax,ebx	;set buffer size
	pop eax									;get handle of output descriptor from stack
	fn SetConsoleWindowInfo,eax,1,offset srect	;set window size
	Ret
SetWindowSize endp

end start






