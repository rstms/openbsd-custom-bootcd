# Makefile for customized boot cd
#
# requires gmake
#

MACHINE:=$(shell uname -m)
OSrev:=$(shell uname -r)
OSREV:=$(shell uname -r | tr -d .)
build_user := $(shell stat -f '%u.%g' $(lastword $(MAKEFILE_LIST)))

.SUFFIXES: .s .patch
.s.patch:
	diff -u /usr/$(basename $<) $< >$@ || true

.SUFFIXES: .in .conf
.in.conf:
	m4 $< | awk 'NF' >$@

iso := custom${OSREV}.iso
tarball := site${OSREV}.tgz
tarball_files := $(shell find site -type f)
custom_files := $(shell find src -type f)
patch_files := $(custom_files:.s=.patch)
source_files := $(addprefix /usr/,$(basename $(custom_files)))
boot_files := auto_install.conf boot-message  
mirror_files := SHA256.sig INSTALL.${MACHINE} cdboot cdbr bsd bsd.rd \
	base${OSREV}.tgz comp${OSREV}.tgz game${OSREV}.tgz man${OSREV}.tgz xbase${OSREV}.tgz 

config: clean patch ${boot_files} mirror_verified

build: ${iso}

test:
	@echo MACHINE=${MACHINE}
	@echo OSrev=${OSrev}
	@echo OSREV=${OSREV}
	@echo tarball_files=${tarball_files}
	@echo boot_files=${boot_files}
	@echo mirror_files=${mirror_files}

mirror_verified: mirror
	${MAKE} -C mirror
	touch mirror_verified

patches: ${patch_files}

autoinstall: auto_install.conf

auto_install.conf: auto_install.in config.m4

define check_patch = 
	$(if $(shell grep '# custom-bootcd' $(1)),echo $(1) appears to be patched already.;,patch $(1) $(patsubst /usr/%,%.patch,$(1));)
endef

patch:	patches do_patch

do_patch: ${source_files}
	@$(foreach source,$^,$(call check_patch,$(source)))

define check_unpatch = 
	$(if $(shell grep '# custom-bootcd' $(1)),echo Unpatching $(1);mv $(1).orig $(1);,echo $(1) does not appear to be patched.;)
endef

unpatch: ${source_files}
	@$(foreach source,$^,$(call check_unpatch,$(source)))

${tarball}: ${tarball_files}
	$(require_root)
	chown -R root.wheel site
	chmod +x site/install.site
	tar czvf ${tarball} -C site .
	chown -R ${build_user} site;
	chown ${build_user} ${tarball}

tarball: ${tarball}

boot-message:
	m4 -DBUILD_HOST="$(shell uname -a)" -DBUILD_DATE="$(shell date)" <boot-message.in >boot-message

require_root = $(if $(shell [[ $$(id -u) = 0 ]] && echo root),,$(error requires root))
require_var = $(if $(shell [ -n "$${$(1)}" ] && echo ok),,$(error $(1) must be set))
require_mfs_mount = $(if $(shell df | grep '^mfs:.*$(1)$$'),,$(error $(1) must be mounted as mfs))

${iso}: tarball ${boot_files} $(addprefix mirror/,${mirror_files})
	$(require_root)
	$(call require_var,DESTDIR)
	$(call require_var,RELEASEDIR)
	$(call require_mfs_mount,/usr/dest)
	rm -rf /root/custom
	mkdir -p /root/custom/sets
	for file in ${boot_files} ${tarball}; do cp $$file /root/custom; done  
	for file in ${mirror_files}; do cp mirror/$$file /root/custom/sets; done  
	chown -R root.wheel /root/custom
	ksh -c 'cd /usr/src/etc;time make release'
	cp $$RELEASEDIR/cd${OSREV}.iso ${iso}
	chown ${build_user} ${iso}
	[ -n "$$UPLOAD_COMMAND" ] && $$UPLOAD_COMMAND

clean: unpatch
	rm -f ${patch_files} ${tarball} auto_install.conf boot-message

sterile: clean
	rm -f *.iso mirror_verified
	${MAKE} -C mirror clean
