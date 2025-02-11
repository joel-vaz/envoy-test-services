#!/bin/bash

# Test script for Envoy access logs

echo "Testing Envoy access logging..."
echo "=============================="

# Function to generate some test traffic
generate_traffic() {
    echo "Generating test traffic..."
    # Hit AppA endpoints
    curl -s http://localhost:8080/health > /dev/null
    curl -s http://localhost:8080/hello > /dev/null
    curl -s -X POST http://localhost:8080/calculate/add \
        -H "Content-Type: application/json" \
        -d '{"x": 5, "y": 3}' > /dev/null
    
    # Hit AppB endpoints
    curl -s http://localhost:8081/check/health > /dev/null
    curl -s http://localhost:8081/check-all > /dev/null
    curl -s http://localhost:8081/calculate/int/5/3 > /dev/null
    
    # Generate an error
    curl -s http://localhost:8080/nonexistent > /dev/null
    
    echo "Traffic generation complete."
    echo "Waiting for logs to be processed..."
    sleep 2
}

# Function to check logs for a specific container
check_container_logs() {
    local container=$1
    local description=$2
    
    echo -e "\nChecking $description logs (container: $container):"
    echo "------------------------------------------------"
    
    # Get recent logs and parse JSON
    docker-compose logs --tail=20 $container | grep -E "({.+})" | tail -n 5 | while read -r line; do
        # Extract JSON part and format with jq
        echo "$line" | grep -o '{.*}' | jq '.'
    done
}

# Generate some test traffic first
generate_traffic

# Check logs for each Envoy proxy
check_container_logs "appa-ingress" "AppA Ingress"
check_container_logs "appa-proxy" "AppA Proxy"
check_container_logs "appb-ingress" "AppB Ingress"
check_container_logs "appb-proxy" "AppB Proxy"

# Analysis examples
echo -e "\nLog Analysis Examples:"
echo "----------------------"

echo -e "\n1. Checking for error responses (4xx, 5xx):"
docker-compose logs | grep -E '"response_code":(4|5)[0-9]{2}'

echo -e "\n2. Checking response times > 100ms:"
docker-compose logs | grep -E '"response_time":[0-9]{3,}' | jq '.'

echo -e "\n3. Requests by client IP:"
docker-compose logs appa-ingress | grep -o '"client_ip":"[^"]*"' | sort | uniq -c

echo -e "\n4. Upstream service calls:"
docker-compose logs appa-proxy | grep -o '"upstream_service":"[^"]*"' | sort | uniq -c

echo -e "\nAccess Log Testing Complete!" 