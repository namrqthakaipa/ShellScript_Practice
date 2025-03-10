#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "Checking open ports..."
if ! command -v netstat &> /dev/null; then
    echo "netstat command not found! Installing net-tools..."
    sudo apt-get install -y net-tools
fi
netstat -tuln | grep LISTEN || echo "No open ports found."

echo "Updating system packages and cleaning up unnecessary packages..."
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean

echo "System packages updated and cleaned up successfully."
