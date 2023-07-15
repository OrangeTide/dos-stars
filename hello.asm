include util.inc
include comprog.inc
	mov dx, OFFSET goodbye_msg
	dosint 09h	; INT 21h, 09h : Write string to STDOUT
	int 20h
	goodbye_msg db 'Hello World!', '$'
END
