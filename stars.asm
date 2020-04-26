; stars.asm - draw animated stars on DOS 16-bit real mode (assembler)
; Copyright (C) 2020 by Jon Mayo <jon@rm-f.net>
; the BSD Zero Clause license
;
cpu 286
bits 16
org 100h
num_stars:	equ	40
section .text
start:
	; set random seed = 0
	xor ax, ax
	xor dx, dx
	call srand

	call save_mode
	call set_game_mode
	call initialize_stars
	call plot_stars		; plot current state
	call do_frame
	call do_frame
	call do_frame
	call do_frame
	call do_frame
; TODO: need to add as a non-interactive option for `make ci-test`
;	call press_anykey
	call restore_mode
	jmp goodbye
initialize_stars:
	mov cx, num_stars
	mov si, stars
.loop:
	call rand
	and ax, 07fh		; restrict Y axis to 0-127
	mov dx, 80		; multiply by screen pitch (80 bytes)
	mul dx
	mov [si+2], ax		; save star_y[i]

	call rand
	and ax, 03fh		; restrict X axis to 0-63
	mov [si+0], ax		; save star_x[i]

	add si, 4		; 2+2 ; record size of stars[]
	loop .loop
	ret
do_frame:

erase_stars:
	mov cx, num_stars
	mov si, stars
.loop:
	mov ax, [si+0]		; load star_x[i]
	mov bx, [si+2]		; load star_y[i]
	add bx, ax		; add x + y
	mov WORD [es:bx], 00h	; erase star
	add si, 4		; 2+2 ; record size of stars[]
	loop .loop

update_stars:
	mov cx, num_stars
	mov si, stars
.loop:
	inc WORD [si+0]		; update star_x[i] ; TODO: use xrate
	; TODO: regenerate stars that fall off the screen
;	add [si+2], 80		; increment star_y[i]
	add si, 4		; 2+2 ; record size of stars[]
	loop .loop

	call wait_retrace

plot_stars:
	mov cx, num_stars
	mov si, stars
.loop:
	;; TODO: shift the pixel for X movement
	mov ax, [si+0]		; load star_x[i]
	mov bx, [si+2]		; load star_y[i]
	add bx, ax		; add x + y
	mov WORD [es:bx], 03h	; plot star
	add si, 4		; 2+2 ; record size of stars[]
	loop .loop

delay:
	;; TODO: replace this 286/AT only code with something for PC and XT
	mov ah, 86h		; INT 15h, 86h - Wait
	mov cx, 07h
	mov dx, 0A120h		; 7a120 = 500,000 ; F4240 = 1,000,000 microseconds
	int 15h

	ret

wait_retrace:
;; TODO: do a better job and wait for a 0->1 transition
	mov dx, 03dah	; video status register
.loop:
	in al, dx
	test al, 8	; bit 3 - vertical retrace
	jz .loop ;; TODO: this is broken
	ret
press_anykey:
	mov ah, 02h	; INT 10h, 02h : Set Cursor Position
	xor bh, bh	; Page = 0
	mov dh, 23	; Row
	xor dl, dl	; Column
	int 10h
	mov dx, press_msg
	mov ah, 09h	; INT 21h, 09h : Write string to STDOUT
	int 21h
wait_anykey:
	xor ah, ah	; INT 16h, 00h : Read key press
	int 16h
	ret
save_mode:
	mov ah, 0fh	; INT 10h, 0fh : Get Video Mode
	int 10h
	mov [saved_mode], al
	ret
set_game_mode:
	mov WORD [video_seg], 0b800h
	mov es, [video_seg]	; we'll use ES for our graphics plotting
	mov al, 4	; CGA 320x200, 4 color
_set_mode:
	xor ah, ah	; INT 10h, 00h : Set Video Mode
	int 10h
	ret
restore_mode:
	mov al, [saved_mode]
	jmp _set_mode
goodbye:
	mov dx, goodbye_msg
	mov ah, 09h	; INT 21h, 09h : Write string to STDOUT
	int 21h
	int 20h
srand:
	mov [rand_seed], ax
	mov [rand_seed + 2], dx
	ret
rand:
	; pseudo-random number generator
	;   rand_seed = (rand_seed * 214013 + 2531011) & 0x7fffffff;
	;   out = (rand_seed >> 16) & 0x7fff;
	; Return: DX:AX

	push bx
	push cx

	mov ax, 043fdh		; lower word of 214013
	mov bx, [rand_seed]	; load lower word of rand_seed
	imul WORD [rand_seed]
	add ax, 09ec3h		; lower word of 2531011
	mov [rand_seed], ax	; dx:ax contains first step, save lower word
	mov cx, dx		; save dx from first step

	mov ax, 00003h		; upper word of 214013
	mov bx, [rand_seed + 2]	; load upper word of rand_seed
	imul bx
	mov dx, ax		; dx:ax contains second step, but we will discard dx
	add dx, cx		; add dx from second step

	add dx, 00026h		; upper word of 2531011
	and dx, 07fffh		; upper word of 0x7fffffff
	mov [rand_seed + 2], dx	; save upper word

	pop cx
	pop bx

	ret
section .data
	press_msg db 'Press Any Key ...$'
	goodbye_msg db 'Thank you!'
	crlf db 13, 10,'$'
section .bss
rand_seed:	resd 1
saved_mode:	resb 1
video_seg:	resb 2
stars		resb (2+2)*num_stars
	; +0	star_x
	; +2	star_y
	; TODO: star_xrate
