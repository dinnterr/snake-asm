
MainMenu			proto


.data
szCls		db "cls",0		;for clear screen

.code
MainMenu proc uses ebx esi edi
	LOCAL hOut:DWORD  		;descriptor console out
	LOCAL choice:DWORD 		;user's choice
	LOCAL cStart:DWORD		;color of Start 
	LOCAL cExit:DWORD		;color of Exit
	
	fn crt_system,offset szCls		;clearing console
	mov hOut,rv(GetStdHandle,-11)	;get descriptor console out using macros 'return value'
	mov dword ptr[choice],1			;set initial choice on 'Start'
	mov cStart,cWhite 				;set 'Start' in white
	mov cExit,cBrown				;set 'Exit' in brown
	mov byte ptr[bKey],30h			;set that input equal to zero
	mov byte ptr[closeConsole],0	;set that console is not closed
	
	.while closeConsole == 0 && gameOver == 0  	;when we choose Start gameOver will be 1, when we choose Exit closeConsole will be 1
		.while byte ptr[bKey] != KEY_ENTER 		;while user don't press Enter
			fn SetConsoleTextAttribute ,hOut,cStart 	;set Start in white
			fn gotoxy,37,14								;set Start on center
			fn crt_printf,"START"						;show Start on console
			
			fn SetConsoleTextAttribute ,hOut,cExit		;set Exit in brown
			fn gotoxy,37,16	
			fn crt_printf,"EXIT"
			
			fn Keyboard_check_pressed
			.if al == 'w' && choice == 2   ;check which key is pressed (its value also saved in register AL, in the same time with bkey)
				dec dword ptr[choice]			;go to 'Start'
				mov dword ptr[cExit],cBrown		;change colors - Exit - brown
				mov dword ptr[cStart],cWhite	;Start - white
			.elseif al == 's' && choice == 1
				inc dword ptr[choice]		;go to 'Exit'
				mov dword ptr[cExit],cWhite		;change colors - Exit - white
				mov dword ptr[cStart],cBrown	;Start - brown	
			.endif
		.endw
		;when enter is pressed
		.if choice == 1 		;if user pressed Start
			mov gameOver,1			
		.elseif choice == 2		;if user pressed Exit
			mov closeConsole,1
		.endif				
		fn crt_system,offset szCls		;clearing console
		mov byte ptr[bKey],30h			;set that input equal to zero
	.endw	
	Ret
MainMenu endp