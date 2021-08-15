# Makefile for customized boot cd
#
# requires gmake
#

MACHINE:=$(shell uname -m)
OSrev:=$(shell uname -r)
OSREV:=$(shell uname -r | tr -d .)

.SUFFIXES: .s .patch
.s.patch:
	diff -u /usr/$(basename $<) $< >$@ || true

.SUFFIXES: .in .conf
.in.conf:
	m4 $< | awk 'NF' >$@

tarball := site${OSREV}.tgz
tarball_files := $(shell find site -type f)
custom_files := $(shell find src -type f)
patch_files := $(custom_files:.s=.patch)
source_files := $(addprefix /usr/,$(basename $(custom_files)))
boot_files := auto_install.conf boot-message ${tarball} INSTALL.${MACHINE}
custom_boot_iso := custom${OSREV}.iso

iso:	${custom_boot_iso}

test:
	@echo MACHINE=${MACHINE}
	@echo OSrev=${OSrev}
	@echo OSREV=${OSREV}
	@echo tarball_files=${tarball_files}
	@echo boot_files=${boot_files}

verify:
	@[ $(MAKE) == 'gmake' ] || false # This Makefile requires gmake

patches: ${patch_files}

autoinstall: auto_install.conf

auto_install.conf: auto_install.in config.m4

define check_patch = 
	$(if $(shell grep '# custom-bootcd' $(1)),,patch $(1) $(patsubst /usr/%,%.patch,$(1));)
endef

patch: ${source_files}
	@$(foreach source,$^,$(call check_patch,$(source)))

define check_unpatch = 
	$(if $(shell grep '# custom-bootcd' $(1)),echo Unpatching $(1);mv $(1).orig $(1);,)
endef

unpatch: ${source_files}
	@$(foreach source,$^,$(call check_unpatch,$(source)))

require_root = $(if $(shell [[ $$(id -u) = 0 ]] && echo root),,$(error requires root))
require_var = $(if $(shell [ "$(1)" ] && echo ok),,$(error $(1) must be set))

${tarball}: ${tarball_files}
	$(call require_root)
	chown -R root.wheel site
	tar czvf ${tarball} -C site . 

tarball: ${tarball}

${custom_boot_iso}: verify patches patch tarball ${boot_files}
	$(call require_root)
	./build-release	${MACHINE} ${OSrev} ${OSREV} "${boot_files}"

boot-message:
	m4 \
	  -DBUILD_HOST="$(shell uname -a)"\
	  -DBUILD_USER="$(shell git config user.name) <$(shell git config user.email)>"\
	  -DBUILD_DATE="$(shell date)"\
	  <boot-message.in >boot-message

clean:
	rm -f ${patch_files}
	rm -f auto_install.conf
	rm -f ${tarball}
	rm -f boot-message
