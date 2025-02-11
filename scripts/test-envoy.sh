#!/bin/bash

# Test script for Envoy admin interfaces

echo "Testing Envoy admin interfaces..."
echo "================================"

# Test AppA Envoy admins
echo -e "\n1. Testing AppA Ingress admin interface (port 9901):"
curl -s http://localhost:9901/server_info | jq '{version, state, uptime_current_epoch}'

echo -e "\n2. Testing AppA Proxy admin interface (port 9902):"
curl -s http://localhost:9902/server_info | jq '{version, state, uptime_current_epoch}'

# Test AppB Envoy admins
echo -e "\n3. Testing AppB Ingress admin interface (port 9903):"
curl -s http://localhost:9903/server_info | jq '{version, state, uptime_current_epoch}'

echo -e "\n4. Testing AppB Proxy admin interface (port 9904):"
curl -s http://localhost:9904/server_info | jq '{version, state, uptime_current_epoch}'

# Test clusters health
echo -e "\n5. Testing clusters health:"
echo "AppA Ingress clusters:"
curl -s http://localhost:9901/clusters | grep health_flags
echo "AppB Ingress clusters:"
curl -s http://localhost:9903/clusters | grep health_flags 