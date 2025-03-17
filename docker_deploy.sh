#!/bin/bash

set -e  

YAML_URL="https://raw.githubusercontent.com/namrqthakaipa/testapp/main/mongodb.yaml"
YAML_FILE="mongodb.yaml"
NODE_APP_IMAGE="namratha0228/testapp"

echo "Checking if Docker and Docker Compose are installed..."

# Install Docker if not installed
if ! command -v docker &> /dev/null; then
    echo " Docker not found! Installing Docker..."
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl enable --now docker
    echo " Docker installed successfully!"
fi

# Install Docker Compose if not installed
if ! docker compose version &> /dev/null; then
    echo " Docker Compose not found! Installing..."
    mkdir -p ~/.docker/cli-plugins/
    curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
    chmod +x ~/.docker/cli-plugins/docker-compose
    echo " Docker Compose installed successfully!"
fi

# Download mongodb.yaml file
echo " Downloading mongodb.yaml from GitHub..."
curl -o $YAML_FILE $YAML_URL

# Verifying yaml file
if [ ! -f "$YAML_FILE" ]; then
    echo " ERROR: Failed to download mongodb.yaml!"
    exit 1
fi

echo " mongodb.yaml downloaded successfully!"

# Pulling latest Node.js app Docker image
echo " Pulling latest Docker image: $NODE_APP_IMAGE..."
docker pull $NODE_APP_IMAGE

# Deploy the containers
echo " Deploying containers using Docker Compose..."
docker compose -f $YAML_FILE up -d --pull always

# Wait for services to start
echo " Waiting for services to start..."
sleep 10

# Show running containers
docker ps

# Display Access URLs
echo " Deployment completed!"
echo " Node.js app is running "
echo " Mongo Express is available"
