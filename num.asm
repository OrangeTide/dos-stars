; num.asm - a  few ways to print numbers
; Copyright (C) 2020 by Jon Mayo <jon@rm-f.net>
; the BSD Zero Clause license
;

cpu 286
bits 16
org 100h

section .text
start:

	mov al, 89
	call printbyte		; can only print 00 to 99

	mov ax, 12345
	call printword		; prints a 16-bit unsigned WORD

	mov ax, 65535
	call printword		;

	mov ax, 0
	call printword		;

	int 20h

newline:
	mov ah, 02h
	mov dl, 10
	int 21h
	mov ah, 02h
	mov dl, 13
	int 21h
	ret

printbyte:	;	print a number from 0 to 99
	aam
	add ax, 3030h
	push ax
	mov dl, ah
	mov ah, 02h
	int 21h
	pop dx
	mov ah, 02h
	int 21h
	jmp newline

printword:
	lea bx, [scratch+20]	; bx is current position in scratch buffer
	dec bx			; scratch buffer is in reverse order
	mov BYTE [bx], '$'	; terminate string for INT 21h, 09h

.nextdigit:
	xor dx, dx
	mov cx, 10
	div cx

	add dl, 030h	; ASCII '0'
	dec bx		; scratch buffer is in reverse order
	mov [bx], dl	; add character to scratch buffer

	cmp ax, 0	; stop if working value is 0
	jz .done

	jmp .nextdigit
.done:
	mov dx, bx
	mov ah, 09h     ; INT 21h, 09h : Write string to STDOUT
	int 21h

	; ret
	jmp newline

section .data
section .bss
scratch:	resb 20
