import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'your-secret-key-here')
    LOG_LEVEL = os.environ.get('LOG_LEVEL', 'INFO') 