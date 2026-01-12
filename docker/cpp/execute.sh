#!/bin/sh
# C++ Execution Script

set -e

CODE_FILE="${1:-/sandbox/solution.cpp}"
INPUT_FILE="${2:-/sandbox/input.txt}"
OUTPUT_FILE="/sandbox/solution"

if [ ! -f "$CODE_FILE" ]; then
    echo "Error: Code file not found" >&2
    exit 1
fi

# Compile with timeout
timeout 3s g++ -std=c++17 -O2 -Wall "$CODE_FILE" -o "$OUTPUT_FILE" 2>&1

if [ $? -ne 0 ]; then
    echo "Compilation failed" >&2
    exit 1
fi

# Execute with timeout
timeout 2s "$OUTPUT_FILE" < "$INPUT_FILE" 2>&1

exit $?
