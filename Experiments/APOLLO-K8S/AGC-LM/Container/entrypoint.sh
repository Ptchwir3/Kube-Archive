#!/bin/bash
set -e

CORE="./Luminary099.bin"
PORT="${AGC_PORT:-1969}"

echo "========================================"
echo "Apollo Guidance Computer - LM"
echo "Core Rope: Luminary099 (Apollo 11 LM)"
echo "Telemetry Port: ${PORT}"
echo "========================================"

# Start yaAGC with the LM core rope
exec ./yaAGC --port=${PORT} "${CORE}"
