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
inBufferW  BYTE BUF_SIZE DUP(?)                          ; �Է¹��� ���ڿ��� ������� (�ִ� 255��)
inBufferWN DWORD ?                                       ; �Է¹��� ���ڿ��� ���� (Null ����)
intArrayW  SDWORD BUF_SIZE/2 DUP(?)                      ; ����� ���������� �������
intArrayWN DWORD ?                                       ; ����� ���������� ����
inBufferP  BYTE BUF_SIZE DUP(?)                          ; �Է¹��� ���ڿ��� ������� (�ִ� 255��)
inBufferPN DWORD ?                                       ; �Է¹��� ���ڿ��� ���� (Null ����)
intArrayP  SDWORD BUF_SIZE/2 DUP(?)                      ; ����� ���������� �������
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
				; Dwh1 ������ ���� �ڵ�
	mov edx, OFFSET MSG1
	call WriteString
    call ReadDec
    mov WMAX, eax
    cmp eax, 0          ; <ent>�� �Է½� ���α׷� ���� (0a00h)
    je PEND

    mov edx, OFFSET MSG2
	call WriteString
    call CRLF

	mov edx, OFFSET inBufferW            
    mov ecx, BUF_SIZE                   
    dec ecx
    call ReadString                     ; ����ڷκ��� ���ڿ��� �Է¹���
    mov  inBufferWN, eax                 ; �Է¹��� ���ڿ��� ���̸� inBufferN�� ����

	mov edx, OFFSET inBufferW            ; atoi�Լ��� �Ķ���� �н� (edx, ecx, edi)   
    mov ecx, inBufferWN
    mov edi, OFFSET intArrayW
    call atoi                           ; ������ �����Լ�(atoi) ȣ��
    mov IntArrayWN, ecx                  ; ����� �������� �� ������ IntArrayN�� ���� (Output)

    mov edx, OFFSET MSG3
	call WriteString
    call CRLF

    mov edx, OFFSET inBufferP           
    mov ecx, BUF_SIZE                   
    dec ecx
    call ReadString                     ; ����ڷκ��� ���ڿ��� �Է¹���
    mov  inBufferPN, eax                 ; �Է¹��� ���ڿ��� ���̸� inBufferN�� ����

	mov edx, OFFSET inBufferP            ; atoi�Լ��� �Ķ���� �н� (edx, ecx, edi)   
    mov ecx, inBufferPN
    mov edi, OFFSET intArrayP
    call atoi                           ; ������ �����Լ�(atoi) ȣ��
    mov IntArrayPN, ecx                  ; ����� �������� �� ������ IntArrayN�� ���� (Output)

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


Calc PROC N1:DWORD, N2:DWORD ; N1 : ���� ��ġ , N2 : ���� ��ġ
local j:DWORD

	cmp2 N1, N2, eax
	je if1o ; n==0 : MAX ����
	jmp if1e

		if1o:
		
        mov WSUM, 0
        mov CMAX, 0

        mov j, 0      
        Fr1s:           ; for1 ( j = 0; j < N2; j++ )
            cmp2 j, N2, eax  
            jl Fr1c
            jmp Fr1e
            Fr1c:       ; For1 ���� ������ ����

            
            mov edi, j
            cmp DWORD PTR checkArr[4*edi], 0	; if2 ( checkArr[j] == 0 )
            je if2o
            jmp if2e
	            if2o: ; if2 ���� : skipsum1
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
            fr2c:       ; for2 ���� ������ ����

            
            mov edi, j
            cmp DWORD PTR checkArr[4*edi], 0	; if3 ( checkArr[j] == 0 )
            je if3o
            jmp if3e
	            if3o: ; if3 ���� : skipsum2
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
	        if4o: ; if4 ����
            jmp skipcalc
	        jmp if4e
        if4e:

        cmp2 CMAX, MAX, eax	; if5 ( CMAX >= MAX )
        jge if5o
        jmp if5e
	        if5o: ; if5 ����
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
