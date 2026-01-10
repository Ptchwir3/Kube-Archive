#!/bin/bash
set -e

CORE="./Colossus249.bin"
PORT="${AGC_PORT:-1969}"

echo "========================================"
echo "Apollo Guidance Computer - CSM"
echo "Core Rope: Colossus249 (Apollo 11 CM)"
echo "Telemetry Port: ${PORT}"
echo "========================================"

# Start yaAGC with the CSM core rope
# yaAGC listens on port 19697 by default for I/O
exec ./yaAGC --port=${PORT} "${CORE}"
