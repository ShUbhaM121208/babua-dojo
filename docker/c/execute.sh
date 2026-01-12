#!/bin/sh
# C Execution Script

set -e

CODE_FILE="${1:-/sandbox/solution.c}"
INPUT_FILE="${2:-/sandbox/input.txt}"
OUTPUT_FILE="/sandbox/solution"

if [ ! -f "$CODE_FILE" ]; then
    echo "Error: Code file not found" >&2
    exit 1
fi

# Compile
timeout 3s gcc -std=c11 -O2 -Wall "$CODE_FILE" -o "$OUTPUT_FILE" 2>&1

if [ $? -ne 0 ]; then
    exit 1
fi

# Execute
timeout 2s "$OUTPUT_FILE" < "$INPUT_FILE" 2>&1

exit $?
