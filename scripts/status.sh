#!/bin/bash

# Change to script directory
cd "$(dirname "$0")"

echo "Checking service status..."
echo "========================="

# Check container status
echo -e "\nContainer Status:"
docker-compose ps

# Check health endpoints
echo -e "\nHealth Status:"
echo "AppA: $(curl -s http://localhost:8080/health | jq -r .status)"
echo "AppB: $(curl -s http://localhost:8081/check/health | jq -r .is_healthy)"

# Check Envoy proxy status
echo -e "\nProxy Status:"
for port in 9901 9902 9903 9904; do
    echo "Envoy on $port: $(curl -s http://localhost:$port/server_info | jq -r .state)"
done 