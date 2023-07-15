; randpix.asm - fill the screen with random pixel in CGA mode
; Copyright (C) 2020-2023 by Jon Mayo <jon@rm-f.net>
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
	xor bx, bx			; row position
nextline:				; for each row ...
	; calculate row address and load into DI
	xor di, di
	mov ax, bx
	; pick odd or even row. set di to 8192 if (ax & 1) is set
	shr ax, 1
	sbb di, 0			; if C set, underflow to FFFFh, else 0
	and di, 2000h			; only save the upper bit at 8192
	; di = ax << 4 + ax << 2  ... ax * 20
	shl ax, 1
	shl ax, 1
	shl ax, 1
	shl ax, 1
	add di, ax
	shl ax, 1
	shl ax, 1
	add di, ax

	mov cx, 80			; process 80 bytes per row = 320 pixels
@@:					; do for each pixel in row ...
	call rand
	stosb				; put down 4 pixels on the selected row
					; equivalent to:
					; mov es:[di], al ...
					; inc di
	loop @B

	inc bx				; next row
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
