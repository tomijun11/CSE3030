TITLE s191820HW04.asm
comment #
Author : 20191820 ������
data : 2020-05-24
function : �־��� ���̵��� ���� �� ���̰� ū �������� ���̸� ���
Input : CSE3030_PHW04.inc 
Output : ���� �� ���̰� ū �������� ����
#

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW04.inc

.code
main PROC
						 ; ebp : �������� �ִ� ��������(Max Height)�� ����, edx : ���� �������� ��������(Current Height)�� ����

	mov ecx, TN			 ; Test Case �� ��ŭ �ݺ� (Loop L1)
	mov esi, OFFSET CASE ; esi : HEIGHT �迭 �����ͷ� ���
	L1:
	push ecx			 ; ecx �� ���� (Loop L1)

	mov edi, [esi]		 ; edi : �������� ��(CASE)�� �� ����
	add esi, 4			 ; Height �迭�� �̵�

	mov ebp, 0			 ; Current Height, Max Height �ʱ�ȭ
	mov edx, 0
	
	mov ecx, edi		 ; Height �迭�� ���� ����-1 ��ŭ �ݺ� (Loop L2)
	dec ecx
	L2:
	mov eax, [esi]		 ; [esi] = Height[i] (�迭�� ���� ����) , [esi+4] = Height[i+1] (�迭�� ���� ����) 
	cmp eax, [esi+4] 
	jg if1o				 ; if1 ( Height[i] > Height[i+1] )
	jmp if1x

		if1o:			 ; if1 ���� ���� : ���� �� �������̹Ƿ� �������̸� ���� 
		mov ebx, eax
		sub ebx, [esi+4]
		add edx, ebx	 ; Current Height += ��������
		jmp if1e
	
		if1x:			 ; if1 ���� �Ҹ��� : �������� ���̹Ƿ� MAX height ���� ��
		cmp ebp, edx
		jl if2o			 ; if2 ( MAX height < Current Height )
		jmp if2e

			if2o:	 	 ; if2 ���� ���� : MAX Height�� Current Height�� ����
			mov ebp, edx 
			
		if2e:			 ; if2 end
		mov edx, 0		 ; Current Height �ʱ�ȭ

	if1e:				 ; if1 end
	add esi, 4			 ; i++ (�迭�� ���� ���ҷ� �̵�)
	loop L2

	cmp ebp, edx
	jl if3o				 ; if3 ( MAX height < Current Height )
	jmp if3e

		if3o:			 ; if3 ���� ���� : MAX Height�� Current Height�� ����
		mov ebp, edx

	if3e:				 ; if3 end

	mov eax, ebp  
	Call WriteDec		 ; ��� ���
    Call CRLF			 ; �ٹٲ�

	add esi, 4			 ; ���� Test Case�� �̵�

	pop ecx				 ; ecx �� ���� (Loop L1)
	loop L1

	exit
main ENDP
END main