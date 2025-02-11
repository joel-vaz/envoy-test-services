#!/bin/bash

# Setup script for development environment

# Create necessary directories
mkdir -p logs

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

# Build and start the containers
echo "Building and starting containers..."
docker-compose up --build -d

echo "Setup complete! Applications are running at:"
echo "ApplicationA: http://localhost:5005"
echo "ApplicationB: http://localhost:5001" 