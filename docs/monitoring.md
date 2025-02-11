# System Monitoring

## Envoy Admin Interface
Each Envoy proxy exposes an admin interface for monitoring:

### Endpoints
- `/server_info`: Version, uptime, and state
- `/stats`: Runtime statistics
- `/clusters`: Upstream cluster status
- `/config_dump`: Current configuration

### Access
```bash
# AppA Admin Interfaces
curl http://localhost:9901/server_info  # AppA Ingress
curl http://localhost:9902/server_info  # AppA Proxy

# AppB Admin Interfaces
curl http://localhost:9903/server_info  # AppB Ingress
curl http://localhost:9904/server_info  # AppB Proxy
```

## Application Monitoring
### Health Checks
- ApplicationA: `/health`
- ApplicationB: `/check/health`

### Status Endpoints
- Overall status: `/status`
- Detailed checks: `/check-all`

## Metrics
### Access Log Metrics
- Request count
- Response times
- Error rates
- Bytes transferred

### Performance Monitoring
Monitor these metrics for performance:
- Response times > 100ms
- Error rates (4xx, 5xx)
- Upstream service health
- Connection pool status

## Alerting
Consider monitoring these conditions:
- 5xx error rate > 1%
- Response time > 500ms
- Failed health checks
- Proxy restart events 