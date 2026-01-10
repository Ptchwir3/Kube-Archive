#!/bin/sh
set -eu

MODE="${MODE:-boot}"          # boot | install
DATA_DIR="${DATA_DIR:-/data}"
INI_BOOT="/simh/unixv4-boot.ini"
INI_INSTALL="/simh/unixv4-install.ini"

echo "[unixv4] SIMH PDP-11 container starting..."
echo "[unixv4] MODE: ${MODE}"
echo "[unixv4] DATA: ${DATA_DIR}"
ls -lah "${DATA_DIR}" || true

case "$MODE" in
  install)
    # Install mode: boot from tape to create disk image
    [ -f "${DATA_DIR}/unix_v4.tap" ] || {
      echo "[unixv4] ERROR: missing ${DATA_DIR}/unix_v4.tap"
      exit 1
    }
    echo "[unixv4] Using install INI: ${INI_INSTALL}"
    echo "[unixv4] Interactive install - at '=' prompt:"
    echo "[unixv4]   Type: mcopy"
    echo "[unixv4]   Then: k"
    echo "[unixv4]   disk offset: 0"
    echo "[unixv4]   tape offset: 75"
    echo "[unixv4]   count: 4000"
    echo "[unixv4]   Then: uboot"
    echo "[unixv4]   Then: k"
    echo "[unixv4]   Then: unix"
    exec /usr/local/bin/pdp11 "${INI_INSTALL}"
    ;;

  boot)
    # Boot mode: boot from pre-installed disk image
    # First check for disk.rk (squoze.net turnkey), then unixv4.rk
    if [ -f "${DATA_DIR}/disk.rk" ]; then
      DISK_FILE="disk.rk"
    elif [ -f "${DATA_DIR}/unixv4.rk" ]; then
      DISK_FILE="unixv4.rk"
    else
      echo "[unixv4] ERROR: missing disk image"
      echo "[unixv4] Need either ${DATA_DIR}/disk.rk or ${DATA_DIR}/unixv4.rk"
      echo "[unixv4] Hint: download disk.rk from http://squoze.net/UNIX/v4/disk.rk"
      echo "[unixv4] Or run install first: -e MODE=install"
      exit 1
    fi

    # Update INI with correct disk filename
    sed "s|/data/disk.rk|/data/${DISK_FILE}|g" "${INI_BOOT}" > /tmp/boot.ini

    echo "[unixv4] Using boot INI with disk: ${DISK_FILE}"
    echo "[unixv4] At '=' prompt, type: k"
    echo "[unixv4] Then type: unix"
    echo "[unixv4] Login as: root (no password)"
    exec /usr/local/bin/pdp11 /tmp/boot.ini
    ;;

  *)
    echo "[unixv4] ERROR: MODE must be 'boot' or 'install' (got: ${MODE})"
    exit 1
    ;;
esac
