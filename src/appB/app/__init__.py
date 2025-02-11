from flask import Flask, jsonify
from .config import Config
import logging

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # Setup basic logging
    logging.basicConfig(level=app.config['LOG_LEVEL'])
    logger = logging.getLogger('app_b')

    # Register blueprints
    from .routes.monitor import monitor_bp
    app.register_blueprint(monitor_bp)

    # Add this to debug route registration
    logger.info("Registered routes:")
    for rule in app.url_map.iter_rules():
        logger.info(f"{rule.endpoint}: {rule.rule}")

    # Error handlers
    @app.errorhandler(404)
    def not_found_error(error):
        return jsonify({'error': 'Not Found', 'status': 404}), 404

    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({'error': 'Internal Server Error', 'status': 500}), 500

    return app 