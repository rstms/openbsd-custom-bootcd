# openbsd-custom-bootcd

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
-----
### Caution!  This is a power tool with no safety guards.
The resulting boot CD will automatically install onto the first
hard drive.  Take care not to leave it in inappropriate places such
as the CDROM drive of your development system.

Any system allowed to boot from this CD will have its data *DESTRUCTIVELY OVERWRITTEN*.

YOU HAVE BEEN WARNED
-----
### Prerequisites
Download OpenBSD source and build the system following the instructions
in the `release` man page.

- The makefile requires `gmake`
-----
### References
 - https://www.openbsd.org/anoncvs.html
 - https://www.openbsd.org/faq/faq5.html
 - https://man.openbsd.org/release
-----
### Instructions

This repo contains modified copies of files from the source tree at `/usr/src/`
These customizations were built for OpenBSD 6.9.  To customize another version
review the changes under `src/...` to determine any required changes.

The makefile is used to apply the changes to the source tree and build a
customized version of the ramdisk-based `cdXX.iso`
-----
### Configuration 

The ISO may be configured with SSH keys and passwords for root and/or an admin user.
For details see: https://man.openbsd.org/autoinstall

The directory `env` is an `envdir`.  Each file name is a variable name
and the contents of the files are the values.

These env variables are used to create `auto_install.conf` from the
`auto_install.in` template.   A similar mechanism creates `boot-message`

Write response values to files in `env` with these names:
```
OPENBSD_MIRROR
ROOT_PASSWORD
ROOT_PUBLIC_KEY
ROOT_SSH_LOGIN
SET_SELECT
START_SSHD
SYSTEM_HOSTNAME
TIMEZONE
TTY_CONSOLE
TTY_SPEED
USER
USER_PASSWORD
USER_PUBLIC_KEY
X11_ENABLE
X11_XENODM
```
Example:
```
echo yes >env/ROOT_SSH_LOGIN
echo no >env/X11_ENABLE
echo no >env/X11_XENODM
cat ~/.ssh/id_ed25519.pub >env/USER_PUBLIC_KEY
```

Write appropriate values into each file. (see `man autoinstall`)  Put 
the actual password for root and the admin user in the envdir files.
The makefile will use `encrypt` to generate hash values for 
`auto_install.conf`
-----
### Build

To configure and build the ISO image:
```
gmake config
doas gmake build
```

### Notes
patch `/usr/src/distrib/amd64/ramdisk_cd/list` to add files to the `bsd.rd` ramdisk
patch `/usr/src/distrib/amd64/ramdisk_cd/Makefile` to add files to the iso filesystem
