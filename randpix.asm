; stars.asm - draw animated stars on DOS 16-bit real mode (assembler)
; Copyright (C) 2020 by Jon Mayo <jon@rm-f.net>
; the BSD Zero Clause license
;
include util.inc
include comprog.inc
.186
main:
	call save_mode

	call initrand
	call rand
	call rand
	call rand

	call set_game_mode
	call fillrand
	call delay
	call press_anykey
	call restore_mode
	jmp goodbye

fillrand:
	push es
	mov es, [video_seg]		; we'll use ES for our graphics plotting
	xor bx, bx
	xor si, si
nextline:				; for each row ...
	mov cx, 80			; 80 bytes = 320 pixels
	; todo calculate row address and load into BX
@@:					; for each column ...
	call rand
	mov es:[si], al			; put down 4 pixels on the even row
	call rand
	mov es:[si+2000h], al		; put down 4 pixels on the odd row

	inc si

	loop @B
	inc bx				; we processed 2 rows
	inc bx
	cmp bx, 200
	jle nextline

	pop es
	ret

goodbye:
	mov dx, OFFSET goodbye_msg
	dosint 09h	; INT 21h, AH = 09h - WRITE STRING TO STANDARD OUTPUT
	int 20h		; INT 20h : terminate

delay:
	dosint 2Ch		; INT 21h, AH = 2Ch - GET SYSTEM TIME
	mov bx, dx		; save seconds and 1/100th seconds result

	; check system time until a second or more has elapsed
@@::
	dosint 2Ch		; INT 21h, AH = 2Ch - GET SYSTEM TIME

	cmp dh, bh		; has the DH=second field changed since the first call
	jz @B

	ret

press_anykey:
	xor bh, bh	; Page = 0
	mov dh, 23	; Row
	xor dl, dl	; Column
	vbios 02h	; INT 10h, 02h : Set Cursor Position
	mov dx, OFFSET press_msg
	dosint 09h	; INT 21h, AH = 09h - WRITE STRING TO STANDARD OUTPUT
wait_anykey:
	xor ah, ah	; INT 16h, 00h : Read key press
	int 16h
	ret

include gamemode.inc
include rand.inc

; Variables
	press_msg	db	'Press Any Key ...', '$'
	goodbye_msg	db	10, 13, 'Thank you!', '$'

END
