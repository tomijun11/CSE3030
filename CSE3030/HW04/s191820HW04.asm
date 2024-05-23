TITLE s191820HW04.asm
comment #
Author : 20191820 김형준
data : 2020-05-24
function : 주어진 높이들중 가장 고도 차이가 큰 내리막의 높이를 계산
Input : CSE3030_PHW04.inc 
Output : 가장 고도 차이가 큰 내리막의 높이
#

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW04.inc

.code
main PROC
						 ; ebp : 내리막의 최대 높이차이(Max Height)를 저장, edx : 현재 내리막의 높이차이(Current Height)를 저장

	mov ecx, TN			 ; Test Case 수 만큼 반복 (Loop L1)
	mov esi, OFFSET CASE ; esi : HEIGHT 배열 포인터로 사용
	L1:
	push ecx			 ; ecx 값 저장 (Loop L1)

	mov edi, [esi]		 ; edi : 측정지점 수(CASE)의 값 저장
	add esi, 4			 ; Height 배열로 이동

	mov ebp, 0			 ; Current Height, Max Height 초기화
	mov edx, 0
	
	mov ecx, edi		 ; Height 배열의 원소 갯수-1 만큼 반복 (Loop L2)
	dec ecx
	L2:
	mov eax, [esi]		 ; [esi] = Height[i] (배열의 현재 원소) , [esi+4] = Height[i+1] (배열의 다음 원소) 
	cmp eax, [esi+4] 
	jg if1o				 ; if1 ( Height[i] > Height[i+1] )
	jmp if1x

		if1o:			 ; if1 조건 만족 : 같은 한 내리막이므로 높이차이를 더함 
		mov ebx, eax
		sub ebx, [esi+4]
		add edx, ebx	 ; Current Height += 높이차이
		jmp if1e
	
		if1x:			 ; if1 조건 불만족 : 내리막의 끝이므로 MAX height 값과 비교
		cmp ebp, edx
		jl if2o			 ; if2 ( MAX height < Current Height )
		jmp if2e

			if2o:	 	 ; if2 조건 만족 : MAX Height에 Current Height를 저장
			mov ebp, edx 
			
		if2e:			 ; if2 end
		mov edx, 0		 ; Current Height 초기화

	if1e:				 ; if1 end
	add esi, 4			 ; i++ (배열의 다음 원소로 이동)
	loop L2

	cmp ebp, edx
	jl if3o				 ; if3 ( MAX height < Current Height )
	jmp if3e

		if3o:			 ; if3 조건 만족 : MAX Height에 Current Height를 저장
		mov ebp, edx

	if3e:				 ; if3 end

	mov eax, ebp  
	Call WriteDec		 ; 결과 출력
    Call CRLF			 ; 줄바꿈

	add esi, 4			 ; 다음 Test Case로 이동

	pop ecx				 ; ecx 값 복구 (Loop L1)
	loop L1

	exit
main ENDP
END main