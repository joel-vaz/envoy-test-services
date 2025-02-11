from flask import Blueprint, jsonify
import logging

hello_bp = Blueprint('hello', __name__)
logger = logging.getLogger('app_a')

@hello_bp.route('/hello')
def hello():
    logger.info('Hello endpoint called')
    return jsonify({
        'message': 'Hello, World!',
        'status': 'success'
    }) 