# Makefile for openbsd mirror tarball download
#
# requires gmake
#

MIRROR:= cdn.openbsd.org
MACHINE:=$(shell uname -m)
OSrev:=$(shell uname -r)
OSREV:=$(shell uname -r | tr -d .)
URL:= http://${MIRROR}/pub/OpenBSD/${OSrev}/${MACHINE}

verify: download
	@signify -C -p /etc/signify/openbsd-69-base.pub -x SHA256.sig

index := $$(tr <SHA256.sig \( \) | awk -F\) '/)/{print $$2}')

download: SHA256.sig
	@set -e;\
	for file in ${index}; do\
	  [ -e $$file ] || wget ${URL}/$$file;\
	done

SHA256.sig:
	@wget ${URL}/SHA256.sig

clean:
	rm -f ${index}
	rm -f SHA256.sig
