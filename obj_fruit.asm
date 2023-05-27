CreateFruit				proto
DrawFruit				proto
FRUIT struct
	x	dword ?
	y	dword ?
	sprite	db ?
	reserv	db ?
FRUIT ends

.const
TIME_BLINK		equ 10

.data?
fruit		FRUIT <>
blink		dd ?

.code
CreateFruit proc uses ebx esi edi
	LOCAL x:DWORD
	LOCAL y:DWORD
	
@@Do:	
	fn RangedRand,1,80		;get random x
	mov dword ptr[x],eax	;save it in local x
	
	fn RangedRand,1,30		;get random y
	mov dword ptr[y],eax	;save it in local y
	fn CheckPosition,x,y
	cmp al,20h				;compare if it a space
	je @F					;break
	jmp @@Do 				;else continue
	@@:
		mov eax,dword ptr[x]
		mov dword ptr[fruit.x],eax
		mov eax,dword ptr[y]
		mov dword ptr[fruit.y],eax
		mov byte ptr[fruit.sprite],1
		mov blink,0
		Ret
CreateFruit endp
DrawFruit proc uses ebx esi edi
	inc blink
	.if blink >= TIME_BLINK
		.if byte ptr[fruit.sprite] == 1
			mov byte ptr[fruit.sprite],4
		.else
			mov byte ptr[fruit.sprite],1
		.endif
		mov blink,0
	.endif
	fn gotoxy,fruit.x,fruit.y
	fn SetColor,LightRed
	movzx eax,fruit.sprite	
	fn crt_putchar,eax	;square	
	Ret
DrawFruit endp