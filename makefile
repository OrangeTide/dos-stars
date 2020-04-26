%.com : %.asm
	nasm $< -fbin -o $@
########################################################################
.PHONY : all clean test ci-test
all : stars.com
clean :
	$(RM) stars.com
ci-test :
	SDL_VIDEODRIVER=dummy timeout -k1 10.0s dosbox -conf dosbox.conf
test :
	dosbox -noconsole -conf dosbox.conf
