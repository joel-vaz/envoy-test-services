# Flask Applications Monitor with Envoy Proxy

A system of two Flask applications with Envoy proxy for service mesh and ingress traffic.

## Architecture

Each application has three components:
- Application container (Flask)
- Proxy sidecar (Envoy for service-to-service communication)
- Ingress sidecar (Envoy for external traffic)

### Network Flow
- External → AppA: Request → AppA Ingress (8080) → AppA Proxy (9901) → AppA (5005)
- External → AppB: Request → AppB Ingress (8081) → AppB Proxy (9901) → AppB (5001)
- Internal: AppB → AppB Proxy → AppA Proxy → AppA

## Project Structure

```
project/
├── src/
│   ├── appA/              # Main application
│   │   └── app/
│   │       ├── routes/    # API endpoints
│   │       └── config.py
│   └── appB/              # Monitoring application
│       └── app/
│           ├── routes/
│           └── services/
├── envoy/
│   ├── appA/
│   │   ├── ingress.yaml   # AppA ingress config
│   │   └── proxy.yaml     # AppA proxy config
│   └── appB/
│       ├── ingress.yaml   # AppB ingress config
│       └── proxy.yaml     # AppB proxy config
├── docker/
│   ├── appA.Dockerfile
│   └── appB.Dockerfile
└── docker-compose.yml
```

## Applications

### ApplicationA (Port 5005)
Provides basic endpoints:
- `GET /health` - Health check endpoint
- `GET /hello` - Returns a hello message
- `GET /whoami` - Returns client information
- `POST /calculate/add` - Adds two numbers (requires JSON body: {"x": number, "y": number})

### ApplicationB (Port 5001)
Monitors ApplicationA with endpoints:
- `GET /check/<endpoint>` - Check specific endpoint (health/hello/whoami)
- `GET /check-all` - Check all endpoints
- `GET /status` - Get overall ApplicationA status
- `GET /calculate/int/<x>/<y>` - Calculate sum of integers using ApplicationA
- `GET /calculate/float/<x>/<y>` - Calculate sum of floats using ApplicationA

## Running the Applications

1. Start both applications:
```bash
docker-compose up --build
```

2. Test ApplicationA through ingress:
```bash
# Health check
curl http://localhost:8080/health

# Hello endpoint
curl http://localhost:8080/hello

# Whoami endpoint
curl http://localhost:8080/whoami

# Calculate addition
curl -X POST http://localhost:8080/calculate/add \
  -H "Content-Type: application/json" \
  -d '{"x": 5, "y": 3}'
```

3. Test ApplicationB through ingress:
```bash
# Check specific endpoint
curl http://localhost:8081/check/health

# Check all endpoints
curl http://localhost:8081/check-all

# Get overall status
curl http://localhost:8081/status

# Calculate with integers
curl http://localhost:8081/calculate/int/5/3

# Calculate with floats
curl http://localhost:8081/calculate/float/5.0/3.0
```

## Stopping the Applications

```bash
docker-compose down
```

## Viewing Logs

```bash
# View all logs
docker-compose logs

# View ApplicationA logs
docker-compose logs appa

# View ApplicationB logs
docker-compose logs appb

# Follow logs in real-time
docker-compose logs -f
```

## Development

Both applications use:
- Flask for the web framework
- Gunicorn for the WSGI server
- Docker for containerization
- JSON logging for better observability

## Requirements

- Docker
- Docker Compose

## Utility Scripts

The project includes utility scripts in the `scripts` directory:

```bash
# Initial setup and start applications
./scripts/setup.sh

# View logs (all or specific app)
./scripts/logs.sh        # All logs
./scripts/logs.sh appa   # ApplicationA logs
./scripts/logs.sh appb   # ApplicationB logs

# Clean up resources and stop applications
./scripts/clean.sh
```

Basic docker-compose commands:
```bash
# Start applications
docker-compose up -d

# Stop applications
docker-compose down
```

## Monitoring

### Envoy Admin Interfaces
Each Envoy proxy provides an admin interface for monitoring:

```bash
# AppA Monitoring
curl http://localhost:9901/server_info  # AppA Ingress
curl http://localhost:9902/clusters     # AppA Proxy

# AppB Monitoring
curl http://localhost:9903/server_info  # AppB Ingress
curl http://localhost:9904/clusters     # AppB Proxy
```

See [Envoy Admin Documentation](docs/envoy-admin.md) for more details.

## Testing

The project includes several test scripts in the `scripts` directory:

```bash
# Test all components
./scripts/test-all.sh

# Test individual components
./scripts/test-appa.sh    # Test ApplicationA endpoints
./scripts/test-appb.sh    # Test ApplicationB endpoints
./scripts/test-envoy.sh   # Test Envoy admin interfaces
./scripts/test-logs.sh   # Test Envoy access logging
```

Requirements:
- `jq` command-line JSON processor
  - Ubuntu: `sudo apt-get install jq`
  - MacOS: `brew install jq`

### Access Log Testing
The `test-logs.sh` script verifies access logging by:
1. Generating test traffic to all endpoints
2. Checking logs from all Envoy proxies
3. Analyzing logs for:
    - Error responses
    - Slow requests
    - Client IP distribution
    - Upstream service calls
