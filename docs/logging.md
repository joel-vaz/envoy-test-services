# Envoy Access Logging

## Overview
The system implements comprehensive access logging across all Envoy proxies (both ingress and service proxies). Each proxy maintains two logging streams:
- stdout logging (visible via docker logs)
- file-based logging (persisted to host machine)

## Log Locations
Access logs are stored in the following locations:

```
logs/
├── appa/
│   ├── ingress/access.log  # AppA ingress proxy logs
│   └── proxy/access.log    # AppA service proxy logs
└── appb/
    ├── ingress/access.log  # AppB ingress proxy logs
    └── proxy/access.log    # AppB service proxy logs
```

## Log Format
All access logs are in JSON format with the following fields:
```json
{
  "timestamp": "2025-02-11T16:14:58.000Z",
  "upstream_service": "appA_cluster",
  "request_method": "POST",
  "request_path": "/calculate/add",
  "response_code": 200,
  "response_time": 1,
  "bytes_received": 16,
  "bytes_sent": 94
}
```

### Field Descriptions
- `timestamp`: Request start time in ISO 8601 format
- `upstream_service`: The Envoy cluster handling the request
- `request_method`: HTTP method (GET, POST, etc.)
- `request_path`: Original request path
- `response_code`: HTTP response status code
- `response_time`: Request duration in milliseconds
- `bytes_received`: Request body size in bytes
- `bytes_sent`: Response body size in bytes

## Monitoring Logs
You can monitor logs in real-time using:
```bash
# View specific component logs
tail -f logs/appa/proxy/access.log
tail -f logs/appb/ingress/access.log

# View all logs combined
tail -f logs/**/access.log
```

## Log Retention
Logs are persisted to the host machine and survive container restarts. Consider implementing log rotation for production environments.

# Logging Configuration

## Access Log Format

### AppA Proxy Logs
```json
{
  "timestamp": "%START_TIME%",
  "upstream_service": "%UPSTREAM_CLUSTER%",
  "request_method": "%REQ(:METHOD)%",
  "request_path": "%REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%",
  "response_code": "%RESPONSE_CODE%",
  "response_time_ms": "%DURATION%",
  "bytes_received": "%BYTES_RECEIVED%",
  "bytes_sent": "%BYTES_SENT%",
  "protocol": "%PROTOCOL%",
  "response_flags": "%RESPONSE_FLAGS%",
  "route_name": "%ROUTE_NAME%"
}
```

### AppB Proxy Logs
```json
{
  "timestamp": "%START_TIME%",
  "upstream_service": "%UPSTREAM_CLUSTER%",
  "request_method": "%REQ(:METHOD)%",
  "request_path": "%REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%",
  "response_code": "%RESPONSE_CODE%",
  "response_time_ms": "%DURATION%",
  "bytes_received": "%BYTES_RECEIVED%",
  "bytes_sent": "%BYTES_SENT%",
  "protocol": "%PROTOCOL%",
  "response_flags": "%RESPONSE_FLAGS%",
  "route_name": "%ROUTE_NAME%"
}
```

## Log Locations

- AppA Ingress: `/dev/stdout` and `/var/log/envoy/access.log`
- AppA Proxy: `/dev/stdout` and `/var/log/envoy/access.log`
- AppB Ingress: `/dev/stdout` and `/var/log/envoy/access.log`
- AppB Proxy: `/dev/stdout` and `/var/log/envoy/access.log`

## Viewing Logs

```bash
# View all logs
docker-compose logs

# View specific component logs
docker-compose logs appa-proxy
docker-compose logs appb-proxy
docker-compose logs appa-ingress
docker-compose logs appb-ingress

# Follow logs in real-time
docker-compose logs -f
```

## Log Analysis

The test suite includes log analysis features:
- Response time monitoring
- Error detection (4xx, 5xx responses)
- Request path distribution
- Upstream service tracking 