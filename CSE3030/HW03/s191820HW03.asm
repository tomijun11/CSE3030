TITLE s191820HW03.asm
comment #
Author : 20191820 김형준
data : 2020-05-08
function : key가 7이고 크기가 9인 Caesar cipher 암호문들의 decipher
Input : CSE3030_PHW03.inc 
Output : 0s191820_out.txt
#

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW03.inc

.data 
L BYTE "3456789012",0
COMMENT #
key = 7 이므로 cipher 된 문자
L = {0,1,2,3,4,5,6,7,8,9} 은 각각
L = {3,4,5,6,7,8,9,0,1,2} 로 변환하여 decipher 할 수 있다.
#

filename BYTE "0s191820_out.txt",0
filehandle HANDLE ?
buffer BYTE 9 DUP(?),0dh,0ah
BUFSIZE = $ - buffer
bytesWritten DWORD ?

.code
main PROC
    ; 파일 생성 및 열기
	mov  edx,OFFSET filename
    call CreateOutputFile
    mov  filehandle, eax
   
    mov edi, 0 ; edi = Cipher_Str의 상대 위치
    mov ecx, Num_Str

    L1: ; cipher 된 문자열 1개를 decipher한 후 파일에 출력 (L1) 
    push ecx
    
    mov ecx, 9 
    mov esi, 0 ; esi = buffer의 상대 위치
    
    L2: ; 1글자씩 decipher 해서 buffer에 저장(L2)
    mov ebx, 0
    mov bl, [Cipher_Str+edi] 
    inc edi
    sub bl, 30h
    mov bl, [L+ebx] ; ebx = 0 ~ +9 -> L의 값과 1:1 변환 (decipher)
    mov [buffer+esi], bl ; buffer에 decipher된 값 저장
    inc esi

    loop L2 

    inc edi ; 다음 Cipher된 문자열로 이동

    ; 버퍼에 입력된 문자열을 파일에 출력
    mov  eax,filehandle
    mov  edx,OFFSET buffer
    mov  ecx,BUFSIZE
    call WriteToFile
    mov  bytesWritten,eax

    pop ecx
    loop L1

    ; 파일 닫기
 	mov  eax,filehandle
    call CloseFile
 
	exit
main ENDP
END main