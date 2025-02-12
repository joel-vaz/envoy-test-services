# Envoy Configuration Guide

## Configuration Overview

Each service has two Envoy proxies:
1. Ingress proxy for external traffic
2. Service proxy for service-to-service communication

## AppA Configuration

### Ingress (Port 8080)
```yaml
listeners:
  - address:
      socket_address:
        port_value: 8080
    filter_chains:
      - filters:
          - name: envoy.filters.network.http_connection_manager
            typed_config:
              route_config:
                virtual_hosts:
                  - routes:
                      - match: { prefix: "/" }
                        route:
                          cluster: appA_proxy_cluster
```

### Proxy (Port 9902)
```yaml
listeners:
  - address:
      socket_address:
        port_value: 9902
    filter_chains:
      - filters:
          - name: envoy.filters.network.http_connection_manager
            typed_config:
              route_config:
                virtual_hosts:
                  - routes:
                      - match: { prefix: "/" }
                        route:
                          cluster: appA_cluster
```

## AppB Configuration

### Ingress (Port 8081)
```yaml
listeners:
  - address:
      socket_address:
        port_value: 8081
    filter_chains:
      - filters:
          - name: envoy.filters.network.http_connection_manager
            typed_config:
              route_config:
                virtual_hosts:
                  - routes:
                      - match: { prefix: "/" }
                        route:
                          cluster: appB_proxy_cluster
```

### Proxy (Port 9905)
```yaml
listeners:
  - address:
      socket_address:
        port_value: 9905
    filter_chains:
      - filters:
          - name: envoy.filters.network.http_connection_manager
            typed_config:
              route_config:
                virtual_hosts:
                  - routes:
                      - match: { prefix: "/calculate/add" }
                        route:
                          cluster: appA_cluster
                      - match: { prefix: "/" }
                        route:
                          cluster: appB_cluster
```

## Health Checking Configuration

```yaml
health_checks:
  - timeout: 1s
    interval: 5s
    unhealthy_threshold: 2
    healthy_threshold: 1
    http_health_check:
      path: "/health"
``` 