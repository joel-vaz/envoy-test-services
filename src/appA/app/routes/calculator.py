from flask import Blueprint, jsonify, request
import logging

calculator_bp = Blueprint('calculator', __name__)
logger = logging.getLogger('app_a')

@calculator_bp.route('/calculate/add', methods=['POST', 'GET'])
def add():
    try:
        if request.method == 'POST':
            data = request.get_json()
        else:  # GET method
            data = {
                'x': request.args.get('x'),
                'y': request.args.get('y')
            }
        logger.debug(f"Received calculation request: {data}")
        
        if not data or 'x' not in data or 'y' not in data:
            logger.warning("Missing parameters in request")
            return jsonify({
                'error': 'Missing required parameters: x and y',
                'status': 'error'
            }), 400

        try:
            x = float(data['x'])
            y = float(data['y'])
        except (TypeError, ValueError):
            logger.warning(f"Invalid number format: x={data['x']}, y={data['y']}")
            return jsonify({
                'error': 'Invalid number format',
                'status': 'error'
            }), 400

        result = x + y

        logger.info(f'Calculation performed: {x} + {y} = {result}')
        
        return jsonify({
            'result': result,
            'operation': 'addition',
            'x': x,
            'y': y,
            'status': 'success'
        })
    except Exception as e:
        logger.error(f'Calculation error: {str(e)}')
        return jsonify({
            'error': 'Internal server error',
            'status': 'error'
        }), 500 