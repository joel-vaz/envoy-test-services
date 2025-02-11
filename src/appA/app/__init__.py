from flask import Flask, jsonify
from .config import Config
import logging

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # Setup basic logging
    logging.basicConfig(level=app.config['LOG_LEVEL'])
    logger = logging.getLogger('app_a')

    # Register blueprints
    from .routes.health import health_bp
    from .routes.hello import hello_bp
    from .routes.whoami import whoami_bp
    from .routes.calculator import calculator_bp

    app.register_blueprint(health_bp)
    app.register_blueprint(hello_bp)
    app.register_blueprint(whoami_bp)
    app.register_blueprint(calculator_bp)

    # Error handlers
    @app.errorhandler(404)
    def not_found_error(error):
        return jsonify({'error': 'Not Found', 'status': 404}), 404

    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({'error': 'Internal Server Error', 'status': 500}), 500

    return app 