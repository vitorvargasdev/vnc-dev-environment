#!/bin/bash
# Calculate CPU usage properly
awk -v RS='' '
{
    # Get first measurement
    u1 = $2 + $3 + $4
    t1 = $2 + $3 + $4 + $5 + $6 + $7 + $8
    getline
    # Get second measurement after 1s
    u2 = $2 + $3 + $4
    t2 = $2 + $3 + $4 + $5 + $6 + $7 + $8
    # Calculate percentage
    printf "%.1f%%\n", 100 * (u2 - u1) / (t2 - t1)
}' <(grep 'cpu ' /proc/stat) <(sleep 1; grep 'cpu ' /proc/stat)
