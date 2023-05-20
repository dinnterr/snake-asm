
Keyboard_check_pressed		proto



.const
;keys
KEY_ENTER		equ 13



.data
bKey			db 30h 	;for set key by symbol '0'
gameOver		db 0	;when 0 - game over
closeConsole 	db 0	;when 1 - close console


.code
Keyboard_check_pressed proc uses ebx esi edi
	fn FlushConsoleInputBuffer,rv(GetStdHandle,-10)  ;clear input buffer
@@: ;input wait loop
	fn Sleep,1 			;delay in 1 ms
	fn crt__kbhit		;check key pressed
	or eax,eax			;if eax=0 => key not pressed
	je @B				;go back @@
	fn crt__getch		;else get pressed key from buffer
	mov byte ptr[bKey],al  ;save pressed key in bKeys
	Ret
Keyboard_check_pressed endp