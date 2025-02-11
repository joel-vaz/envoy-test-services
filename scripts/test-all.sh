#!/bin/bash

# Exit on error
set -e

# Change to script directory
cd "$(dirname "$0")"

# Function to handle errors
handle_error() {
    echo "Error occurred in test suite. Check the logs for details."
    exit 1
}

# Set error handler
trap 'handle_error' ERR

# Master test script that runs all tests

echo "Running all tests..."
echo "==================="

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it first."
    echo "Ubuntu: sudo apt-get install jq"
    echo "MacOS: brew install jq"
    exit 1
fi

# Check if services are running
if ! docker-compose ps | grep -q "Up"; then
    echo "Error: Services are not running. Please run ./setup.sh first."
    exit 1
fi

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 5  # Give services time to initialize

# Check if AppA is reachable
if ! curl -s http://localhost:8080/health > /dev/null; then
    echo "Error: ApplicationA is not responding. Please check the services."
    exit 1
fi

# Check if AppB is reachable
if ! curl -s http://localhost:8081/check/health > /dev/null; then
    echo "Error: ApplicationB is not responding. Please check the services."
    exit 1
fi

# Run ApplicationA tests
echo -e "\nRunning ApplicationA tests..."
./test-appa.sh

# Run ApplicationB tests
echo -e "\nRunning ApplicationB tests..."
./test-appb.sh

# Run Envoy tests
echo -e "\nRunning Envoy tests..."
./test-envoy.sh

# Run Access Log tests
echo -e "\nRunning Access Log tests..."
./test-logs.sh

echo -e "\nAll tests completed!" 