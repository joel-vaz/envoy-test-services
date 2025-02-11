#!/bin/bash

# Change to script directory
cd "$(dirname "$0")"

echo "Cleaning up resources..."

# Stop containers
docker-compose down

# Clean up logs
echo "Cleaning up logs..."
rm -rf ../logs/*

# Remove all stopped containers
docker container prune -f

# Remove unused images
docker image prune -f

# Remove unused volumes
docker volume prune -f

# Clean Python cache files
find . -type d -name "__pycache__" -exec rm -r {} +
find . -type f -name "*.pyc" -delete

echo "Cleanup complete!" 