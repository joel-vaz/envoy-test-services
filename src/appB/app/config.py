import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'monitor-secret-key')
    LOG_LEVEL = os.environ.get('LOG_LEVEL', 'INFO')
    TARGET_APP_URL = os.environ.get('TARGET_APP_URL', 'http://appa-proxy:9902')  # Use Docker service name 