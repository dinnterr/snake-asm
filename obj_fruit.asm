CreateFruit		proto
DrawFruit		proto
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
	mov dword ptr[fruit.x],20
	mov dword ptr[fruit.y],20
	mov byte ptr[fruit.sprite],1
	mov blink,0

	Ret
CreateFruit endp
DrawFruit proc uses ebx esi edi
	inc blink
	.if blink >= TIME_BLINK
		.if byte ptr[fruit.sprite] == 1
			mov byte ptr[fruit.sprite],2
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