#	$OpenBSD: list,v 1.2 2019/06/08 17:10:57 sthen Exp $

SRCDIRS distrib/special

# copy the crunched binary, link to it, and kill it
COPY	${OBJDIR}/instbin			instbin
LINK	instbin					bin/arch
LINK	instbin					bin/cat
LINK	instbin					bin/chmod bin/chgrp sbin/chown
LINK	instbin					bin/cp
LINK	instbin					bin/date
LINK	instbin					bin/dd
LINK	instbin					bin/df
LINK	instbin					bin/ed
LINK	instbin					bin/hostname
LINK	instbin					bin/ksh bin/sh
LINK	instbin					bin/ln
LINK	instbin					bin/ls
LINK	instbin					bin/md5 bin/sha256 bin/sha512
LINK	instbin					bin/mkdir
LINK	instbin					bin/mt bin/eject
LINK	instbin					bin/mv
LINK	instbin					bin/pax bin/tar
LINK	instbin					bin/rm
LINK	instbin					bin/sleep
LINK	instbin					bin/stty
LINK	instbin					bin/sync
LINK	instbin					sbin/bioctl
LINK	instbin					sbin/dhclient
LINK	instbin					sbin/disklabel
LINK	instbin					sbin/dmesg
LINK	instbin					sbin/fdisk
LINK	instbin					sbin/fsck
LINK	instbin					sbin/fsck_ffs
LINK	instbin					sbin/fsck_msdos
LINK	instbin					sbin/growfs
LINK	instbin					sbin/ifconfig
LINK	instbin					sbin/init
LINK	instbin					sbin/kbd
LINK	instbin					sbin/mknod
LINK	instbin					sbin/mount
LINK	instbin					sbin/mount_cd9660
LINK	instbin					sbin/mount_ext2fs
LINK	instbin					sbin/mount_ffs
LINK	instbin					sbin/mount_msdos
LINK	instbin					sbin/mount_nfs
LINK	instbin					sbin/mount_udf
LINK	instbin					sbin/newfs
LINK	instbin					sbin/newfs_msdos
LINK	instbin					sbin/ping sbin/ping6
LINK	instbin					sbin/reboot sbin/halt
LINK	instbin					sbin/restore
LINK	instbin					sbin/route
LINK	instbin					sbin/slaacd
LINK	instbin					sbin/sysctl
LINK	instbin					sbin/umount
LINK	instbin					usr/bin/doas
LINK	instbin					usr/bin/encrypt
LINK	instbin					usr/bin/grep usr/bin/egrep usr/bin/fgrep
LINK	instbin					usr/bin/gzip usr/bin/gunzip usr/bin/gzcat
LINK	instbin					usr/bin/more usr/bin/less
LINK	instbin					usr/bin/sed
LINK	instbin					usr/bin/signify
LINK	instbin					usr/bin/tee
LINK	instbin					usr/sbin/chroot
LINK	instbin					usr/sbin/installboot
LINK	instbin					usr/sbin/pwd_mkdb
ARGVLINK ksh					-sh
SPECIAL	rm bin/md5

SPECIAL awk -f ${UTILS}/trimcerts.awk ${DESTDIR}/etc/ssl/cert.pem etc/ssl/cert.pem
LINK	instbin					usr/bin/ftp-ssl usr/bin/ftp
SPECIAL	rm usr/bin/ftp-ssl

COPY	${DESTDIR}/etc/firmware/kue		etc/firmware/kue

COPY	${DESTDIR}/etc/firmware/bnx-b06		etc/firmware/bnx-b06
COPY	${DESTDIR}/etc/firmware/bnx-b09		etc/firmware/bnx-b09
COPY	${DESTDIR}/etc/firmware/bnx-rv2p	etc/firmware/bnx-rv2p
COPY	${DESTDIR}/etc/firmware/bnx-xi-rv2p	etc/firmware/bnx-xi-rv2p
COPY	${DESTDIR}/etc/firmware/bnx-xi90-rv2p	etc/firmware/bnx-xi90-rv2p

COPY	${DESTDIR}/etc/firmware/ral-rt2561	etc/firmware/ral-rt2561
COPY	${DESTDIR}/etc/firmware/ral-rt2561s	etc/firmware/ral-rt2561s
COPY	${DESTDIR}/etc/firmware/ral-rt2661	etc/firmware/ral-rt2661
COPY	${DESTDIR}/etc/firmware/ral-rt2860	etc/firmware/ral-rt2860
COPY	${DESTDIR}/etc/firmware/ral-rt3290	etc/firmware/ral-rt3290
COPY	${DESTDIR}/etc/firmware/rum-rt2573	etc/firmware/rum-rt2573
COPY	${DESTDIR}/etc/firmware/run-rt2870	etc/firmware/run-rt2870
COPY	${DESTDIR}/etc/firmware/run-rt3071	etc/firmware/run-rt3071

COPY	${DESTDIR}/etc/firmware/zd1211		etc/firmware/zd1211
COPY	${DESTDIR}/etc/firmware/zd1211b		etc/firmware/zd1211b

# for fdisk(8)
COPY	${DESTDIR}/usr/mdec/mbr			usr/mdec/mbr

# copy the MAKEDEV script and make some devices
SCRIPT	${DESTDIR}/dev/MAKEDEV			dev/MAKEDEV
SPECIAL	cd dev; sh MAKEDEV ramdisk

# various files that we need in /etc for the install
COPY	${CURDIR}/../../miniroot/group		etc/group
COPY	${CURDIR}/../../miniroot/master.passwd	etc/master.passwd
SPECIAL	pwd_mkdb -p -d etc master.passwd; rm etc/master.passwd
COPY	${DESTDIR}/etc/signify/openbsd-${OSrev}-base.pub	etc/signify/openbsd-${OSrev}-base.pub
COPY	${CURDIR}/../../miniroot/protocols	etc/protocols
COPY	${CURDIR}/../../miniroot/services	etc/services
TERMCAP	vt100,vt220,dumb			usr/share/misc/termcap

SYMLINK	/tmp/i/fstab.shadow			etc/fstab
SYMLINK	/tmp/i/resolv.conf.shadow		etc/resolv.conf
SYMLINK	/tmp/i/hosts				etc/hosts

# and the installation tools
SCRIPT	${CURDIR}/../../miniroot/dot.profile	.profile
SCRIPT	${CURDIR}/../../miniroot/install.sub	install.sub
SCRIPT	${CURDIR}/../common/install.md		install.md
SPECIAL	chmod 755 install.sub
SYMLINK	install.sub				autoinstall
SYMLINK	install.sub				install
SYMLINK	install.sub				upgrade

# custom-bootcd-begin
COPY /root/custom/auto_install.conf		auto_install.conf
COPY /root/custom/site.tgz			${OSrev}/amd64/site${OSrev}.tgz
# custom-bootcd-end

TZ
