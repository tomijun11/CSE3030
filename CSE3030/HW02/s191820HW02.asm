TITLE s191820HW02.asm
comment #
Author : 20191820 김형준
data : 2020-04-28
function : F = 30*x1 + 48*x2 + 14*x3 의 계산과 출력
Input : CSE3030_PHW02.inc (x1, x2, x3)
Output : F (= 30*x1 + 48*x2 + 14*x3)
#

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW02.inc

.code

main PROC
	; 30 = 32 - 2
	mov eax, x1  ; eax = x1
	add eax, eax ; eax *= 2
	mov ebx, eax ; ebx = 2*x1
	add eax, eax
	add eax, eax
	add eax, eax
	add eax, eax ; eax = 32*x1
	sub eax, ebx ; eax = 30*x1 (= 32*x1 - 2*x1)
	mov edx, eax ; F = 30*x1
	; 48 = 64 - 16
	mov eax, x2  ; eax = x2
	add eax, eax
	add eax, eax
	add eax, eax
	add eax, eax
	mov ebx, eax ; ebx = 16*x2
	add eax, eax
	add eax, eax ; eax = 64*x2
	sub eax, ebx ; eax = 48*x2 (= 64*x2 - 16*x2)
	add edx, eax ; F += 48*x2
	; 14 = 16 - 2
	mov eax, x3  ; eax = x3
	add eax, eax
	mov ebx, eax ; ebx = 2*x3
	add eax, eax
	add eax, eax
	add eax, eax ; eax = 16*x3
	sub eax, ebx ; eax = 14*x3 (= 16*x3 - 2*x3)
	add edx, eax ; F += 14*x3

	mov eax, edx ; print F = 30*x1 + 48*x2 + 14*x3
	call WriteInt

	exit
main ENDP
END main