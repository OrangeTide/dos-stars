TOOLCHAIN_DIR= toolchain/
JWASM= $(TOOLCHAIN_DIR)jwasm
COMMAND.asm= $(JWASM) -q -bin $<
%.BIN: %.asm | $(JWASM)
	$(COMMAND.asm)
%.com: %.BIN
	mv $< $@
%/:
	mkdir -p $@
########################################################################
.PHONY:	all clean distclean test ci-test
E= stars.com num.com randpix.com hello.com
all:	$E
clean:
	$(RM) $E
ci-test: all
	SDL_VIDEODRIVER=dummy timeout -k1 10.0s dosbox -conf dosbox.conf
test:
	dosbox -noconsole -conf dosbox.conf
distclean: clean
	$(RM) $(TOOLS)
	rm -rf JWasm
########################################################################
# download and build JWasm automatically
$(TOOLCHAIN_DIR)jwasm: GIT_REPOS="https://github.com/JWasm/JWasm"
$(TOOLCHAIN_DIR)jwasm: | ${TOOLCHAIN_DIR}
	if [ \! -d "JWasm" ]; then git clone ${GIT_REPOS} ; fi
	make -C JWasm -f GccUnix.mak
	cp JWasm/GccUnixR/jwasm "$@"
