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

.data
MSG1 BYTE "Enter Ruby Sizes : ",0
MSG2 BYTE "Bye!",0
MSG3 BYTE "Max Profit = ",0
BUF_SIZE EQU 256                                     
inBuffer  BYTE BUF_SIZE DUP(?)                          ; �Է¹��� ���ڿ��� ������� (�ִ� 255��)
inBufferN DWORD ?                                       ; �Է¹��� ���ڿ��� ���� (Null ����)
intArray  SDWORD BUF_SIZE/2 DUP(?)                      ; ����� ���������� �������
intArrayN DWORD ?                                       ; ����� ���������� ����
MAX DWORD 0
Current_MAX DWORD 0
j DWORD 0
k DWORD 0
N2 DWORD 0
.code
main PROC

DWh1s:		
				; Dwh1 ������ ���� �ڵ�
	mov edx, OFFSET MSG1
	call WriteString
    call CRLF

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

    mov edx, OFFSET intArray            ; bubble_sort�Լ��� �Ķ���� �н� (edx, ecx)   
    mov ecx, intArrayN
    call bubble_sort                    ; �迭 �����Լ�(bubble_sort) ȣ�� 

    mov MAX, 0
    
    mov j, 0      
    Fr1s:           ; for1 ( j = 0; j < N; j++ )
        cmp2 j, intArrayN, eax   
        jl Fr1c
        jmp Fr1e
        Fr1c:       ; For1 ���� ������ ����
 
        mov eax, intArrayN
        sub eax, j
        mov N2, eax

        mov edi, j
        mov eax, intArray[edi*4]
        mov ebx, N2
        imul eax, ebx
        mov Current_MAX, eax

        cmp2 Current_MAX, MAX, eax	; if1 ( Current_MAX >= MAX )
        jge if1o
        jmp if1e

	        if1o: ; if1 ����
            mov2 MAX, Current_MAX, eax
	        jmp if1e

        if1e:

        inc j     
        jmp Fr1s
    Fr1e:    


    mov edx, OFFSET MSG3
	call WriteString
    mov eax, MAX
    call writedec
    call CRLF
    call CRLF
SkipPrint:
	jmp DWh1s   
PEND:
	mov edx, OFFSET MSG2
	call WriteString

	exit
main ENDP


bubble_sort PROC USES eax ebx edi esi   ; �־��� �迭�� ���ҵ��� ������������ ����
                                        ; Receives : edx = intArray�� �迭 ������
                                        ;            ecx = intArray�� ���� ���� (= IntArrayN)
                                        ; Returns  : ����
                                        ; edi : i , esi : j, ecx : Size(�迭�� ���� ����), edx : Arr(�迭�� �ּ�)

    xor edi, edi                        ; i = 0 (�ʱ�ȭ)
Wh1s:                                   ; Wh1 : for(i = 0; i < Size - 1; i++)
    mov ebx, ecx
    dec ebx
    cmp edi, ebx                        ; Wh1 �ݺ� ���� : (i < Size - 1) 
    jl Wh1c
    jmp Wh1e
    Wh1c:                               ; Wh1 ���� ������ ����

    mov esi, ecx
    dec esi                             ; j = Size - 1 (�ʱ�ȭ)
    Wh2s:                               ; Wh2 : for(j = Size - 1; j > i; j--)
        cmp esi, edi                    ; Wh2 �ݺ� ���� : (j > i) 
        jg Wh2c
        jmp Wh2e
        Wh2c:                           ; Wh2 ���� ������ ����

        mov eax, [edx][esi*4-4]         ; eax = Arr[j-1]
        mov ebx, [edx][esi*4]           ; ebx = Arr[j]
        cmp eax, ebx                    ; if0(Arr[j-1] > Arr[j])
        jg if0o
        jmp if0e

            if0o:                       ; if0 ���� ���� : Stack�� ���� Arr[j-1]�� Arr[j]���� ���� �ٲ�
            push [edx][esi*4]           ; = Arr[j]
            push [edx][esi*4-4]         ; = Arr[j-1]
            pop [edx][esi*4]
            pop [edx][esi*4-4]

        if0e:
        dec esi                         ; j--
        jmp Wh2s
        Wh2e:                           ; Wh2 ���� ����

    inc edi                             ; i++
    jmp Wh1s
    Wh1e:                               ; Wh1 ���� ����
    ret

bubble_sort ENDP

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
