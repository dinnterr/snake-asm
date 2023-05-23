
DrawSnake		proto :DWORD,:DWORD
SNAKE struct
	x		dword ?
	y		dword ?
	direction  	db ?
			   	db ? ;for making even number of bytes
	speed	dword ?
	
SNAKE ends

.const
	MAX_SPEED		equ 10 	;smaller number - faster speed
	
	
.data?
	snake		SNAKE <>
	spd_count	dd ?

.code
DrawSnake proc uses ebx esi edi x:DWORD,y:DWORD
	fn gotoxy,x,y
	fn SetConsoleTextAttribute,rv(GetStdHandle,-11),LightGreen
	fn crt_putchar,'O'	
	Ret
DrawSnake endp