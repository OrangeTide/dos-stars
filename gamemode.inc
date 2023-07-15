;
; game mode setting routines
;

save_mode:
	mov ah, 0Fh	; INT 10h, 0fh : Get Video Mode
	int 10h
	mov [saved_mode], al
	ret

set_game_mode:
	mov WORD PTR [video_seg], 0b800h
	mov es, [video_seg]	; we'll use ES for our graphics plotting
	; mov al, 4		; CGA 320x200, 4 color
	; mov bx, 0400h		; warm(0) palette mode
	; vbios 0Bh		; set CGA palette
	mov al, 5		; CGA 320x200, 4 color, mode 5 alternate palette
_set_mode:
	xor ah, ah		; INT 10h, 00h : Set Video Mode
	int 10h
	ret

restore_mode:
	mov al, [saved_mode]
	jmp _set_mode

wait_retrace:
;; TODO: do a better job and wait for a 0->1 transition
	mov dx, 03dah	; video status register
@@::
	in al, dx
	test al, 8	; bit 3 - vertical retrace
	jz @B		;; TODO: this is broken
	ret

; variables
	saved_mode	db	0
	video_seg	dw	0
