# Proxy Architecture

## Overview
The system implements a service mesh architecture using Envoy proxies in two roles:
- Ingress Proxies: Handle external traffic
- Service Proxies: Handle service-to-service communication

## Network Flow
```
External Request → Ingress Proxy → Service Proxy → Application
```

### Detailed Flow Example
For a request to ApplicationA:
1. External request hits AppA Ingress (8080)
2. AppA Ingress forwards to AppA Proxy (9901)
3. AppA Proxy forwards to AppA (5005)

## Components

### Ingress Proxies
- **Purpose**: Handle external traffic and provide load balancing
- **Configuration**: `envoy/[appA|appB]/ingress.yaml`
- **Ports**:
  - AppA: 8080 (HTTP), 9901 (Admin)
  - AppB: 8081 (HTTP), 9903 (Admin)

### Service Proxies
- **Purpose**: Service-to-service communication and service discovery
- **Configuration**: `envoy/[appA|appB]/proxy.yaml`
- **Ports**:
  - AppA: 9902 (Admin)
  - AppB: 9904 (Admin)

## Network Isolation
The system uses three Docker networks for isolation:
```
networks:
  appa_net:    # Private network for AppA and its proxy
  appb_net:    # Private network for AppB and its proxy
  proxy_net:   # Shared network for proxies to communicate
```

## Service Discovery
- Uses DNS-based service discovery (STRICT_DNS)
- Service names match Docker Compose service names
- Each proxy is configured to discover its upstream services

## Health Checking
- Applications expose health endpoints
- Proxies monitor upstream health
- Health status available via admin interface 