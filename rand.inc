;
; Pseudorandom number generator (PRNG) functions
; rand(), srand(), and initrand()
;
initrand:
	; set random seed according to system time
	push cx
	mov ah, 2Ch
	int 21h			; INT 21h, AH=2Ch - GET SYSTEM TIME
	mov ax, cx		; load AX with CX's hour, minute
				; DX = seconds and 1/100 seconds
	pop cx
srand:
	mov WORD PTR [rand_seed], ax
	mov WORD PTR [rand_seed + 2], dx
	ret
rand:
	; pseudo-random number generator
	;   rand_seed = (rand_seed * 214013 + 2531011) & 0x7fffffff;
	;   out = (rand_seed >> 16) & 0x7fff;
	; Return: DX:AX

	push bx
	push cx

	mov ax, 043FDh		; lower word of 214013
	mov bx, WORD PTR [rand_seed]	; load lower word of rand_seed
	imul WORD PTR [rand_seed]
	add ax, 09EC3h		; lower word of 2531011
	mov WORD PTR [rand_seed], ax	; dx:ax contains first step, save lower word
	mov cx, dx		; save dx from first step

	mov ax, 00003h		; upper word of 214013
	mov bx, WORD PTR [rand_seed + 2]	; load upper word of rand_seed
	imul bx
	mov dx, ax		; dx:ax contains second step, but we will discard dx
	add dx, cx		; add dx from second step

	add dx, 00026h		; upper word of 2531011
	and dx, 07FFFh		; upper word of 0x7fffffff
	mov WORD PTR [rand_seed + 2], dx	; save upper word

	pop cx
	pop bx

	ret

	rand_seed	dd	0
