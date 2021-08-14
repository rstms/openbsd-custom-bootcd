# Makefile for customized boot cd
#
# requires gmake
#

src = /usr/src/distrib/$(shell uname -m)/ramdisk_cd

sources = $(shell find src -type f)
patches = $(sources:.s=.p)

test:
	@echo sources=${sources}
	@echo patches=${patches}

verify:
	@[ $(MAKE) == 'gmake' ] || (echo 'This Makefile requires gmake'; false)

.SUFFIXES: .s .p
.s.p:
	@echo diff -u /usr/$(basename $<) $< >$@

patch: $(patches)
	ls $<
