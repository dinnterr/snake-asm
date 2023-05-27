RangedRand		proto :DWORD,:DWORD

.data
rand_max	dq 32768.0 ;(RAND_MAX+1)

.code
RangedRand proc uses ebx esi edi _min:DWORD,_max:DWORD 
	;generate random number from interval 
	;=gen_rand_number/(RAND_MAX+1)(max_num-min_num)+min_num
	LOCAL res:DWORD
	
	fn crt_rand					
	mov dword ptr[res],eax		;set random number into res
								;using floating point unit (FPU)
	fild dword ptr[res]			;loading an integer random number in st0
	fld qword ptr[rand_max]		;loading a float rand_max in st0, prev st0 -> st1
	fdivp st(1),st				;div random number/rand_max -> result in st0
	mov eax,_max
	sub eax,_min				;sub interval using normal registers
	mov dword ptr[res],eax		
	fild dword ptr[res]			;loading sub in st0
	fmulp st(1),st				;mul st0*st1, result in st0
	fild dword ptr[_min]		;loading min in st0
	faddp st(1),st           	;add min to final result, final random number in st0   
	fistp dword ptr[res]		;store result as integer
	mov eax,dword ptr[res]		;save in eax

	Ret
RangedRand endp									