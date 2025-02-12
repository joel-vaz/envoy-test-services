# Architecture Details

## Service Architecture

### AppA (Calculator Service)
- **Core Service**: Flask application providing calculation endpoints
- **Proxy Layer**: Envoy proxy handling direct access
- **Ingress Layer**: Envoy ingress for external access

#### Endpoints
- `POST /calculate/add`: Add two numbers
- `GET /health`: Health check endpoint
- `GET /hello`: Simple greeting endpoint
- `GET /whoami`: Client information endpoint

### AppB (Monitor Service)
- **Core Service**: Flask application providing monitoring and proxying
- **Proxy Layer**: Envoy proxy handling direct access and AppA communication
- **Ingress Layer**: Envoy ingress for external access

#### Endpoints
- `POST /calculate/add`: Proxies calculation to AppA
- `GET /check/health`: Check AppA health
- `GET /check-all`: Check all AppA endpoints
- `GET /status`: Get overall AppA status

## Network Flow

1. **Direct AppA Access**:
   ```
   Client -> AppA Ingress (8080) -> AppA Proxy (9902) -> AppA (5005)
   ```

2. **AppB Proxied Access**:
   ```
   Client -> AppB Ingress (8081) -> AppB Proxy (9905) -> AppB (5001) -> AppA Proxy (9902) -> AppA (5005)
   ```

## Envoy Configuration

### Access Logging
- JSON formatted logs
- Response times in milliseconds
- Request/response details
- Protocol information

### Health Checking
- Active health checks between services
- Configurable intervals and thresholds
- Health status exposed via admin interface

### Admin Interfaces
- AppA Ingress: port 9901
- AppA Proxy: port 9906
- AppB Ingress: port 9903
- AppB Proxy: port 9904

## Network Architecture

The system uses three Docker networks:
1. `appa_net`: Private network for AppA and its proxy (internal)
2. `appb_net`: Private network for AppB and its proxy (internal)
3. `proxy_net`: Shared network for inter-service communication via proxies

### Network Isolation
- All networks are internal except proxy_net
- Applications can only communicate with their own proxy
- Proxies can communicate with each other through the shared network
- External traffic must go through ingress

## Ports

- AppA Ingress: 8080
- AppA Proxy: 9901
- AppA: 5005
- AppB Ingress: 8081
- AppB Proxy: 9901
- AppB: 5001

## Testing the Setup

1. Test AppA through ingress:
```bash
curl http://localhost:8080/health
```

2. Test AppB through ingress:
```bash
curl http://localhost:8081/check/health
```

3. Test inter-service communication:
```bash
# AppB checking AppA's health through proxies
curl http://localhost:8081/check/health
```

## Access Points

### External Access
- AppA: Ingress only (8080)
- AppB: Ingress only (8081)

### Admin Access
- AppA Proxy: 9906
- AppB Proxy: 9904
- AppA Ingress: 9901
- AppB Ingress: 9903 