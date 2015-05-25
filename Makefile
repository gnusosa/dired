#=======================================================================
# Makefile for dired 3.05.  Generates BSD 4.2 UNIX version as is.
#
# Command-line macros:
#	BINDIR=directory-to-install-executable-in
#	MANDIR=directory-to-install-man-pages-in
#	MINFILES=minimum-number-of-files-preallocatted
#	MOREPGM=name-of-more-or-less-or-pager
#	EXTRADEFINES=-Dxyz -Dxxx ...
#	OPT=compiler-optimization
#
# Major Targets:
#	all		build everything
#	clean		remove temp and object files
#	clobber		remove all automatically-regenerable files
#	dired		build everything
#	install		install executable and man pages
#	install-exe	install executable
#	install-man	install man pages
#	uninstall	uninstall executable and man pages
#	uninstall-exe	uninstall executable
#	uninstall-man	uninstall man pages
#
# Convenience targets for particular systems:
#	aixps2		dired for IBM PC AIX PS/2
#	aix370		dired for IBM 370-family mainframe AIX 370
#	alpha		dired for DEC Alpha AXP systems on OSF/1
#	alpha-gcc		dired for DEC Alpha AXP systems on OSF/1
#	convex-c1	dired for Convex C1
#	fips		dired for FIPS 151-1
#	hpux		dired for HP-UX 9.0 (HP 9000/7xx)
#	ibm-rs6000	dired for IBM RS/6000 AIX 3.1 and 3.2
#	linux		dired for linux 1.2.8 or later and gcc
#	mips		dired for MIPS RC/6280 RISCos 2.1.1
#	next		dired for NeXT Mach 3.0
#	posix		dired for POSIX.1
#	sgi4		dired for Silicon Graphics IRIX 4.0.x
#	sgi		dired for Silicon Graphics IRIX 5.x
#	stdc		dired for ANSI/ISO Standard C
#	sun		dired for Sun 3, 386i, 4 SunOS 4.x
#	sun-gcc		dired for Sun 3, 386i, 4 SunOS 4.x with gcc
#	sun-solaris	dired for Sun Solaris 2.x
#	sun-solaris-gcc	dired for Sun Solaris 2.x with gcc
#	ultrix		dired for DECstation ULTRIX 4.x
#	xpg3		dired for XPG3
#
# [2-January-1997]
#=======================================================================

#local pathname for installed version
BINDIR          = /usr/local/bin

CC              = cc

CFLAGS          = $(OPT) $(DEFINES) \
			-DMINFILES=$(MINFILES) \
			-DMOREPGM=\"$(MOREPGM)\"

CP              = /bin/cp

DEFINES		= -DHAVE_TERMIOS_H -DHAVE_DIRENT_H

DIREDFILE	= $(BINDIR)/dired

GCCFLAGS	= -Wall -Wshadow -Wcast-qual -Wpointer-arith \
		  -Wwrite-strings -W -Wtraditional -Wid-clash-8 \
		  -Wbad-function-cast -Wconversion -Waggregate-return \
		  -Wstrict-prototypes -Wmissing-prototypes \
		  -Wmissing-declarations -Wredundant-decls \
		  -Wnested-externs -Winline
GCCFLAGS	=-fno-builtin -s

# A few systems need -lcurses too, but usually just -ltermlib suffices
LIBS            = -lcurses -ltermlib
LIBS            = -ltermlib

MANDIR          = /usr/local/man/man1

MANEXT          = 1

MINFILES        = 100

# less is better than most alternatives:
MOREPGM         = /bin/pg
MOREPGM         = /usr/ucb/more
MOREPGM         = /usr/local/bin/less

OPT             = -g
OPT             = -O

RM              = /bin/rm -f

SHELL           = /bin/sh

ECHO            = /bin/echo

# Use echo if your system lacks strip
STRIP		= echo
STRIP		= strip

#=======================================================================

.SUFFIXES:
.SUFFIXES: .o .i .c

.c.i:
	$(CC) $(CFLAGS) -E $*.c >$*.i

.c.o:
	$(CC) $(CFLAGS) -c $*.c

#=======================================================================

notarget:
	@echo "Makefile for dired 3.05 (January 1997)"
	@echo "Usage: make target"
	@echo "Main Targets:"
	@echo "aixps2   aix370   alpha   alpha-gcc   convex-c1   fips"
	@echo "posix    stdc     xpg3    hpux        ibm-rs6000  mips"
	@echo "next     sgi4     sgi     sun         sun-gcc     sun-solaris"
	@echo "sun-solaris-gcc   ultrix  linux       dired"
	@echo "Other Targets: "
	@echo "clean           remove temp and object files"
	@echo "clobber         remove all automatically-regenerable files"
	@echo "install-exe     install executable as $(DIREDFILE)"
	@echo "install-man     install man pages to $(MANDIR)"
	@echo "install         install executable and man pages"
	@echo "uninstall       uninstall executable and man pages"
	@echo "uninstall-exe   uninstall executable"
	@echo "uninstall-man   uninstall man pages"

all:	dired

clean mostlyclean:
	-$(RM) *.i
	-$(RM) *.o
	-$(RM) *~
	-$(RM) \#*
	-$(RM) core

clobber distclean realclean:	clean
	-$(RM) dired

dired: dired.o regexpr.o
	$(CC) $(CFLAGS) -o dired dired.o regexpr.o $(LIBS)

install:	dired install-exe install-man

install-exe:
	$(CP) dired $(DIREDFILE)
	$(STRIP) $(DIREDFILE)
	chmod 755 $(DIREDFILE)

install-man:
	-$(RM) $(MANDIR)/../cat$(MANEXT)/dired.$(MANEXT)
	$(CP) dired.1 $(MANDIR)
	chmod 644 $(MANDIR)/dired.$(MANEXT)

regexpr.o:	regexpr.c regexpr.h

uninstall:	uninstall-exe uninstall-man

uninstall-exe:
	-$(RM) $(DIREDFILE)

uninstall-man:
	-$(RM) $(MANDIR)/../cat$(MANEXT)/dired.$(MANEXT)
	-$(RM) $(MANDIR)/dired.$(MANEXT)

#=======================================================================
# Machine-specific convenience targets

TARGETS	= all

# This target untested for dired 3.00
aixps2 aix370:
	$(MAKE) \
		DEFINES='-DHAVE_TERMIOS_H' \
		LIBS='-ltermlib' \
		OPT='$(OPT)' \
		$(TARGETS)

alpha:
	$(MAKE) \
		DEFINES='-DHAVE_DIRENT_H -D_BSD -DANSICOLOUR' \
		OPT='$(OPT)' \
		LIBS='-lcurses -ltermlib' \
		$(TARGETS)

alpha-gcc:
	$(MAKE) \
		CC='gcc' \
		DEFINES='-DHAVE_DIRENT_H -D_BSD -DANSICOLOUR' \
		OPT='$(OPT) $(GCCFLAGS)' \
		LIBS='-lcurses -ltermlib' \
		$(TARGETS)

# C1 dired will also run on a C2; the reverse is NOT true.
convex-c1:
	$(MAKE) \
		DEFINES='-Ddirent=direct' \
		MOREPGM=/usr/ucb/more \
		OPT='$(OPT)' \
		$(TARGETS)

# FIPS 151-1. POSIX.1.  ANSI/ISO Standard C.  SunOS 4.1.x.  XPG3.
fips posix stdc xpg3 hpux:
	$(MAKE)	\
		DEFINES='-DHAVE_TERMIOS_H -DHAVE_DIRENT_H' \
		LIBS='-ltermlib' \
		OPT='$(OPT)' \
		$(TARGETS)

ibm-rs6000:
	$(MAKE) LIBS='-lcurses -ltermcap' \
		DEFINES='-DHAVE_TERMIOS_H -DHAVE_DIRENT_H' \
		OPT='$(OPT)' \
		$(TARGETS)

# MIPS RC/6280 RISCos 2.1.1
mips:
	$(MAKE)	\
		DEFINES='-DHAVE_TERMIOS_H -DHAVE_DIRENT_H -DHAVE_MKDEV_H -DHAVE_VOID_HANDLER' \
		LIBS='-ltermlib' \
		OPT='-systype svr4 $(OPT)' \
		$(TARGETS)

# NeXT Mach 3.0
next:
	$(MAKE) \
		DEFINES='-DHAVE_GETWD -DHAVE_OPENDIR' \
		OPT='$(OPT)' \
		$(TARGETS)

# Silicon Graphics IRIX 4.0.x
sgi4:
	$(MAKE) \
		DEFINES='-DHAVE_TERMIOS_H -DHAVE_DIRENT_H -DHAVE_VOID_HANDLER' \
		LIBS='-ltermlib -lbsd' \
		OPT='$(OPT)' \
		$(TARGETS)

# Silicon Graphics IRIX 5.x
sgi:
	$(MAKE) \
		DEFINES='-DHAVE_TERMIOS_H -DHAVE_DIRENT_H -DHAVE_MKDEV_H -DANSICOLOUR' \
		LIBS='-ltermlib -lbsd' \
		OPT='$(OPT)' \
		$(TARGETS)

# SunOS 3.x.x and 4.x.x in Berkeley environment
# Color defined for remote linux clients using kermit
sun:
	$(MAKE) \
		DEFINES='-DHAVE_DIRENT_H -DANSICOLOUR' \
		OPT='$(OPT)' \
		$(TARGETS)

# SunOS 3.x.x and 4.x.x in Berkeley environment
# Color defined for remote clients using kermit /w color monitor
sun-gcc:
	$(MAKE) \
		DEFINES='-DHAVE_DIRENT_H -DANSICOLOUR' \
		CC='gcc' \
		OPT='$(OPT) $(GCCFLAGS)' \
		$(TARGETS)

sun-solaris:
# Works on SunOS 5.5 Generic sun4c sparc SUNW,Sun_4_75 /w 2.3 curses.h
	$(MAKE) \
	DEFINES='-DSOLARIS=1 -DHAVE_TERMIOS_H -DHAVE_DIRENT_H -DHAVE_MKDEV_H -DANSICOLOUR' \
		OPT='$(OPT)' \
		$(TARGETS)

sun-solaris-gcc:
	$(MAKE) \
	DEFINES='-DHAVE_DIRENT_H -DHAVE_MKDEV_H -DHAVE_TERMIOS_H -DANSICOLOUR' \
		CC='gcc' \
		OPT='$(OPT) $(GCCFLAGS)' \
		$(TARGETS)

# DECstation ULTRIX 4.2
ultrix:
	$(MAKE) \
		DEFINES='-DHAVE_DIRENT_H -DANSICOLOUR' \
		OPT='$(OPT)' \
		$(TARGETS)

# Linux kernel 1.2.8 with gcc 2.6.3, 386/486 hardware
# Linux kernel 1.2.13 or 1.3.18 with gcc 2.7.0, 386/486 hardware
# Linux kernel 2.0 with gcc 2.7.2, 386/486 hardware
# Ansi color defined by default in dired.c
linux:
	$(MAKE) \
		MOREPGM='/usr/bin/less'\
		DEFINES='-DHAVE_DIRENT_H -DHAVE_TERMIOS_H' \
		LIBS='-lbsd -ltermcap'\
		OPT='$(OPT) $(GCCFLAGS)' \
		$(TARGETS)
	@ls -l dired
	@echo " "
	@echo If you use \"make install\", then the target directories will
	@echo be selected to default directories $(BINDIR) and $(MANDIR).
	@echo The targets /bin and /var/man/cat1 are compatible with
	@echo live file systems and boot floppy rescue disks. Manual
	@echo copy is necessary to get these non-standard targets.
#=======================================================================
