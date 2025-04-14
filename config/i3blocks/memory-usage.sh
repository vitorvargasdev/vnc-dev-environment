#!/bin/bash

# Get memory information
memory_info=$(free -m | awk '/^Mem:/{print $3, $2}')

# Extract used and total memory in MB
used_mb=$(echo $memory_info | awk '{print $1}')
total_mb=$(echo $memory_info | awk '{print $2}')

# Convert MB to GB
used_gb=$(echo "scale=2; $used_mb / 1024" | bc)
total_gb=$(echo "scale=2; $total_mb / 1024" | bc)

# Output the result
echo "$used_gb GB / $total_gb GB"

