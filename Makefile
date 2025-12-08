#
# Makefile for the PS2 filesystem routines.
#

CC = gcc
MIPS_CC = mipsEEel-linux-gcc
MIPS_LD = mipsEEel-linux-ld
# Default kernel version for MIPS target (can be overridden with MIPS_KERNEL_VERSION=2.4.27_mvl21)
MIPS_KERNEL_VERSION ?= 2.4.17_mvl21
# LINUX_VERSION_CODE for kernel 2.4.17 (needed for version checks in source code)
MIPS_LINUX_VERSION_CODE ?= 132113
BASE_CFLAGS = -g -D__KERNEL__ -I/usr/src/linux/include -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fomit-frame-pointer -DMODULE
OBJS = bitmap.o dir.o inode.o misc.o partition.o super.o unicode.o

all: $(shell uname -m)

i386 i486 i586 i686 x86_64:
	$(MAKE) ps2fs.o CFLAGS="$(BASE_CFLAGS) -fno-strict-aliasing -fno-common -pipe -mpreferred-stack-boundary=2 -march=i686 -DEXPORT_SYMTAB"

mips:
	$(MAKE) ps2fs.o CC="$(MIPS_CC)" LD="$(MIPS_LD)" CFLAGS="$(BASE_CFLAGS) -G 0 -mno-abicalls -fno-pic -mcpu=r5900 -mips1 -pipe -mlong-calls -DUTS_RELEASE=\"$(MIPS_KERNEL_VERSION)\" -DLINUX_VERSION_CODE=$(MIPS_LINUX_VERSION_CODE)"


clean:
	-rm -f *.o


ps2fs.o: $(OBJS)
	$(LD) -r -o $@ $(OBJS)

$(OBJS): ps2fs_fs.h Makefile
dir.o inode.o             super.o: ps2fs_fs_sb.h
dir.o inode.o                    : ps2fs_fs_i.h
              partition.o super.o: ps2_partition.h

