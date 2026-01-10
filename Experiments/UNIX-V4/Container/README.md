# UNIX V4 Container (PDP-11 / SIMH)

This directory contains the container build assets required to run
**Research UNIX Version 4 (1973)** on a historically accurate **PDP-11**
emulation environment using **SIMH**.

This container provides the **emulation and runtime environment only**.
No UNIX source code, binaries, disk images, tapes, or ROMs are included.

A user-supplied, bootable UNIX V4 disk image must be provided at runtime.

---

## Contents

- `Dockerfile`  
  Builds a Debian-based container image with the SIMH PDP-11 emulator
  compiled from source.

- `unixv4.ini`  
  SIMH configuration file targeting a PDP-11/45 system with an RP-series
  disk controller, compatible with preserved UNIX V4 disk images.

- `entrypoint.sh`  
  Runtime entrypoint script that validates required media and launches
  the SIMH PDP-11 emulator.

- `README.md`  
  Container-specific documentation and usage notes.

---

## Media Requirements

This container does **NOT** include UNIX V4 disk or tape images.

At runtime, you must mount a **bootable UNIX V4 disk image** at:

/data/unixv4.dsk


## Disk Image Expectations

The disk image must:

Be a raw PDP-11 disk image compatible with SIMH

Contain an installed Research UNIX Version 4 filesystem

Be suitable for attachment as an RP-series disk (e.g., RP03/RP04)

The reference image used during development was preserved by the
University of Utah and distributed via the Internet Archive.


## Runtime Behavior
Runtime Behavior

On container startup:

The entrypoint script verifies the presence of /data/unixv4.dsk

SIMH is launched using the configuration in unixv4.ini

The PDP-11 boots from the attached RP disk (rp0)

Research UNIX Version 4 starts and presents a console interface

If SIMH drops to its prompt instead of booting automatically, you may
manually issue:

boot rp0

## Usage Example
```
docker run -it --rm \
  -v ~/unix-v4-data:/data \
  unix-v4:latest
```

## Educational and Archival Use

This container exists strictly for historical, educational, and archival
experimentation.

Users are responsible for ensuring that any UNIX V4 media they supply:

Was obtained from a lawful source

Is used in compliance with applicable licenses and agreements

Is not redistributed unlawfully

This project intentionally separates emulation infrastructure from
copyrighted historical software artifacts.

## Historical Note

Research UNIX Version 4 predates standardized installation procedures.
Runnable disk images are rare, and preserved artifacts may require
hardware-specific emulation parameters.

This container reflects a best-effort, historically grounded environment
suitable for modern archival experimentation.
