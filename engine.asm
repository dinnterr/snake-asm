
Keyboard_check_pressed		proto
GameInit					proto
GameUpdate					proto
DrawLevel					proto :DWORD
Keyboard_check				proto 
CheckPosition				proto :DWORD,:DWORD

GameController				proto

KeyEvent					proto
DrawEvent					proto
DrawScore					proto
DrawPanel					proto
StepEvent					proto


.const
;keys
KEY_ENTER		equ 13
KEY_ESC			equ 27
MAX_STEP		equ 30

STOP			equ 30h

.data
bKey			db 30h 	;for set key by symbol '0'
gameOver		db 0	;when 0 - game over
closeConsole 	db 0	;when 1 - close console
nLevel			db 1 	;nLevel - number of level saving the 1st level on start
score			dd 0
score_old		dd 0
szLevel_1		db "level_1.txt", 0

.code
Keyboard_check_pressed proc uses ebx esi edi	;for Main Menu
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
GameInit proc uses ebx edi esi
	movzx eax, byte ptr[nLevel] 	;save nLevel into AL (after clear eax)
	fn DrawLevel, eax				;draw map of level
	or eax,eax 						; if eax == 0 -> read file error 
	je @@Error
	fn DrawPanel					;draw info panel
	fn SetColor,LightGreen
	fn gotoxy,1,32
	fn crt_printf,"Score: "
	print ustr$(score)
	
	fn CreateSnake
	fn DrawSnake,snake.x,snake.y
	
	fn CreateFruit
	
	
@@Ret:
	Ret		
@@Error:
	mov byte ptr[gameOver],0		;for end game
	fn gotoxy,32,14
	fn SetColor,cBrown
	fn crt_puts,"Load File failed" 	;print text error
	fn Sleep, 2000					;make pause on 2sec
	jmp @@Ret
GameInit endp
DrawLevel proc uses ebx edi esi nLvl:DWORD
	LOCAL hFile:DWORD 			;for save descriptor of file
	LOCAL buffer[256]:BYTE		;make local buffer for data of file
	.if nLvl == 1
		fn crt_fopen,offset	szLevel_1,"r"	;open file for read using c runtime library function (filename, mode)
		or eax,eax					;if eax == 0 -> error
		je @@Ret					;exit
		mov dword ptr[hFile], eax	;else - move descriptor of file into hFile
		push eax					;push descriptor into stack
		fn SetColor,LightCyan	;make map another color
		lea ebx,buffer				;ebx = address of buffer
	@@While:
		fn crt_fgets,ebx,256,hFile	;get file strings (buffer, buffer size, descriptor)	 
		or eax,eax					;if there is end of file (eax == 0)
		je @@CloseFile
		fn crt_printf,eax			;print gotten string on console
		jmp @@While
	@@CloseFile:	
		pop eax						;pop descriptor
		fn crt_fclose,eax 			;close file using crt function
		inc eax						;for correct processing error, eax = 1
	.endif
@@Ret:
	Ret
DrawLevel endp
GameController proc uses ebx esi edi
	fn KeyEvent
	fn DrawEvent	;when user pressed key - redraw changed position and update score
	fn StepEvent	;game time step - so that redraws arent from each processor cycle, but are controlled





	Ret
GameController endp
GameUpdate proc uses ebx esi edi
	LOCAL x:DWORD
	LOCAL y:DWORD
	LOCAL xprev:DWORD
	LOCAL yprev:DWORD
	LOCAL xtemp:DWORD
	LOCAL ytemp:DWORD
	
	inc spd_count
	mov eax,spd_count
	.if eax >= snake.speed
		
		mov eax,snake.x
		mov dword ptr[x],eax
		
		mov eax,snake.y
		mov dword ptr[y],eax
		
		.if nTail > 0
			lea esi, tail
			mov eax,dword ptr[esi]		;get coordinates of first member of the tail
			mov dword ptr[xprev],eax		;save them for next members
			mov eax,dword ptr[esi+4]
			mov dword ptr[yprev],eax
			
			mov eax,dword ptr[x]		;get coordinates of the head to move tail on it place
			mov dword ptr[esi],eax
			mov eax,dword ptr[y]		
			mov dword ptr[esi+4],eax
			
			fn gotoxy,xprev,yprev		;clean member of the tail from where he left
			fn crt_putchar,20h			;put a space
			
			xor ebx,ebx					;i=0
			inc ebx 					;i=1
			add esi,sizeof TAIL
			jmp @@For
		@@In:
			mov eax,dword ptr[esi]			;foreach member get old coordinates 
			mov dword ptr[xtemp],eax		;save them for giving next ones
			mov eax,dword ptr[esi+4]
			mov dword ptr[ytemp],eax
			
			fn gotoxy,xtemp,ytemp		;clean member of the tail from where he left
			fn crt_putchar,20h			;put a space
			
			mov eax,dword ptr[xprev]	;get new coordinates foreach member
			mov dword ptr[esi],eax
			mov eax,dword ptr[yprev]
			mov dword ptr[esi+4],eax
			
			mov eax,dword ptr[xtemp]	;save this coordinates like old for next members
			mov dword ptr[xprev],eax
			mov eax,dword ptr[ytemp]
			mov dword ptr[yprev],eax
			
			add esi,sizeof TAIL			;adress massive get bigger
			inc ebx						;i++
		@@For:	
			cmp ebx,nTail
			jb @@In						;i<N
		.endif
		
		;=============delete old snake===============
		fn gotoxy,snake.x,snake.y	;erase old snake
		fn crt_putchar,20h			;erase = put a space
		;========================================
		.if snake.direction == 'w'
			mov eax,dword ptr[y]
			dec eax
			fn CheckPosition,x,eax		;after that in eax we have the character from screen where is cursor will be after key pressed
			.if al == 20h || al == fruit.sprite		;if it is a space
				dec dword ptr[snake.y]	;change coordinates
			.elseif al == '#'
				mov byte ptr[snake.direction],STOP 		;then stop
			.endif
		.elseif snake.direction == 's'
			mov eax,dword ptr[y]
			inc eax
			fn CheckPosition,x,eax		;after that in eax we have the character from screen where is cursor will be after key pressed
			.if al == 20h|| al == fruit.sprite			;if it is a space
				inc dword ptr[snake.y]	;change coordinates
			.elseif al == '#'
				mov byte ptr[snake.direction],STOP 		;then stop
			.endif
		.elseif snake.direction == 'a'
			mov eax,dword ptr[x]
			dec eax
			fn CheckPosition,eax,y		;after that in eax we have the character from screen where is cursor will be after key pressed
			.if al == 20h || al == fruit.sprite			;if it is a space
				dec dword ptr[snake.x]	;change coordinates
			.elseif al == '#'
				mov byte ptr[snake.direction],STOP 		;then stop
			.endif
		.elseif snake.direction == 'd'
			mov eax,dword ptr[x]
			inc eax
			fn CheckPosition,eax,y		;after that in eax we have the character from screen where is cursor will be after key pressed
			.if al == 20h || al == fruit.sprite			;if it is a space
				inc dword ptr[snake.x]	;change coordinates
			.elseif al == '#'
				mov byte ptr[snake.direction],STOP 		;then stop
			.endif
			
		.endif
		
		mov spd_count,0
	.endif
	
	;===Catch fruit
	mov eax,snake.x
	mov ebx,snake.y
	
	.if eax == fruit.x && ebx == fruit.y
		.if nTail < MAX_TAIL
			inc nTail
			
			add score,10
			
		.endif
	
	.endif
	
	Ret
GameUpdate endp
StepEvent proc uses ebx esi edi
	.if snake.direction == STOP			;if snake met wall
	@@GameOver:
		mov byte ptr[gameOver],0		;game over
		;========gameover menu later
		jmp @@Ret
	.endif
	;=====Catching tail
	.if nTail > 0
		lea esi,tail	
		xor ebx,ebx
		jmp @@For2
	@@In2:
		mov eax,dword ptr[esi]
		mov edx,dword ptr[esi+4]
		.if eax == snake.x && edx == snake.y
			jmp @@GameOver
		.endif
		
		inc ebx
		add esi,sizeof TAIL
	@@For2:
		cmp ebx,nTail
		jb @@In2
	.endif

	
@@Ret:
	fn Sleep,MAX_STEP
	Ret
StepEvent endp
KeyEvent proc uses ebx esi edi
	fn Keyboard_check
	.if	byte ptr[bKey] == KEY_ESC
		mov byte ptr[gameOver],0		;make game over 0 so that mean that we exit the game
		mov byte ptr[closeConsole],1	;and close console
	.elseif byte ptr[bKey] == 'p'		;pause
	
	.elseif byte ptr[bKey] == 'w' || byte ptr[bKey] == 's' || byte ptr[bKey] == 'a' || byte ptr[bKey] == 'd'
		mov byte ptr[snake.direction],al		
	.endif
	Ret
KeyEvent endp
Keyboard_check proc uses ebx esi edi
	mov byte ptr[bKey],31h			;clear buffer of pressed key
	fn crt__kbhit					;check key pressed
	or eax,eax						;if eax=0 => key not pressed
	je @@Ret
	fn crt__getch					;else get pressed key from buffer
	mov byte ptr[bKey],al  			;save pressed key in bKeys
@@Ret:
	Ret
Keyboard_check endp
DrawEvent proc uses ebx esi edi
	.if nTail > 0
		fn DrawTail
	.endif
	fn DrawSnake,snake.x,snake.y
	fn DrawFruit
	fn DrawScore					;show update score
	
	Ret
DrawEvent endp
DrawScore proc uses ebx esi edi
	mov ebx,score
	.if ebx > score_old
		fn gotoxy,8,32
		print ustr$(ebx)				;macros ustr(unsigned) - converts a numeric value to an unsigned string representation and return a pointer and next print 
	
		mov dword ptr[score_old],ebx	;save new value of score
	.endif
	
	
	
	Ret
DrawScore endp

DrawPanel proc uses ebx esi edi
	fn SetColor,cPanel
	fn gotoxy,21,32
	fn crt_printf,"Esc - back to menu, P - pause the game"
	
	Ret
DrawPanel endp
CheckPosition proc uses ebx esi edi	x:DWORD,y:DWORD
	LOCAL cRead:DWORD
	LOCAL buffer:DWORD
	;LOCAL cbi:CONSOLE_SCREEN_BUFFER_INFO	;console buffer info
	
	mov dword ptr[buffer],0
	fn gotoxy,x,y
	
	mov ebx,y
	shl ebx,16	;move y in senior rank by shift left
	or ebx,x
	lea edi,cRead								;get adress of cRead
	lea esi,buffer								;and buffer
	
	fn GetStdHandle,-11		;get descriptor
	fn ReadConsoleOutputCharacter,eax,esi,1,ebx,edi ;(descriptor, addr of buffer, numbers of read characters,coordinates of cursor,addr of variable)
	;=====After that in the first byte of buffer we got read character from screen where our cursor is
	mov eax,dword ptr[buffer]	;get it in eax
	Ret
CheckPosition endp