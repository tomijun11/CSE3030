TITLE s191820HW03.asm
comment #
Author : 20191820 ������
data : 2020-05-08
function : key�� 7�̰� ũ�Ⱑ 9�� Caesar cipher ��ȣ������ decipher
Input : CSE3030_PHW03.inc 
Output : 0s191820_out.txt
#

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW03.inc

.data 
L BYTE "3456789012",0
COMMENT #
key = 7 �̹Ƿ� cipher �� ����
L = {0,1,2,3,4,5,6,7,8,9} �� ����
L = {3,4,5,6,7,8,9,0,1,2} �� ��ȯ�Ͽ� decipher �� �� �ִ�.
#

filename BYTE "0s191820_out.txt",0
filehandle HANDLE ?
buffer BYTE 9 DUP(?),0dh,0ah
BUFSIZE = $ - buffer
bytesWritten DWORD ?

.code
main PROC
    ; ���� ���� �� ����
	mov  edx,OFFSET filename
    call CreateOutputFile
    mov  filehandle, eax
   
    mov edi, 0 ; edi = Cipher_Str�� ��� ��ġ
    mov ecx, Num_Str

    L1: ; cipher �� ���ڿ� 1���� decipher�� �� ���Ͽ� ��� (L1) 
    push ecx
    
    mov ecx, 9 
    mov esi, 0 ; esi = buffer�� ��� ��ġ
    
    L2: ; 1���ھ� decipher �ؼ� buffer�� ����(L2)
    mov ebx, 0
    mov bl, [Cipher_Str+edi] 
    inc edi
    sub bl, 30h
    mov bl, [L+ebx] ; ebx = 0 ~ +9 -> L�� ���� 1:1 ��ȯ (decipher)
    mov [buffer+esi], bl ; buffer�� decipher�� �� ����
    inc esi

    loop L2 

    inc edi ; ���� Cipher�� ���ڿ��� �̵�

    ; ���ۿ� �Էµ� ���ڿ��� ���Ͽ� ���
    mov  eax,filehandle
    mov  edx,OFFSET buffer
    mov  ecx,BUFSIZE
    call WriteToFile
    mov  bytesWritten,eax

    pop ecx
    loop L1

    ; ���� �ݱ�
 	mov  eax,filehandle
    call CloseFile
 
	exit
main ENDP
END main