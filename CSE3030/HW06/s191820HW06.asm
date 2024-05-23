TITLE s191820HW06.asm
comment #
Author : 20191820 김형준
data : 2020-06-01
function : 문자열을 입력받고 그 속에서 정수들을 추출한 후 오름차순으로 정렬하고 각 요소들의 거리합의 최소값을 계산
Input : 공백문자와 부호가 포함된 정수가 포함된 문자열
Output : 배열 요소들의 거리합의 최소값
#
COMMENT @
문제 해결 방법 설명 :
1. HW05에서 사용한 atoi 함수로 입력받은 문자열을 숫자로 변환한 후 배열에 저장한다.
2. 레지스터로 배열의 주소와 배열원소의 갯수를 입력받는다.
3. 배열의 첫번째 원소를 거리의 기준으로 삼고, 다른 모든 원소들과의 거리(위치차의 절댓값)을 더해서 거리합을 구한다.
4. 3.에서 구한 거리합을 거리합의 최솟값으로 저장한다.
5. 배열의 두번째 원소부터 마지막 원소까지 각각 거리의 기준으로 삼은 거리합을 구한뒤
거리합이 저장된 최솟값보다 작으면 최솟값을 현재 구한 거리값으로 교체한다.
(두번재 원소가 기준인 거리합 계산 -> 저장된 최솟값과 비교 -> 세번째 원소가 기준인 거리합 계산 -> 저장된 최솟값과 비교 ->... 순으로 진행)
6. 구한 거리합의 최솟값을 출력한다.
@

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

    mov edx, OFFSET intArray            ; bubble_sort함수의 파라매터 패싱 (edx, ecx)   
    mov ecx, intArrayN
    call bubble_sort                    ; 배열 정렬함수(bubble_sort) 호출 (사용하지 않아도 상관없음)

    mov edx, OFFSET intArray            ; search함수의 파라매터 패싱 (edx, ecx)   
    mov ecx, intArrayN
    call search                         ; 배열 요소들의 거리합의 최소값 계산함수(search) 호출
    mov eax, ecx                        ; 최소값을 eax에 저장 (Output)

    call WriteDec                       ; 계산된 최소값을 출력
    call CRLF                           ; 줄바꿈

    SkipPrint:
    jmp L1                              ; 프로그램 반복 : 처음으로 돌아감

PEND:
    mov edx, OFFSET Message2            
    call WriteString                    ; 프로그램 종료시 메세지 출력
	exit
main ENDP

search PROC USES eax ebx edi esi ebp    ; 주어진 배열의 원소들의 거리합의 최소값을 계산
                                        ; Receives : edx = intArray의 배열 포인터
                                        ;            ecx = intArray의 원소 갯수 (= IntArrayN)
                                        ; Returns  : ecx = 거리합의 최소값
                                        ; edi : i , esi : j, edx : Arr(배열의 주소)
                                        ; ecx : 현재 원소를 기준으로한 거리합 (현재 거리합)
                                        ; ebp : 거리합의 최소값
    push ecx                            ; stack에 Size(배열의 원소 갯수)를 저장 ([esp] = Size)

    xor ebp, ebp                        ; 거리합 최소값 초기화
    xor edi, edi                        ; i = 0 (초기화)
Wh3s:                                   ; Wh3 : for(i = 0; i < Size; i++)     
    cmp edi, [esp]                      ; Wh3 반복 조건 : (i < Size)
    jl Wh3c
    jmp Wh3e
    Wh3c:                               ; Wh3 조건 만족시 실행 

    mov ebx, [edx][edi*4]               ; ebx = Arr[i] (선택한 집의 위치)
    xor ecx, ecx                        ; 현재 거리합 초기화
    xor esi, esi                        ; j = 0 (초기화)
    Wh4s:                               ; Wh4 : for(j = 0; j < Size; j++)                           
        cmp esi, [esp]                  ; Wh4 반복 조건 : (j < Size)
        jl Wh4c
        jmp Wh4e
        Wh4c:                           ; Wh4 조건 만족시 실행

        mov eax, [edx][esi*4]           ; eax = Arr[j]
        cmp eax, ebx                    ; if6(Arr[j] >= Arr[i])
        jge if6o
        jmp if6x

            if6o:                       ; if6 조건 만족 : 현재 거리합 += (Arr[j] - Arr[i])
            add ecx, eax
            sub ecx, ebx
            jmp if6e

            if6x:                       ; if6 조건 불만족 : 현재 거리합 += (Arr[i] - Arr[j])
            add ecx, ebx
            sub ecx, eax
            jmp if6e

        if6e:
        inc esi                         ; j++
        jmp Wh4s                        
        Wh4e:                           ; Wh4 루프 종료

        or edi, edi                     ; if7-1 ( i == 0 )
        jz if7o
        jmp if7x

            if7x:                          
            cmp ecx, ebp                ; if7-2 ( ecx < ebp ) 
            jl if7o
            jmp if7e

        if7o:                           ; if7 (i == 0 || ecx < ebp ) : i가 0이거나 현재 거리합이 저장된 최소값보다 작을경우
        mov ebp, ecx                    ; 최소값에 현재 거리합을 저장
        jmp if7e

    if7e:
    inc edi                             ; i++
    jmp Wh3s
    Wh3e:                               ; Wh3 루프 종료

    pop ecx                             ; Stack에 저장된 값 제거 (Size)
    mov ecx, ebp                        ; ecx : 거리합의 최소값을 저장하게 설정 (Output)
    ret
search ENDP

bubble_sort PROC USES eax ebx edi esi   ; 주어진 배열의 원소들을 오름차순으로 정렬
                                        ; Receives : edx = intArray의 배열 포인터
                                        ;            ecx = intArray의 원소 갯수 (= IntArrayN)
                                        ; Returns  : 없음
                                        ; edi : i , esi : j, ecx : Size(배열의 원소 갯수), edx : Arr(배열의 주소)

    xor edi, edi                        ; i = 0 (초기화)
Wh1s:                                   ; Wh1 : for(i = 0; i < Size - 1; i++)
    mov ebx, ecx
    dec ebx
    cmp edi, ebx                        ; Wh1 반복 조건 : (i < Size - 1) 
    jl Wh1c
    jmp Wh1e
    Wh1c:                               ; Wh1 조건 만족시 실행

    mov esi, ecx
    dec esi                             ; j = Size - 1 (초기화)
    Wh2s:                               ; Wh2 : for(j = Size - 1; j > i; j--)
        cmp esi, edi                    ; Wh2 반복 조건 : (j > i) 
        jg Wh2c
        jmp Wh2e
        Wh2c:                           ; Wh2 조건 만족시 실행

        mov eax, [edx][esi*4-4]         ; eax = Arr[j-1]
        mov ebx, [edx][esi*4]           ; ebx = Arr[j]
        cmp eax, ebx                    ; if0(Arr[j-1] > Arr[j])
        jg if0o
        jmp if0e

            if0o:                       ; if0 조건 만족 : Stack을 통해 Arr[j-1]과 Arr[j]값을 서로 바꿈
            push [edx][esi*4]           ; = Arr[j]
            push [edx][esi*4-4]         ; = Arr[j-1]
            pop [edx][esi*4]
            pop [edx][esi*4-4]

        if0e:
        dec esi                         ; j--
        jmp Wh2s
        Wh2e:                           ; Wh2 루프 종료

    inc edi                             ; i++
    jmp Wh1s
    Wh1e:                               ; Wh1 루프 종료
    ret

bubble_sort ENDP

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
