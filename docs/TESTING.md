# Testing Guide

## Test Suite Overview

The project includes a comprehensive test suite (`scripts/test.sh`) that verifies all components:

### 1. AppA Direct Testing
- Tests AppA endpoints directly:
  ```bash
  # Direct access (port 5005)
  curl http://localhost:5005/health
  ```

### 2. AppA Through Ingress
- Tests AppA through its ingress:
  ```bash
  # Through ingress (port 8080)
  curl http://localhost:8080/health
  curl http://localhost:8080/hello
  curl http://localhost:8080/whoami
  curl -X POST http://localhost:8080/calculate/add -d '{"x":5,"y":3}'
  ```

### 3. AppB Testing
- Tests AppB through both ingress and proxy:
  ```bash
  # Through ingress (port 8081)
  curl http://localhost:8081/check/health
  curl http://localhost:8081/check-all
  curl http://localhost:8081/status
  curl -X POST http://localhost:8081/calculate/add -d '{"x":5,"y":3}'

  # Through proxy (port 9905)
  curl http://localhost:9905/check/health
  ```

### 4. Log Verification
- Verifies access logs from all components:
  - AppA ingress logs
  - AppA proxy logs
  - AppB ingress logs
  - AppB proxy logs

## Running Tests

```bash
# Run all tests
./scripts/test.sh

# Run specific test sections
./scripts/test-calc.sh    # Test calculation endpoints
./scripts/test-route.sh   # Test routing configuration
./scripts/test-logs.sh    # Test access logging
``` 