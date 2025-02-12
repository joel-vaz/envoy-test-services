#!/bin/bash

# Setup script for development environment

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create log directories
cd "$(dirname "$0")/.."  # Change to project root directory
mkdir -p logs/appa/proxy logs/appa/ingress logs/appb/proxy logs/appb/ingress

# Set permissions
chmod -R 777 logs/

# Set execute permissions for all scripts
echo "Setting script permissions..."
chmod +x scripts/*.sh

# Build and start the containers
echo "Building and starting containers..."
docker-compose up --build -d

echo "Setup complete! Applications are running at:"
echo "ApplicationA: http://localhost:8080"
echo "ApplicationB: http://localhost:8081" 