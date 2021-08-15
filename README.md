openbsd-custom-bootcd
---------------------

Build scripts for a customized OpenBSD ramdisk bootcd `customXX.iso`

The bootable installer is designed for use on a cloud provider, to
automatically install a lightly customized system.

The following modificiations have been made:

- Unattended installation using `auto_install.conf`
- system hostname `puffy`
- root password set
- user `admin` created with OpenSSH public key in `~/.ssh/authorized_keys`
- system packages downloaded from cdn.openbsd.org
- tty console enabled on boot
- `doas` enabled for `admin` 

---
### WARNING
The resulting boot CD will automatically install onto the first
hard drive.  Take care not to leave it in inappropriate places such
as the CDROM drive of your development system.

Any system allowed to boot from this CD will have its data *DESTRUCTIVELY OVERWRITTEN*.

YOU HAVE BEEN WARNED
---

### Prerequisites
Download OpenBSD source and build the system following the instructions
in the `release` man page.

- The makefile requires `gmake`

### References
 - https://www.openbsd.org/anoncvs.html
 - https://www.openbsd.org/faq/faq5.html
 - https://man.openbsd.org/release

### Instructions

This repo contains modified copies of files from the source tree at `/usr/src/`
These customizations were built for OpenBSD 6.9.  To customize another version
review the changes under `src/...` to determine any required changes.

The makefile is used to apply the changes to the source tree and build a
customized version of the ramdisk-based `cdXX.iso`

Rename the file `config.m4.template` to `config.m4`.  This is used to build the
`auto_install.conf` response file.

Fill in the XXXXXXXX fields with appropriate responses.
For details see: https://man.openbsd.org/autoinstall

To build the ISO image:
```
doas gmake
```

### Notes
patch `/usr/src/distrib/amd64/ramdisk_cd/list` to add files to the `bsd.rd` ramdisk
patch `/usr/src/distrib/amd64/ramdisk_cd/Makefile` to add files to the iso filesystem
