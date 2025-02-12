# API Documentation

## AppA Endpoints

### Calculate Addition
```http
POST /calculate/add
Content-Type: application/json

{
  "x": number,
  "y": number
}
```

**Response:**
```json
{
  "operation": "addition",
  "result": number,
  "status": "success",
  "x": number,
  "y": number
}
```

### Health Check
```http
GET /health
```

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "ISO-8601-timestamp"
}
```

### Hello World
```http
GET /hello
```

**Response:**
```json
{
  "message": "Hello, World!",
  "status": "success"
}
```

### Whoami
```http
GET /whoami
```

**Response:**
```json
{
  "client_ip": "string",
  "timestamp": "ISO-8601-timestamp",
  "user_agent": "string"
}
```

## AppB Endpoints

### Check Health
```http
GET /check/health
```

**Response:**
```json
{
  "checked_at": "ISO-8601-timestamp",
  "endpoint": "health",
  "is_healthy": boolean,
  "response": {
    "status": "healthy",
    "timestamp": "ISO-8601-timestamp"
  },
  "status_code": number,
  "url": "string"
}
```

### Check All Endpoints
```http
GET /check-all
```

**Response:**
```json
{
  "health": {
    "checked_at": "ISO-8601-timestamp",
    "endpoint": "health",
    "is_healthy": boolean,
    "response": {...},
    "status_code": number,
    "url": "string"
  },
  "hello": {...},
  "whoami": {...}
}
```

### Status
```http
GET /status
```

**Response:**
```json
{
  "application": "ApplicationA",
  "endpoints": {
    "health": {...},
    "hello": {...},
    "whoami": {...}
  },
  "healthy_endpoints": number,
  "status": "healthy|unhealthy",
  "total_endpoints": number
}
```

### Calculate Addition (Proxy)
```http
POST /calculate/add
Content-Type: application/json

{
  "x": number,
  "y": number
}
```

**Response:**
```json
{
  "operation": "addition",
  "result": number,
  "status": "success",
  "x": number,
  "y": number
}
``` 