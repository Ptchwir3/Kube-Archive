#!/bin/sh
set -e

DISK_IMAGE="/data/unixv5.dsk"

if [ ! -f "$DISK_IMAGE" ]; then
  echo "ERROR: UNIX V4 disk image not found at $DISK_IMAGE"
  echo "See Experiments/UNIX-V4/README.md for acquisition instructions."
  exit 1
fi

echo "Starting SIMH PDP-11 with Research UNIX V4..."
exec /usr/local/bin/pdp11 /simh/unixv5.ini
