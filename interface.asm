MainMenu			proto
AboutMenu			proto

.data
szAbout 	db "about.txt",0

.code
MainMenu proc uses ebx esi edi
	LOCAL hOut:DWORD  		;descriptor console out
	LOCAL choice:DWORD 		;user's choice
	LOCAL cStart:DWORD		 
	LOCAL cExit:DWORD		
	LOCAL cAbout:DWORD
	
	fn crt_system,offset szCls		;clearing console
	mov hOut,rv(GetStdHandle,-11)	;get descriptor console out using macros 'return value'
	mov dword ptr[choice],1			;set initial choice on 'Start'
	mov cStart,cWhite 				;set 'Start' in white
	mov cExit,cBrown				;set 'Exit' in brown
	mov cAbout,cBrown
	mov byte ptr[bKey],31h			;set that input equal to zero
	mov byte ptr[closeConsole],0	;set that console is not closed
	
	.while closeConsole == 0 && gameOver == 0  	;when we choose Start gameOver will be 1, when we choose Exit closeConsole will be 1
		.while byte ptr[bKey] != KEY_ENTER 		;while user don't press Enter
			fn SetConsoleTextAttribute ,hOut,cStart 	;set Start in white
			fn gotoxy,37,13								;set Start on center
			fn crt_printf,"START"						;show Start on console
			
			fn SetConsoleTextAttribute ,hOut,cExit		;set Exit in brown
			fn gotoxy,37,15	
			fn crt_printf,"EXIT"
			
			fn SetConsoleTextAttribute ,hOut,cAbout		
			fn gotoxy,37,17	
			fn crt_printf,"ABOUT"
			
			fn Keyboard_check_pressed
			.if al == 'w' && choice == 2   ;if we on EXIT ;check which key is pressed (its value also saved in register AL, in the same time with bkey)
				dec dword ptr[choice]			;go to 'Start'
				mov dword ptr[cExit],cBrown		;change colors - Exit - brown
				mov dword ptr[cStart],cWhite	;Start - white
				mov dword ptr[cAbout],cBrown
				
			.elseif	al == 'w' && choice == 3
				dec dword ptr[choice]			;go to 'Exit'
				mov dword ptr[cExit],cWhite	
				mov dword ptr[cStart],cBrown	
				mov dword ptr[cAbout],cBrown
			.elseif al == 's' && choice == 1
				inc dword ptr[choice]		;go to 'Exit'
				mov dword ptr[cExit],cWhite		;change colors - Exit - white
				mov dword ptr[cStart],cBrown	;Start - brown	
				mov dword ptr[cAbout],cBrown
			.elseif al == 's' && choice == 2
				inc dword ptr[choice]		;go to 'About'
				mov dword ptr[cExit],cBrown		
				mov dword ptr[cStart],cBrown		
				mov dword ptr[cAbout],cWhite		
			.endif
		.endw
		;when enter is pressed
		.if choice == 1 		;if user pressed Start
			mov gameOver,1			
		.elseif choice == 2		;if user pressed Exit
			mov closeConsole,1
		.elseif choice == 3		;if user pressed About
			fn AboutMenu
		.endif				
		fn crt_system,offset szCls		;clearing console
		mov byte ptr[bKey],30h			;set that input equal to zero
	.endw	
	Ret
MainMenu endp
AboutMenu proc uses ebx esi edi
	LOCAL hFile:DWORD 			;for save descriptor of file
	LOCAL buffer[256]:BYTE		;make local buffer for data of file
	
	fn crt_system,offset szCls		;clearing console
	
	fn crt_fopen,offset	szAbout,"r"	;open file for read using c runtime library function (filename, mode)
	or eax,eax					;if eax == 0 -> error
	je @@Ret					;exit
	mov dword ptr[hFile], eax	;else - move descriptor of file into hFile
	push eax					;push descriptor into stack
	fn SetColor,cWhite	;make map another color
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
	fn Keyboard_check_pressed
	
@@Ret:	
	Ret
AboutMenu endp
