#!/bin/bash
SOURCE="/opt/shell_script/source"
DESTINATION="/opt/shell_script/destination"
DATE=$(date +%Y-%m-%d_%H-%M-%S)

#Create  backup directory and copy files

mkdir -p $DESTINATION/$DATE
cp -r $SOURCE $DESTINATION/$DATE
echo "Backup completed on $DATE"
