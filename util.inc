;
; Macros for my programs
;

; vbios <ah value> [ , <al value> ]
; calls INT 10h services
vbios		macro	ahval, alval
	ifnb <ahval>
	  ifnb <alval>
		mov ax, (ahval shl 8) + alval
	  else
		mov ah, ahval
	  endif
	endif
		int 10h
		endm

; dosint <ah value> [ , <al value> ]
; calls INT 21h services
dosint		macro	ahval, alval
	ifnb <ahval>
	  ifnb <alval>
		mov ax, (ahval shl 8) + alval
	  else
		mov ah, ahval
	  endif
	endif
		int 21h
		endm

