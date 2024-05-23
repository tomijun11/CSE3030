TITLE s191820HW05.asm
comment #
Author : 20191820 ������
data : 2020-05-28
function : ���ڿ��� �Է¹ް� �� �ӿ��� �������� ������ �� ���� ���
Input : ���鹮�ڿ� ��ȣ�� ���Ե� ������ ���Ե� ���ڿ�
Output : ���ڿ��� �������� ��
#

INCLUDE Irvine32.inc

.data
BUF_SIZE EQU 256                                     
inBuffer  BYTE BUF_SIZE DUP(?)                          ; �Է¹��� ���ڿ��� ������� (�ִ� 255��)
inBufferN DWORD ?                                       ; �Է¹��� ���ڿ��� ���� (Null ����)
intArray  SDWORD BUF_SIZE/2 DUP(?)                      ; ����� ���������� �������
intArrayN DWORD ?                                       ; ����� ���������� ����
Message BYTE "Enter numbers(<ent> to exit) :",0dh,0ah,0 ; ���α׷� ���۽� �ȳ� �޼���
Message2 BYTE "Bye!",0                                  ; ���α׷� ����� ����� �޼���

.code
main PROC
                                        ; edx : inBuffer�� �迭 �����ͷ� ��� 
                                        ; edi : intArray�� �迭 �����ͷ� ���
L1:
    mov edx, OFFSET Message             
    call WriteString                    ; ���α׷� ���۽� �ȳ� �޼��� ���

	mov edx, OFFSET inBuffer            
    mov ecx, BUF_SIZE                   
    dec ecx
    call ReadString                     ; ����ڷκ��� ���ڿ��� �Է¹���
    mov  inBufferN, eax                 ; �Է¹��� ���ڿ��� ���̸� inBufferN�� ����

    cmp WORD PTR [edx], 0a00h           ; <ent>�� �Է½� ���α׷� ���� (0a00h)
    je PEND

    mov edx, OFFSET inBuffer            ; atoi�Լ��� �Ķ���� �н� (edx, ecx, edi)   
    mov ecx, inBufferN
    mov edi, OFFSET intArray
    call atoi                           ; ������ �����Լ�(atoi) ȣ��
    mov IntArrayN, ecx                  ; ����� �������� �� ������ IntArrayN�� ���� (Output)

    cmp intArrayN, 0                    ; ����� �������� �������(intArrayN == 0) ������ ����� �ǳʶ� 
    jz SkipPrint
                                        ; eax : ����� ���������� ������ ���
    xor eax, eax                        ; (eax = 0)
L2:
    add eax, [edi]                      ; eax += intArray[i]
    add edi, 4                          ; i++
    loop L2

    or eax, eax                         ; (= cmp eax, 0 )
    js if1o                             ; if1 ( eax < 0 )
    jmp if1x
    
    if1o:                               
    call WriteInt                       ; if1 ���� ���� : �����̹Ƿ� ��ȣ(-)�� �Բ� ��� (WriteInt �Լ� ���)    
    jmp if1e

    if1x: 
    call WriteDec                       ; if1 ���� �Ҹ��� : ��� �Ǵ� 0�̹Ƿ� ���ڸ� ��� (WriteDec �Լ� ���) 
    jmp if1e

    if1e:
    call CRLF                           ; �ٹٲ�

    SkipPrint:
    jmp L1                              ; ���α׷� �ݺ� : ó������ ���ư�

PEND:
    mov edx, OFFSET Message2            
    call WriteString                    ; ���α׷� ����� �޼��� ���
	exit
main ENDP

atoi PROC USES eax ebx edx esi edi ebp  ; �־��� �迭�� ����� ���ڿ� ���� �������� ������ �ٸ� �迭�� ���� �� ����� ������ �� ������ ���
                                        ; Receives : edx = inBuffer�� �迭 ������
                                        ;            ecx = inBuffer�� ���� ����(�Էµ� ���ڿ��� ũ��) (= InBufferN)
                                        ;            edi = intArray�� �迭 ������
                                        ; Returns  : ecx = intArray�� ���� ����(����� ������ �� ����) (= IntArrayN)
                                        ;            edi = intArray�� �迭 ������ 
                                        ; al : ���� �о���� ���ڸ� ���� (al = inBuffer[i]) 
                                        ; bl : ���� ������ ���������� ���� (sign flag)�� ��� 
                                        ; bh : ���� ������ 2�ڸ��� �̻������� ���� (length flag)�� ���
                                        ; esi : ���� �������� ����
                                        ; ebp : ����� ������ �� ������ ���� (= IntArrayN)  
    xor eax, eax                        ; eax �ʱ�ȭ ( eax = 0 )
    xor bx, bx                          ; bl (sign flag), bh (length flag) ��� Clear ( bx = 0 )
    mov ebp, 0                          ; ����� ������ �� ���� �ʱ�ȭ
L3:
    push ecx                            ; ecx�� ���� (loop L3)

    mov al, [edx]                       ; al = inBuffer[i]
    cmp al, 2dh                         
    je if2o                             ; if2 ( al == '-' ) : ���� ���ڰ� '-'(2dh) �� ���
    jmp if2e

        if2o:
        mov bl, 1                       ; if2 ���� ���� : ���� ������ �����̹Ƿ� sign flag�� Set(bh=1) �Ѵ�.
        jmp JumpToNext                  ; ���� ���ڷ� �̵�

    if2e: 

    cmp al, 30h 
    jge if3o1                           ; if3-1 (al >= '0') 
    jmp if3e

        if3o1:
        cmp al, 39h
        jle if3o2                       ; if3-2 (al <= '9')
        jmp if3e

            if3o2:                      ; if3 (al >= '0' && al <= '9') : ���� ���ڰ� ����(0~9) �� ���
            or bh, bh                   ; (= cmp bh, 0 )
            jz if4o                     ; if4 ( bh == 0 ) : length flag�� 0�ϰ��
            jmp if4x

                if4o:                   ; if4 ���� ���� : length flag�� 0�̹Ƿ� ���� �о���� ���� �״�� �����Ѵ�. (esi = (eax-0x30))
                mov esi, eax            ; esi = al - 0x30 : ���ڿ� �� -> ���ڷ� ��ȯ�� ����
                sub esi, 30h 
                jmp if4e
                
                if4x:                   ; if4 ���� �Ҹ��� : length flag�� 1�̹Ƿ� �̹� ����� ������ �ڸ����� �������� ��ĭ �а� ���� �о���� ���� �����Ѵ�. (esi = esi * 10 + (eax-0x30))
                imul esi, 10            ; esi *= 10 : ����� ���� �ڸ����� �������� ��ĭ ��
                add esi, eax            ; esi += al - 0x30 : ���ڿ� �� -> ���ڷ� ��ȯ�� ����
                sub esi, 30h
                jmp if4e

            if4e:
            mov bh, 1                   ; esi�� ���ڰ� ����Ǿ����Ƿ� ���� ���ڰ� ������ ��� ���� ������ �ּ� 2�ڸ� �̻��� �����̴�. : length flag = 1�� Set
            
            mov al, [edx+1]             ; al : ������ �о���� ���ڸ� ���� (al = inBuffer[i+1]) 
            cmp al, 30h
            jl if5o                     ; if5-1 ( al < '0' )
            jmp if5x

            if5x:
            cmp al, 39h
            jg if5o                     ; if5-2 (al > '9' )
            jmp if5e

            if5o:                       ; if5 (al < '0' || al > '9') : ���� ���ڰ� ���ڰ� �ƴҰ�� -> ���� �������� intArray�� �����Ѵ�.
            or bl, bl                   ; (= cmp bl, 0 )
            jz if6e                     ; if6 (bl == 0) : sign flag�� 0�ϰ��
            jmp if6o

                if6o:                   ; if6 ���� �Ҹ��� : sign flag�� 1�̹Ƿ� ���� ������ �����̴�. -> �������� ��ȣ�� �ٲ۴�.(+ -> -)
                neg esi                 ; ���� ������(esi)�� ��ȣ ��ȯ(��� -> ����)

            if6e:
            mov [edi], esi              ; ���� �������� intArray�� ����
            add edi, 4                  ; ���� ������ ����������� �̵�
            inc ebp                     ; ����� ������ �� ���� += 1 
            xor esi, esi                ; ���� ������ �ʱ�ȭ ( esi = 0 )
            xor bx, bx                  ; Sign flag, length flag �ʱ�ȭ ( bx = 0 )
            jmp if5e

        if5e:

    if3e: 

    JumpToNext:                         
    inc edx                             ; ���� ���ڷ� �̵�
    pop ecx                             ; ecx�� ���� (loop L3)
    loop L3

                                        ; edi : IntArray�� �迭 �����ͷ� ����ϰ� ���� (Output) : USES ������� Input�� ������ �ڵ������� (edi = OFFSET IntArray)
    mov ecx, ebp                        ; ecx : IntArrayN�� ���� �����ϰ� ���� (Output)
    ret
atoi ENDP

END main

