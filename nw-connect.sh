
#!/bin/bash
HOSTNAME="google.com"

#Getting the output file
OUTPUT_FILE="/opt/shell_script/output.txt"

# Check if the host is reachable

if ping -c 1 $HOST &> /dev/null
then
echo "$HOST is reachable" >> $OUTPUT_FILE
else
echo "$HOST is not reachable" >> $OUTPUT_FILE
fi
