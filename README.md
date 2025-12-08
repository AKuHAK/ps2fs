# README.md

## PS2FS (version 0.9)

Copyright (c) 2002 Andrew Church <achurch@achurch.org>

## Overview

This driver allows read-only access to the PlayStation 2 filesystem under Linux.

## Requirements

* Linux Kernel 2.2 or 2.4
* **Kernel 2.2:** Requires a custom patch (see below) for read-only mounting of non-EXT2 filesystems. This patch is not required for 2.4 kernels.
* Tested on:
    * MIPS R5900 CPU (Kernel 2.2.1)
    * Pentium II (Kernel 2.4.18)
* **Not compatible with SMP systems.**

## Compilation

1. Download the source code (tar.gz archive).
2. Extract the archive.
3. Run `make`.  A configured and build-ready Linux kernel source tree (2.2 or 2.4) is required.
4. **Kernel 2.2:** Apply the necessary patch before compiling.
5. The driver compiles to `ps2fs.o`. Load it using `insmod`.
6. For PS2 kernels, statically linking the driver is recommended.

### MIPS Target Compilation

For MIPS targets (PlayStation 2), the module is compiled with kernel version 2.4.17_mvl21 by default. If you need to compile for a different kernel version (e.g., 2.4.27_mvl21), you can override this:

```bash
make mips MIPS_KERNEL_VERSION=2.4.27_mvl21
```

For kernel versions other than 2.4.17, you may also need to set the `MIPS_LINUX_VERSION_CODE`:

```bash
# For kernel 2.4.27: KERNEL_VERSION(2,4,27) = (2<<16) + (4<<8) + 27 = 132123
make mips MIPS_KERNEL_VERSION=2.4.27_mvl21 MIPS_LINUX_VERSION_CODE=132123
```

This ensures the compiled module matches your target kernel version and avoids "kernel-module version mismatch" errors during `insmod`.

## Mounting the Filesystem

The PS2 filesystem uses Linux-style partitions.  Mount using the `mount` command with the `partition=` option:

```bash
mount -t ps2fs -o ro,partition=__common /dev/hda /mnt/common
```

This mounts the "common" partition from `/dev/hda` to `/mnt/common` in read-only mode.

Using the loopback device:

```bash
losetup -o 1073741824 /dev/loop0 /dev/hda
mount -t ps2fs /dev/loop0 /mnt/common
```

This mounts the filesystem starting at offset 0x200000 (1073741824 bytes). You might need to use `ps2fdisk` to determine the correct offset.

On a PS2, partition assignments are predefined.

## Known Bugs/Limitations

* **Read-only:** Writing to the filesystem is not supported.
* **Maximum File Size:** Limited.
* **Directory Support:** Incomplete.


## Kernel Requirements

* **Offset:** Works with offsets of 0x400000 or higher. Lower offsets may cause issues.
* **Kernel Version:** Assumes a kernel version equal to or newer than the tested versions. Older kernels might not be supported.
* **Maximum Inodes:** 0x7FFF (32767)
* **Starting Inode Number:** 113
