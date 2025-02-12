# Implementation Details

## Application Stack
- **Language**: Python 3.x
- **Framework**: Flask
- **Proxy**: Envoy 1.28
- **Container Runtime**: Docker

## Application Structure
```
src/
├── appA/              # Main application
│   └── app/
│       ├── routes/    # API endpoints
│       └── config.py  # Application configuration
└── appB/              # Monitoring application
    └── app/
        ├── routes/    # API endpoints
        └── services/  # Business logic
```

## Service Communication
### ApplicationA
- Primary application providing calculation services
- Exposes REST endpoints for basic operations
- Handles direct requests and service-mesh requests

### ApplicationB
- Monitoring and aggregation service
- Proxies requests to ApplicationA through service mesh
- Provides enhanced endpoints with additional logic

## Configuration Management
### Environment Variables
- `FLASK_ENV`: Application environment
- `FLASK_DEBUG`: Debug mode toggle
- `TARGET_APP_URL`: Service discovery URL

### Envoy Configuration
- Static configuration via YAML files
- Separate configs for ingress and service proxies
- Configurable access logging
- Admin interface for monitoring

## Development Workflow
1. Local Development:
   ```bash
   ./scripts/setup.sh    # Setup environment
   ./scripts/test-all.sh # Run tests
   ```

2. Monitoring:
   ```bash
   ./scripts/logs.sh     # View logs
   ```

3. Cleanup:
   ```bash
   ./scripts/clean.sh    # Cleanup resources
   ```

## Testing
- Integration tests via shell scripts
- Endpoint health monitoring
- Access log verification
- Service mesh communication tests 

# Network Isolation Implementation

## Current State
- AppA: accessible on port 5005
- AppB: accessible on port 5001
- All proxies working through ports 8080/8081
- Inter-service communication working

## Planned Changes

### Phase 1: Network Isolation
1. Add `internal: true` to private networks
2. Test all functionality

### Phase 2: Remove Direct Access
1. Remove port 5005 from AppA
2. Remove port 5001 from AppB
3. Test all functionality

### Phase 3: Clean Network Access
1. Verify proxy_net connections
2. Remove unnecessary network access
3. Test all functionality

## Testing Each Phase
```bash
# After each change:
docker-compose down
docker-compose up -d
./scripts/test.sh
``` 