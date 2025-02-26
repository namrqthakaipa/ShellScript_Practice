#!/bin/bash

THRESHOLD=10

# Check disk usage and print a warning if usage is above the threshold
df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
do
usage=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
partition=$(echo $output | awk '{ print $2 }')
if [ $usage -ge $THRESHOLD ]; then
echo "warning: Disk usage on $partition is at ${usage}%"
fi
done
