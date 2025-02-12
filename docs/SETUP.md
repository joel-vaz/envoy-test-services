# Setup Guide

## Prerequisites

- Docker
- Docker Compose
- curl (for testing)
- jq (for log parsing)

## Initial Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd envoy-learning
```

2. Build and start the services:
```bash
docker-compose up --build -d
```

3. Verify the setup:
```bash
# Check if services are running
docker-compose ps

# Test AppA health
curl http://localhost:8080/health

# Test AppB health
curl http://localhost:8081/check/health
```

## Port Configuration

| Service | Port | Purpose |
|---------|------|---------|
| AppA Ingress | 8080 | External access to AppA |
| AppA Proxy | 9902 | Service-to-service communication |
| AppA | 5005 | Direct application access |
| AppB Ingress | 8081 | External access to AppB |
| AppB Proxy | 9905 | Service-to-service communication |
| AppB | 5001 | Direct application access |

## Admin Interfaces

| Service | Port | Purpose |
|---------|------|---------|
| AppA Ingress | 9901 | Admin interface |
| AppA Proxy | 9906 | Admin interface |
| AppB Ingress | 9903 | Admin interface |
| AppB Proxy | 9904 | Admin interface |

## Troubleshooting

1. Check service health:
```bash
# View service status
docker-compose ps

# Check logs
docker-compose logs
```

2. Verify network connectivity:
```bash
# Test AppA connectivity
curl http://localhost:8080/health

# Test AppB connectivity
curl http://localhost:8081/check/health
```

3. Common issues:
- Port conflicts: Ensure ports are available
- Docker network issues: Try recreating networks
- Log access issues: Check permissions on log directories 