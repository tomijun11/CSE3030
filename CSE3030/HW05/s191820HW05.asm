TITLE s191820HW05.asm
comment #
Author : 20191820 김형준
data : 2020-05-28
function : 문자열을 입력받고 그 속에서 정수들을 추출한 후 합을 계산
Input : 공백문자와 부호가 포함된 정수가 포함된 문자열
Output : 문자열속 정수들의 합
#

INCLUDE Irvine32.inc

.data
BUF_SIZE EQU 256                                     
inBuffer  BYTE BUF_SIZE DUP(?)                          ; 입력받은 문자열의 저장공간 (최대 255자)
inBufferN DWORD ?                                       ; 입력받은 문자열의 길이 (Null 제외)
intArray  SDWORD BUF_SIZE/2 DUP(?)                      ; 추출된 정수값들의 저장공간
intArrayN DWORD ?                                       ; 추출된 정수값들의 갯수
Message BYTE "Enter numbers(<ent> to exit) :",0dh,0ah,0 ; 프로그램 시작시 안내 메세지
Message2 BYTE "Bye!",0                                  ; 프로그램 종료시 출력할 메세지

.code
main PROC
                                        ; edx : inBuffer의 배열 포인터로 사용 
                                        ; edi : intArray의 배열 포인터로 사용
L1:
    mov edx, OFFSET Message             
    call WriteString                    ; 프로그램 시작시 안내 메세지 출력

	mov edx, OFFSET inBuffer            
    mov ecx, BUF_SIZE                   
    dec ecx
    call ReadString                     ; 사용자로부터 문자열을 입력받음
    mov  inBufferN, eax                 ; 입력받은 문자열의 길이를 inBufferN에 저장

    cmp WORD PTR [edx], 0a00h           ; <ent>만 입력시 프로그램 종료 (0a00h)
    je PEND

    mov edx, OFFSET inBuffer            ; atoi함수의 파라매터 패싱 (edx, ecx, edi)   
    mov ecx, inBufferN
    mov edi, OFFSET intArray
    call atoi                           ; 정수값 추출함수(atoi) 호출
    mov IntArrayN, ecx                  ; 추출된 정수들의 총 갯수를 IntArrayN에 저장 (Output)

    cmp intArrayN, 0                    ; 추출된 정수값이 없을경우(intArrayN == 0) 정수값 출력을 건너뜀 
    jz SkipPrint
                                        ; eax : 추출된 정수값들의 합으로 사용
    xor eax, eax                        ; (eax = 0)
L2:
    add eax, [edi]                      ; eax += intArray[i]
    add edi, 4                          ; i++
    loop L2

    or eax, eax                         ; (= cmp eax, 0 )
    js if1o                             ; if1 ( eax < 0 )
    jmp if1x
    
    if1o:                               
    call WriteInt                       ; if1 조건 만족 : 음수이므로 부호(-)와 함께 출력 (WriteInt 함수 사용)    
    jmp if1e

    if1x: 
    call WriteDec                       ; if1 조건 불만족 : 양수 또는 0이므로 숫자만 출력 (WriteDec 함수 사용) 
    jmp if1e

    if1e:
    call CRLF                           ; 줄바꿈

    SkipPrint:
    jmp L1                              ; 프로그램 반복 : 처음으로 돌아감

PEND:
    mov edx, OFFSET Message2            
    call WriteString                    ; 프로그램 종료시 메세지 출력
	exit
main ENDP

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

