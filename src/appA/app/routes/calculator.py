from flask import Blueprint, jsonify, request
import logging

calculator_bp = Blueprint('calculator', __name__)
logger = logging.getLogger('app_a')

@calculator_bp.route('/calculate/add', methods=['POST'])
def add():
    try:
        data = request.get_json()
        if not data or 'x' not in data or 'y' not in data:
            return jsonify({
                'error': 'Missing required parameters: x and y',
                'status': 'error'
            }), 400

        x = float(data['x'])
        y = float(data['y'])
        result = x + y

        logger.info(f'Calculation performed: {x} + {y} = {result}')
        
        return jsonify({
            'result': result,
            'operation': 'addition',
            'x': x,
            'y': y,
            'status': 'success'
        })
    except ValueError as e:
        logger.error(f'Invalid number format: {str(e)}')
        return jsonify({
            'error': 'Invalid number format',
            'status': 'error'
        }), 400
    except Exception as e:
        logger.error(f'Calculation error: {str(e)}')
        return jsonify({
            'error': 'Internal server error',
            'status': 'error'
        }), 500 