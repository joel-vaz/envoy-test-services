# Envoy Admin Interfaces

Each Envoy proxy has an admin interface for monitoring and configuration:

## Admin Ports
- AppA Ingress Admin: http://localhost:9901
- AppA Proxy Admin: http://localhost:9902
- AppB Ingress Admin: http://localhost:9903
- AppB Proxy Admin: http://localhost:9904

## Available Endpoints

1. Basic Information:
```bash
# Get server info
curl http://localhost:9901/server_info

# Get statistics
curl http://localhost:9901/stats

# Get configuration
curl http://localhost:9901/config_dump
```

2. Cluster Information:
```bash
# Get cluster status
curl http://localhost:9901/clusters

# Get cluster statistics
curl http://localhost:9901/stats?filter=cluster
```

3. Logging:
```bash
# Get logging info
curl http://localhost:9901/logging

# Change log level
curl -X POST http://localhost:9901/logging?level=debug
```

4. Health Checks:
```bash
# Get health check status
curl http://localhost:9901/healthcheck/fail  # Fail health check
curl http://localhost:9901/healthcheck/ok    # Pass health check
```

## Common Use Cases

1. Monitoring Service Health:
```bash
# Check if services are healthy
curl http://localhost:9901/clusters | grep health_flags
```

2. Debugging Connection Issues:
```bash
# Check active connections
curl http://localhost:9901/stats | grep connections_active

# Check connection errors
curl http://localhost:9901/stats | grep cx_connect_fail
```

3. Performance Monitoring:
```bash
# Check request rates
curl http://localhost:9901/stats | grep rq_total

# Check response times
curl http://localhost:9901/stats | grep time
```

## Security Note
The admin interfaces should not be exposed in production environments. Consider:
- Using authentication
- Restricting access to internal networks
- Using a separate management network 

## Access Logs

Each Envoy proxy is configured with JSON-formatted access logs that include:

### Ingress Proxies Log Fields
- `timestamp`: Request start time
- `client_ip`: Client's IP address
- `request_method`: HTTP method
- `request_path`: Original request path
- `response_code`: HTTP response code
- `response_time`: Request duration
- `bytes_received`: Bytes received from client
- `bytes_sent`: Bytes sent to client
- `user_agent`: Client's user agent

### Service Proxies Log Fields
- `timestamp`: Request start time
- `upstream_service`: Target service cluster
- `request_method`: HTTP method
- `request_path`: Original request path
- `response_code`: HTTP response code
- `response_time`: Request duration
- `bytes_received`: Bytes received
- `bytes_sent`: Bytes sent

### Viewing Logs

View logs using docker-compose:
```bash
# View all Envoy logs
docker-compose logs appa-ingress
docker-compose logs appa-proxy
docker-compose logs appb-ingress
docker-compose logs appb-proxy

# Follow specific proxy logs
docker-compose logs -f appa-ingress
```

### Log Analysis Examples

1. Filter error responses:
```bash
docker-compose logs appa-ingress | grep '"response_code":5'
```

2. Check slow requests:
```bash
docker-compose logs appa-proxy | grep -E '"response_time":[0-9]{4,}'
```

3. Monitor specific endpoints:
```bash
docker-compose logs appa-ingress | grep '"request_path":"/health"'
``` 