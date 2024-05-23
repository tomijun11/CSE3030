INCLUDE Irvine32.inc

mov2 MACRO N1, N2, reg
	push reg
	mov reg, N2
	mov N1, reg
	pop reg
ENDM

sub2 MACRO N1, N2, reg
	push reg
	sub reg, N2
	sub N1, reg
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

Calc PROTO N1:DWORD, N2:DWORD

.data
MSG1 BYTE "Enter Capacity : ",0
MSG2 BYTE "Enter Weights : ",0
MSG3 BYTE "Enter Profits(the same # of weights) : ",0
MSG4 BYTE "Bye!",0
MSG5 BYTE "Max Profit = ",0
MSG6 BYTE " ",0
BUF_SIZE EQU 256                                     
inBufferW  BYTE BUF_SIZE DUP(?)                          ; 입력받은 문자열의 저장공간 (최대 255자)
inBufferWN DWORD ?                                       ; 입력받은 문자열의 길이 (Null 제외)
intArrayW  SDWORD BUF_SIZE/2 DUP(?)                      ; 추출된 정수값들의 저장공간
intArrayWN DWORD ?                                       ; 추출된 정수값들의 갯수
inBufferP  BYTE BUF_SIZE DUP(?)                          ; 입력받은 문자열의 저장공간 (최대 255자)
inBufferPN DWORD ?                                       ; 입력받은 문자열의 길이 (Null 제외)
intArrayP  SDWORD BUF_SIZE/2 DUP(?)                      ; 추출된 정수값들의 저장공간
intArrayPN DWORD ?   
MAX DWORD 0
CMAX DWORD 0
CheckArr DWORD 16 DUP(0)
CheckArr2 DWORD 16 DUP(0)
N DWORD 0
WMAX DWORD 0
WSUM DWORD 0
.code
main PROC

DWh1s:		
				; Dwh1 만족시 실행 코드
	mov edx, OFFSET MSG1
	call WriteString
    call ReadDec
    mov WMAX, eax
    cmp eax, 0          ; <ent>만 입력시 프로그램 종료 (0a00h)
    je PEND

    mov edx, OFFSET MSG2
	call WriteString
    call CRLF

	mov edx, OFFSET inBufferW            
    mov ecx, BUF_SIZE                   
    dec ecx
    call ReadString                     ; 사용자로부터 문자열을 입력받음
    mov  inBufferWN, eax                 ; 입력받은 문자열의 길이를 inBufferN에 저장

	mov edx, OFFSET inBufferW            ; atoi함수의 파라매터 패싱 (edx, ecx, edi)   
    mov ecx, inBufferWN
    mov edi, OFFSET intArrayW
    call atoi                           ; 정수값 추출함수(atoi) 호출
    mov IntArrayWN, ecx                  ; 추출된 정수들의 총 갯수를 IntArrayN에 저장 (Output)

    mov edx, OFFSET MSG3
	call WriteString
    call CRLF

    mov edx, OFFSET inBufferP           
    mov ecx, BUF_SIZE                   
    dec ecx
    call ReadString                     ; 사용자로부터 문자열을 입력받음
    mov  inBufferPN, eax                 ; 입력받은 문자열의 길이를 inBufferN에 저장

	mov edx, OFFSET inBufferP            ; atoi함수의 파라매터 패싱 (edx, ecx, edi)   
    mov ecx, inBufferPN
    mov edi, OFFSET intArrayP
    call atoi                           ; 정수값 추출함수(atoi) 호출
    mov IntArrayPN, ecx                  ; 추출된 정수들의 총 갯수를 IntArrayN에 저장 (Output)

    mov2 N, intArrayPN, eax

    MOV MAX, 0
    mov edi, 0
    mov ecx, 16
L2:
    mov CheckArr2[edi*4], 0
    inc edi
    loop L2
    invoke Calc, 0, N

    mov edx, OFFSET MSG5
	call WriteString
    mov eax, MAX
    call writedec
    call CRLF
   
    mov ecx, N
    mov edi, 0
L1:
    mov eax, CheckArr2[edi*4]
    call writedec
    mov edx, OFFSET MSG6
	call WriteString
    inc edi
    loop L1
    call CRLF
    call CRLF
SkipPrint:
	jmp DWh1s   
PEND:
	mov edx, OFFSET MSG4
	call WriteString

	exit
main ENDP


Calc PROC N1:DWORD, N2:DWORD ; N1 : 현재 위치 , N2 : 끝점 위치
local j:DWORD

	cmp2 N1, N2, eax
	je if1o ; n==0 : MAX 갱신
	jmp if1e

		if1o:
		
        mov WSUM, 0
        mov CMAX, 0

        mov j, 0      
        Fr1s:           ; for1 ( j = 0; j < N2; j++ )
            cmp2 j, N2, eax  
            jl Fr1c
            jmp Fr1e
            Fr1c:       ; For1 조건 만족시 실행

            
            mov edi, j
            cmp DWORD PTR checkArr[4*edi], 0	; if2 ( checkArr[j] == 0 )
            je if2o
            jmp if2e
	            if2o: ; if2 만족 : skipsum1
                jmp skipsum1
	            jmp if2e
            if2e:
           
           mov edi, j
           mov eax, intArrayW[4*edi]
           add WSUM, eax

        skipsum1:
            inc j     
            jmp Fr1s
        Fr1e:    

        mov j, 0      
        fr2s:           ; for2 ( j = 0; j < N2; j++ )
            cmp2 j, N2, eax  
            jl fr2c
            jmp fr2e
            fr2c:       ; for2 조건 만족시 실행

            
            mov edi, j
            cmp DWORD PTR checkArr[4*edi], 0	; if3 ( checkArr[j] == 0 )
            je if3o
            jmp if3e
	            if3o: ; if3 만족 : skipsum2
                jmp skipsum2
	            jmp if3e
            if3e:
           
           mov edi, j
           mov eax, intArrayP[4*edi]
           add CMAX, eax

        skipsum2:
            inc j     
            jmp fr2s
        fr2e:    

        cmp2 WSUM, WMAX, eax	; if4 ( WSUM > WMAX )
        jg if4o
        jmp if4e
	        if4o: ; if4 만족
            jmp skipcalc
	        jmp if4e
        if4e:

        cmp2 CMAX, MAX, eax	; if5 ( CMAX >= MAX )
        jge if5o
        jmp if5e
	        if5o: ; if5 만족
            mov2 MAX, CMAX, eax

            mov edi, 0
            mov esi, 0
            mov ecx, N2
            L2:
                mov2 CheckArr2[4*edi], CheckArr[4*esi], eax
                inc edi
                inc esi
            loop L2

	        jmp if5e
        if5e:
     skipcalc:
		ret

	if1e:

	mov esi, N1
	mov CheckArr[4*esi], 0 
	mov ecx, N1
	inc ecx
	INVOKE Calc, ecx, N2

	mov esi, N1
	mov CheckArr[4*esi], 1
	mov ecx, N1
	inc ecx
	INVOKE Calc, ecx, N2

	ret
Calc ENDP


atoi PROC USES eax ebx edx esi edi ebp  ; 주어진 배열에 저장된 문자열 속의 정수들을 추출후 다른 배열에 저장 및 저장된 정수의 총 갯수의 계산
                                        ; Receives : edx = inBuffer의 배열 포인터
                                        ;            ecx = inBuffer의 원소 갯수(입력된 문자열의 크기) (= InBufferN)
                                        ;            edi = intArray의 배열 포인터
                                        ; Returns  : ecx = intArray의 원소 갯수(추출된 정수의 총 갯수) (= IntArrayN)
                                        ;            edi = intArray의 배열 포인터 
                                        ; al : 현재 읽어들인 문자를 저장 (al = inBuffer[i]) 
                                        ; bl : 현재 정수가 음수인지의 여부 (sign flag)로 사용 
                                        ; bh : 현재 정수가 2자리수 이상인지의 여부 (length flag)로 사용
                                        ; esi : 현재 정수값을 저장
                                        ; ebp : 추출된 정수의 총 갯수를 저장 (= IntArrayN)  
    xor eax, eax                        ; eax 초기화 ( eax = 0 )
    xor bx, bx                          ; bl (sign flag), bh (length flag) 모두 Clear ( bx = 0 )
    mov ebp, 0                          ; 추출된 정수의 총 갯수 초기화
L3:
    push ecx                            ; ecx값 저장 (loop L3)

    mov al, [edx]                       ; al = inBuffer[i]
    cmp al, 2dh                         
    je if2o                             ; if2 ( al == '-' ) : 현재 문자가 '-'(2dh) 일 경우
    jmp if2e

        if2o:
        mov bl, 1                       ; if2 조건 만족 : 현재 정수가 음수이므로 sign flag를 Set(bh=1) 한다.
        jmp JumpToNext                  ; 다음 문자로 이동

    if2e: 

    cmp al, 30h 
    jge if3o1                           ; if3-1 (al >= '0') 
    jmp if3e

        if3o1:
        cmp al, 39h
        jle if3o2                       ; if3-2 (al <= '9')
        jmp if3e

            if3o2:                      ; if3 (al >= '0' && al <= '9') : 현재 문자가 숫자(0~9) 일 경우
            or bh, bh                   ; (= cmp bh, 0 )
            jz if4o                     ; if4 ( bh == 0 ) : length flag가 0일경우
            jmp if4x

                if4o:                   ; if4 조건 만족 : length flag가 0이므로 현재 읽어들인 수를 그대로 저장한다. (esi = (eax-0x30))
                mov esi, eax            ; esi = al - 0x30 : 문자열 값 -> 숫자로 변환후 대입
                sub esi, 30h 
                jmp if4e
                
                if4x:                   ; if4 조건 불만족 : length flag가 1이므로 이미 저장된 수들의 자리수를 왼쪽으로 한칸 밀고 현재 읽어들인 수를 저장한다. (esi = esi * 10 + (eax-0x30))
                imul esi, 10            ; esi *= 10 : 저장된 수의 자리수를 왼쪽으로 한칸 밈
                add esi, eax            ; esi += al - 0x30 : 문자열 값 -> 숫자로 변환후 대입
                sub esi, 30h
                jmp if4e

            if4e:
            mov bh, 1                   ; esi에 숫자가 저장되었으므로 다음 문자가 숫자일 경우 현재 정수는 최소 2자리 이상의 정수이다. : length flag = 1로 Set
            
            mov al, [edx+1]             ; al : 다음에 읽어들일 문자를 저장 (al = inBuffer[i+1]) 
            cmp al, 30h
            jl if5o                     ; if5-1 ( al < '0' )
            jmp if5x

            if5x:
            cmp al, 39h
            jg if5o                     ; if5-2 (al > '9' )
            jmp if5e

            if5o:                       ; if5 (al < '0' || al > '9') : 다음 문자가 숫자가 아닐경우 -> 현재 정수값을 intArray에 저장한다.
            or bl, bl                   ; (= cmp bl, 0 )
            jz if6e                     ; if6 (bl == 0) : sign flag가 0일경우
            jmp if6o

                if6o:                   ; if6 조건 불만족 : sign flag가 1이므로 현재 정수는 음수이다. -> 정수값의 부호를 바꾼다.(+ -> -)
                neg esi                 ; 현재 정수값(esi)의 부호 전환(양수 -> 음수)

            if6e:
            mov [edi], esi              ; 현재 정수값을 intArray에 저장
            add edi, 4                  ; 다음 정수값 저장공간으로 이동
            inc ebp                     ; 저장된 정수의 총 개수 += 1 
            xor esi, esi                ; 현재 정수값 초기화 ( esi = 0 )
            xor bx, bx                  ; Sign flag, length flag 초기화 ( bx = 0 )
            jmp if5e

        if5e:

    if3e: 

    JumpToNext:                         
    inc edx                             ; 다음 문자로 이동
    pop ecx                             ; ecx값 복구 (loop L3)
    loop L3

                                        ; edi : IntArray의 배열 포인터로 사용하게 설정 (Output) : USES 사용으로 Input된 값으로 자동복구됨 (edi = OFFSET IntArray)
    mov ecx, ebp                        ; ecx : IntArrayN의 값을 저장하게 설정 (Output)
    ret
atoi ENDP

END main
