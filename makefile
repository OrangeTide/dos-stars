%.com : %.asm
	nasm $< -fbin -o $@
########################################################################
all : stars.com
clean :
	$(RM) stars.com
