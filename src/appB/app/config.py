import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'monitor-secret-key')
    LOG_LEVEL = os.environ.get('LOG_LEVEL', 'INFO')
    TARGET_APP_URL = "http://localhost:9901/calculate/add"  # Send through local proxy 