# Flask Applications Monitor

A system of two Flask applications where ApplicationB monitors ApplicationA's endpoints.

## Project Structure

```
project/
├── src/
│   ├── appA/              # Main application with endpoints
│   │   └── app/
│   │       ├── routes/    # API endpoints
│   │       └── config.py
│   └── appB/              # Monitoring application
│       └── app/
│           ├── routes/    # Monitoring endpoints
│           └── services/  # Monitoring logic
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

2. Test ApplicationA endpoints:
```bash
# Health check
curl http://localhost:5005/health

# Hello endpoint
curl http://localhost:5005/hello

# Whoami endpoint
curl http://localhost:5005/whoami

# Calculate addition
curl -X POST http://localhost:5005/calculate/add \
  -H "Content-Type: application/json" \
  -d '{"x": 5, "y": 3}'
```

3. Test ApplicationB monitoring:
```bash
# Check specific endpoint
curl http://localhost:5001/check/health

# Check all endpoints
curl http://localhost:5001/check-all

# Get overall status
curl http://localhost:5001/status

# Calculate with integers
curl http://localhost:5001/calculate/int/5/3

# Calculate with floats
curl http://localhost:5001/calculate/float/5.0/3.0
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
