TOOLCHAIN_DIR= toolchain/
TOOLS= $(TOOLCHAIN_DIR)jwasm
COMMAND.asm= $(TOOLCHAIN_DIR)jwasm -q -bin $<
%.BIN: %.asm | $(TOOLS)
	$(COMMAND.asm)
%.com: %.BIN
	mv $< $@
%/ :
	mkdir -p $@
########################################################################
.PHONY:	all clean test ci-test
all: stars.com num.com
clean:
	$(RM) stars.com num.com
ci-test: all
	SDL_VIDEODRIVER=dummy timeout -k1 10.0s dosbox -conf dosbox.conf
test:
	dosbox -noconsole -conf dosbox.conf
distclean: clean
	$(RM) $(TOOLS)
	rm -rf JWasm
########################################################################
$(TOOLCHAIN_DIR)jwasm: GIT_REPOS="https://github.com/JWasm/JWasm"
$(TOOLCHAIN_DIR)jwasm: | ${TOOLCHAIN_DIR}
	if [ \! -d "JWasm" ]; then git clone ${GIT_REPOS} ; fi
	make -C JWasm -f GccUnix.mak
	cp JWasm/GccUnixR/jwasm "$@"
