INCLUDE Irvine32.inc

mov2 MACRO N1, N2, reg
	push reg
	mov reg, N2
	mov N1, reg
	pop reg
ENDM

cmp2 MACRO N1, N2, reg
	push reg
	mov reg, N2
	cmp N1, reg
	pop reg
ENDM

imul2 MACRO N1, N2, reg
	push reg
	mov reg, N1
	imul reg, N2
	mov N1, reg
	pop reg
ENDM

.data
MSG1 BYTE "Enter a string : ",0
MSG2 BYTE "Bye!",0
BufferN = 25    
Buffer BYTE 26 DUP (0)  
StrSize DWORD 0 ; Strsize = N
Output BYTE 26 DUP (0)
j DWORD 0
k DWORD 0
even_flag DWORD 0

.code
main PROC


	DWh1s:		
				; Dwh1 만족시 실행 코드
	mov edx, OFFSET MSG1
	call WriteString

	mov  edx, OFFSET Buffer
    mov  ecx, BufferN         
    call ReadString
	mov StrSize, eax

	cmp WORD PTR [edx], 0a00h           ; <ent>만 입력시 프로그램 종료 (0a00h)
    je PEND

	mov even_flag, 0
	mov eax, StrSize
	and eax, 1

	cmp eax, 1	; if0 ( StrSize%2 == 1 )
	je if0o
	jmp if0e

		if0o: ; if0 만족
		mov even_flag, 1
		jmp if0e

	if0e:


	mov j, 1      
	Fr1s:           ; for1 ( j = 1; j <= N; j++ )
		cmp2 j, StrSize, eax  
		jle Fr1c
		jmp Fr1e
		Fr1c:       ; For1 조건 만족시 실행

		cmp even_flag, 0	; if2-1 ( even_flag == 0 )
		je if2o1
		jmp if2e

			if2o1: 
			mov eax, StrSize
			shr eax, 1
			cmp j, eax	; if2-2 ( j == N/2 )
			je if2o2
			jmp if2e

				if2o2:	; if2 만족 ( eax >= 0 && eax <= 0 )
				jmp SkipPrint
				jmp if2e

		if2e:



		mov esi, 0
		mov edi, 0
		mov ecx, 6
		L1:
			mov2 DWORD PTR Output[edi], DWORD PTR Buffer[esi], eax
			add edi, 4
			add esi, 4
		loop L1

		push j

		mov ebx, StrSize
		inc ebx
		shr ebx, 1
		cmp j, ebx	; if1 ( j > (N+1)/2 )
		jg if1o
		jmp if1e

			if1o: ; if1 만족
			mov ebx, StrSize		; j = N+1-j
			inc ebx
			sub ebx, j
			mov j, ebx
			jmp if1e

		if1e:

		mov k, 0      
		fr2s:           ; for2 ( k = 0; k < j-1; k++ )
			mov ebx, j
			dec ebx
			cmp k, ebx  
			jl fr2c
			jmp fr2e
			fr2c:       ; for2 조건 만족시 실행

			mov esi, k
			mov edi, StrSize
			sub edi, k
			dec edi

			mov Output[esi], ' '
			mov Output[edi], ' '

			inc k     
			jmp fr2s
		fr2e:    

		pop j

		mov edx, OFFSET OutPut
		call WriteString
		CALL CRLF

	SkipPrint:
		inc j     
		jmp Fr1s
	Fr1e:    
	CALL CRLF
	jmp DWh1s   

PEND:
	mov edx, OFFSET MSG2
	call WriteString

	exit
main ENDP

END main
