from flask import Blueprint, jsonify, request
from ..services.health_checker import HealthChecker
from ..config import Config
import logging

monitor_bp = Blueprint('monitor', __name__)
logger = logging.getLogger('app_b')

health_checker = HealthChecker(Config.TARGET_APP_URL)

@monitor_bp.route('/check/<endpoint>')
def check_endpoint(endpoint):
    """Check a specific endpoint of ApplicationA"""
    if endpoint not in health_checker.endpoints:
        return jsonify({
            'error': 'Invalid endpoint',
            'valid_endpoints': list(health_checker.endpoints.keys())
        }), 400
    
    result = health_checker.check_endpoint(endpoint)
    return jsonify(result)

@monitor_bp.route('/check-all')
def check_all():
    """Check all endpoints of ApplicationA"""
    results = health_checker.check_all_endpoints()
    return jsonify(results)

@monitor_bp.route('/status')
def status():
    """Get overall status of ApplicationA"""
    results = health_checker.check_all_endpoints()
    all_healthy = all(result['is_healthy'] for result in results.values())
    
    return jsonify({
        'application': 'ApplicationA',
        'status': 'healthy' if all_healthy else 'unhealthy',
        'endpoints': results,
        'total_endpoints': len(results),
        'healthy_endpoints': sum(1 for result in results.values() if result['is_healthy'])
    })

@monitor_bp.route('/calculate/add', methods=['POST'])
def calculate():
    """Forward calculation request to ApplicationA"""
    try:
        data = request.get_json()
        if not data or 'x' not in data or 'y' not in data:
            return jsonify({
                'error': 'Missing required parameters x and y',
                'status': 'error'
            }), 400
        
        logger.info(f"Calculate endpoint called with data: {data}")
        result = health_checker.calculate_addition(float(data['x']), float(data['y']))
        
        if not result.get('is_successful'):
            logger.error(f"Failed to get calculation: {result.get('error')}")
            return jsonify({
                'error': 'Failed to get calculation from ApplicationA',
                'details': result.get('error', 'Unknown error')
            }), 500
        
        return jsonify(result['response'])
    except ValueError:
        return jsonify({
            'error': 'Invalid number format',
            'status': 'error'
        }), 400
    except Exception as e:
        logger.error(f"Error processing calculation request: {str(e)}")
        return jsonify({
            'error': 'Internal server error',
            'status': 'error'
        }), 500 