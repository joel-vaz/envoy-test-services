#!/bin/bash

# Test script for ApplicationB endpoints through Envoy ingress

echo "Testing ApplicationB endpoints through Envoy ingress (port 8081)..."
echo "================================================================"

# Test health check endpoint
echo -e "\n1. Testing health check endpoint:"
curl -s http://localhost:8081/check/health | jq .

# Test all endpoints check
echo -e "\n2. Testing check-all endpoint:"
curl -s http://localhost:8081/check-all | jq .

# Test status endpoint
echo -e "\n3. Testing status endpoint:"
curl -s http://localhost:8081/status | jq .

# Test integer calculation
echo -e "\n4. Testing integer calculation:"
curl -s http://localhost:8081/calculate/int/5/3 | jq .

# Test float calculation
echo -e "\n5. Testing float calculation:"
curl -s http://localhost:8081/calculate/float/5.0/3.0 | jq . 