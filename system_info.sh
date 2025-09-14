#!/bin/bash
# Display system info

echo "=== SYSTEM INFO ==="
echo "Hostname:" $(hostname)
echo "OS Type:" $(uname -s)
echo "Kernel Version:" $(uname -r)
echo "CPU Info:" $(sysctl -n machdep.cpu.brand_string 2>/dev/null || lscpu)
echo "Total Memory:" $(vm_stat 2>/dev/null | grep "Pages free" || free -h)
echo "Disk Usage:"
df -h

