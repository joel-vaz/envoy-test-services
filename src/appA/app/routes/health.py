from flask import Blueprint, jsonify
import logging
from datetime import datetime, timezone

health_bp = Blueprint('health', __name__)
logger = logging.getLogger('app_a')

@health_bp.route('/health')
def health_check():
    logger.info('Health check endpoint called')
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now(timezone.utc).isoformat()
    }) 