CreateSnake		proto
DrawSnake		proto :DWORD,:DWORD
DrawTail		proto
ClearTail		proto
SNAKE struct
	x		dword ?
	y		dword ?
	direction  	db ?
			   	db ? ;for making even number of bytes
	speed	dword ?
SNAKE ends
TAIL struct
	x		dword ?
	y		dword ?
TAIL ends

.const
	MAX_SPEED		equ 10	;smaller number - faster speed
	MAX_TAIL		equ	500
	SPD_STEP		equ 5
	
.data?
	snake		SNAKE <>
	tail		TAIL MAX_TAIL dup(<>)
	spd_count	dd ?
	nTail		dd ?	;"length" of tail
	nPickup		dd ?    ;number of eaten fruits

.code
CreateSnake	proc uses ebx esi edi
	mov dword ptr[snake.x], 40
	mov dword ptr[snake.y], 17
	mov byte ptr[snake.direction],31h 	;no direction == 0 ====================================================================
	mov dword ptr[snake.speed],MAX_SPEED
	mov dword ptr[spd_count],0
	
	mov dword ptr[score],0
	mov dword ptr[score_old],0
	fn ClearTail
	mov dword ptr[nTail],0
	mov dword ptr[nPickup],0
	Ret
CreateSnake endp
DrawSnake proc uses ebx esi edi x:DWORD,y:DWORD
	fn gotoxy,x,y
	fn SetColor,LightGreen
	fn crt_putchar,'O'	
	Ret
DrawSnake endp
DrawTail proc uses ebx esi edi
	fn SetColor,LightGreen
	lea esi,tail
	xor ebx,ebx					;i=0
	jmp @@For
@@In:
	mov eax,dword ptr[esi]		;get x
	mov edx,dword ptr[esi+4]	;get y
	.if eax == 0 || edx == 0	;so that there is no tail during initialization
		jmp @@Ret
	.endif
	fn gotoxy,eax,edx
	fn crt_putchar,'o'	
	inc ebx						;i++
	add esi,sizeof TAIL
@@For:
	cmp ebx,nTail				;i<N
	jb @@In
@@Ret:					
	Ret
DrawTail endp
ClearTail proc uses ebx esi edi
		lea esi,tail		;get adress of massive tail
		xor ebx,ebx			; "i" = 0
		jmp @@For
	@@In:
		mov dword ptr[esi],0
		mov dword ptr[esi+4],0		;to field y +4 bytes
		add esi,sizeof TAIL
		inc ebx				;i++
	@@For:
		cmp ebx,nTail		;i<N
		jb @@In
	Ret
ClearTail endp