#!/bin/bash

# Set your deadline (format: YYYY-MM-DD HH:MM:SS)
DEADLINE="2025-02-07 17:30:00"

# Get the current time in seconds since epoch
NOW=$(date +%s)

# Get the deadline time in seconds since epoch
DEADLINE_EPOCH=$(date -d "$DEADLINE" +%s)

# Calculate the difference
DIFF=$((DEADLINE_EPOCH - NOW))

if [ $DIFF -lt 0 ]; then
    echo "Deadline passed"
else
    # Calculate days, hours, minutes, and seconds
    DAYS=$((DIFF / 86400))
    HOURS=$(( (DIFF % 86400) / 3600 ))
    MINUTES=$(( (DIFF % 3600) / 60 ))
    SECONDS=$((DIFF % 60))

    # Format the output
    echo "${DAYS}d ${HOURS}h ${MINUTES}m ${SECONDS}s"
fi

