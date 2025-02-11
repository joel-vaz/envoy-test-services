from flask import Blueprint, jsonify, request
import logging
from datetime import datetime, timezone

whoami_bp = Blueprint('whoami', __name__)
logger = logging.getLogger('app_a')

@whoami_bp.route('/whoami')
def whoami():
    logger.info('Whoami endpoint called')
    return jsonify({
        'client_ip': request.remote_addr,
        'user_agent': request.user_agent.string,
        'timestamp': datetime.now(timezone.utc).isoformat()
    }) 