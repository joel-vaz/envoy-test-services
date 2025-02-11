import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'monitor-secret-key')
    LOG_LEVEL = os.environ.get('LOG_LEVEL', 'INFO')
    TARGET_APP_URL = "http://localhost:8080"  # Use AppA's ingress port 