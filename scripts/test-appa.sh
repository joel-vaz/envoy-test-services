#!/bin/bash

# Test script for ApplicationA endpoints through Envoy ingress

echo "Testing ApplicationA endpoints through Envoy ingress (port 8080)..."
echo "================================================================"

# Test health endpoint
echo -e "\n1. Testing health endpoint:"
curl -s http://localhost:8080/health | jq .

# Test hello endpoint
echo -e "\n2. Testing hello endpoint:"
curl -s http://localhost:8080/hello | jq .

# Test whoami endpoint
echo -e "\n3. Testing whoami endpoint:"
curl -s http://localhost:8080/whoami | jq .

# Test calculation endpoint
echo -e "\n4. Testing calculation endpoint:"
curl -s -X POST http://localhost:8080/calculate/add \
  -H "Content-Type: application/json" \
  -d '{"x": 5, "y": 3}' | jq . 