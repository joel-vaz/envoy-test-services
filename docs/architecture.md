# Service Architecture with Envoy

## Overview

The system consists of two applications (AppA and AppB) with each application having its own Envoy proxy setup:
- Application container
- Proxy sidecar container (for service-to-service communication)
- Ingress sidecar container (for external traffic)

## Network Flow

### External Traffic
1. External Request → AppA Ingress (8080) → AppA Proxy (9901) → AppA (5005)
2. External Request → AppB Ingress (8081) → AppB Proxy (9901) → AppB (5001)

### Internal Communication
AppB → AppB Proxy → AppA Proxy → AppA

## Network Architecture

The system uses three Docker networks:
1. `appa_net`: Private network for AppA and its proxy
2. `appb_net`: Private network for AppB and its proxy
3. `proxy_net`: Shared network for inter-service communication via proxies

### Network Isolation
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