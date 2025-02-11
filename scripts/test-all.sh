#!/bin/bash

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

# Run ApplicationA tests
echo -e "\nRunning ApplicationA tests..."
./scripts/test-appa.sh

# Run ApplicationB tests
echo -e "\nRunning ApplicationB tests..."
./scripts/test-appb.sh

# Run Envoy tests
echo -e "\nRunning Envoy tests..."
./scripts/test-envoy.sh

# Run Access Log tests
echo -e "\nRunning Access Log tests..."
./scripts/test-logs.sh

echo -e "\nAll tests completed!" 