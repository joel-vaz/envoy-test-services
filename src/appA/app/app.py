from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route('/hello', methods=['GET'])
def hello():
    return jsonify({'message': 'Hello from AppA!'})

@app.route('/whoami', methods=['GET'])
def whoami():
    return jsonify({'service': 'AppA'})

@app.route('/calculate/add', methods=['POST'])
def calculate_add():
    data = request.get_json()
    result = data['x'] + data['y']
    return jsonify({'result': result})

@app.route('/calculate/int/<int:a>/<int:b>', methods=['POST'])
def calculate_int(a, b):
    result = a + b
    return jsonify({'result': result})

@app.route('/calculate/float/<float:a>/<float:b>', methods=['POST'])
def calculate_float(a, b):
    result = a + b
    return jsonify({'result': result})

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy'})