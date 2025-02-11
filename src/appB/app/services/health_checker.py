import requests
import logging
from datetime import datetime, timezone

logger = logging.getLogger('app_b')

class HealthChecker:
    def __init__(self, base_url):
        self.base_url = base_url
        self.endpoints = {
            'health': '/health',
            'hello': '/hello',
            'whoami': '/whoami'
        }

    def check_endpoint(self, endpoint):
        try:
            url = f"{self.base_url}{self.endpoints[endpoint]}"
            logger.info(f"Checking endpoint: {url}")
            
            response = requests.get(url, timeout=5)
            
            return {
                'endpoint': endpoint,
                'url': url,
                'status_code': response.status_code,
                'response': response.json(),
                'checked_at': datetime.now(timezone.utc).isoformat(),
                'is_healthy': response.status_code == 200
            }
        except requests.RequestException as e:
            logger.error(f"Error checking endpoint {endpoint}: {str(e)}")
            return {
                'endpoint': endpoint,
                'url': url,
                'error': str(e),
                'checked_at': datetime.now(timezone.utc).isoformat(),
                'is_healthy': False
            }

    def check_all_endpoints(self):
        results = {}
        for endpoint in self.endpoints:
            results[endpoint] = self.check_endpoint(endpoint)
        return results

    def calculate_addition(self, x: float, y: float):
        """Forward calculation request to ApplicationA"""
        try:
            url = f"{self.base_url}/calculate/add"
            logger.info(f"Forwarding calculation request to: {url} with data x={x}, y={y}")
            
            response = requests.post(
                url, 
                json={'x': x, 'y': y},
                timeout=5
            )
            
            logger.info(f"Got response from ApplicationA: {response.status_code}")
            return {
                'status_code': response.status_code,
                'response': response.json(),
                'is_successful': response.status_code == 200
            }
        except requests.RequestException as e:
            logger.error(f"Error forwarding calculation: {str(e)}")
            return {
                'error': str(e),
                'is_successful': False
            } 