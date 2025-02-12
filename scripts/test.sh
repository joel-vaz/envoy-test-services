#!/bin/bash
set -e

# Function to handle errors
handle_error() {
    echo "Error occurred. Check the logs for details."
    exit 1
}
trap 'handle_error' ERR

echo "Running core functionality tests..."
echo "================================="

# 1. AppA Ingress Tests (port 8080)
echo -e "\n1. Testing AppA through Ingress:"
echo "--------------------------------"
echo "POST /calculate/add through ingress:"
curl -s -X POST -H "Content-Type: application/json" \
  http://localhost:8080/calculate/add \
  -d '{"x":5,"y":3}' | jq .

echo -e "\nGET /health through ingress:"
curl -s http://localhost:8080/health | jq .

echo -e "\nGET /hello through ingress:"
curl -s http://localhost:8080/hello | jq .

echo -e "\nGET /whoami through ingress:"
curl -s http://localhost:8080/whoami | jq .

# 2. Direct AppA Tests (port 9902)
echo -e "\n2. Testing AppA (Direct):"
echo "-------------------------"
# Test calculation endpoint
echo "POST /calculate/add:"
curl -s -X POST -H "Content-Type: application/json" \
  http://localhost:9902/calculate/add \
  -d '{"x":5,"y":3}' | jq .

# 3. AppB Tests
echo -e "\n3. Testing AppB Proxy:"
echo "----------------------"
# Test AppB through ingress (port 8081)
echo "A. Testing through ingress (8081):"
echo "POST /calculate/add:"
curl -s -X POST -H "Content-Type: application/json" \
  http://localhost:8081/calculate/add \
  -d '{"x":5,"y":3}' | jq .

echo -e "\nGET /check/health:"
curl -s http://localhost:8081/check/health | jq .

echo -e "\nGET /check-all:"
curl -s http://localhost:8081/check-all | jq .

echo -e "\nGET /status:"
curl -s http://localhost:8081/status | jq .

# Test AppB through proxy (port 9905)
echo -e "\nB. Testing through proxy (9905):"
echo "POST /calculate/add:"
curl -s -X POST -H "Content-Type: application/json" \
  http://localhost:9905/calculate/add \
  -d '{"x":5,"y":3}' | jq .

echo -e "\nGET /check/health:"
curl -s http://localhost:9905/check/health | jq .

echo -e "\nGET /check-all:"
curl -s http://localhost:9905/check-all | jq .

echo -e "\nGET /status:"
curl -s http://localhost:9905/status | jq .

# 4. Health Status
echo -e "\n4. Checking Service Health:"
echo "--------------------------"
# Check AppA cluster health
echo "AppA cluster health:"
curl -s http://localhost:9904/clusters | grep appA_cluster | grep health_flags

# 5. Log Verification
echo -e "\n5. Verifying Logs:"
echo "-----------------"
# Check AppA access logs
echo "AppA proxy access logs:"
docker-compose logs appa-proxy | grep -E 'access_log|request_path' | tail -n 1 | grep -o '{.*}' | jq . || echo "No valid JSON logs found"

# Check AppA ingress logs
echo -e "\nAppA ingress access logs:"
docker-compose logs appa-ingress | grep -E 'access_log|request_path' | tail -n 1 | grep -o '{.*}' | jq . || echo "No valid JSON logs found"

# Check AppB ingress logs
echo -e "\nAppB ingress access logs:"
docker-compose logs appb-ingress | grep -E 'access_log|request_path' | tail -n 1 | grep -o '{.*}' | jq . || echo "No valid JSON logs found"

# Check AppB proxy logs
echo -e "\nAppB proxy access logs:"
docker-compose logs appb-proxy --tail 1 | grep -o '{.*}' | jq . || echo "No valid JSON logs found"

# Verify log fields
echo -e "\nVerifying log fields:"
echo "Looking for response_time_ms, response_code, and request_path..."
docker-compose logs | grep -E 'response_time_ms|response_code|request_path' | tail -n 1 | grep -o '{.*}' | jq . || echo "No matching logs found"

echo -e "\nTests completed!" 