# UNIX V5 Container

This directory contains the container build assets required to run
Research UNIX Version 5 on a PDP-11 emulator (SIMH).

UNIX Version 5 (circa 1974–1975) is used as the runnable baseline due to the
availability of preserved, bootable PDP-11 disk images suitable for emulation.
UNIX Version 4 is acknowledged as historical lineage but is not executed
directly by this container.

## Contents

- `Dockerfile`  
  Builds a Debian-based container with the SIMH PDP-11 emulator.

- `unixv5.ini`  
  SIMH configuration for Research UNIX Version 5, targeting a PDP-11/45
  with an RK05 disk subsystem.

- `entrypoint.sh`  
  Runtime entrypoint that validates required media and launches SIMH.

## Media Requirements

This container does **NOT** include UNIX V5 disk or tape images.

At runtime, you must mount a bootable UNIX V5 RK05 disk image at:

```text
/data/unixv5.dsk
