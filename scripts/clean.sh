#!/bin/bash

# Clean script for cleaning up Docker resources

# Stop containers
docker-compose down

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