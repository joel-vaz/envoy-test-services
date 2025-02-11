#!/bin/bash

# Logs script for viewing application logs

# Check if application name is provided
if [ -z "$1" ]; then
    # If no app specified, show all logs
    docker-compose logs -f
else
    # Show logs for specific application
    case $1 in
        "appa")
            docker-compose logs -f appa
            ;;
        "appb")
            docker-compose logs -f appb
            ;;
        *)
            echo "Unknown application. Use 'appa' or 'appb'"
            exit 1
            ;;
    esac
fi 