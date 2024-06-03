from flask import Flask, request, jsonify, send_from_directory
from pymongo import MongoClient
import os
import sys
from prometheus_flask_exporter import PrometheusMetrics
import logging
from logging.handlers import RotatingFileHandler

app = Flask(__name__)

# Initialize Prometheus metrics exporter
metrics = PrometheusMetrics(app)


# Configure logging
file_handler = RotatingFileHandler('app.log', maxBytes=10240, backupCount=10)
file_handler.setLevel(logging.INFO)
formatter = logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
file_handler.setFormatter(formatter)
app.logger.addHandler(file_handler)
app.logger.setLevel(logging.INFO)

# MongoDB Configuration
mongo_uri = os.getenv('MONGO_URI', 'mongodb://localhost:27017/people_db')

# Connect to MongoDB
client = MongoClient(mongo_uri)
db = client.people_db
people_collection = db.people

# Log the incoming request
@app.before_request
def log_request_info():
    app.logger.info(f"Request: {request.method} {request.url} Headers: {request.headers} Body: {request.get_data()}")

# Log the response
@app.after_request
def log_response_info(response):
    app.logger.info(f"Response: {response.status} Headers: {response.headers}")
    return response

# Serve the index.html file at the root URL
@app.route('/')
def index():
    app.logger.info('Accessed index page')
    return send_from_directory('static', 'index.html')

# CRUD operations for managing people
@app.route('/person/<int:id>', methods=['POST'])
def create_person(id):
    data = request.json
    data['_id'] = id
    if people_collection.find_one({'_id': id}):
        app.logger.error('Person already exists')
        return jsonify({'error': 'Person already exists'}), 400
    people_collection.insert_one(data)
    app.logger.info('Person created successfully')
    return jsonify({'message': 'Person created successfully'}), 201

@app.route('/person/<int:id>', methods=['PUT'])
def update_person(id):
    data = request.json
    result = people_collection.update_one({'_id': id}, {'$set': data})
    if result.matched_count == 0:
        app.logger.error('Person not found')
        return jsonify({'error': 'Person not found'}), 404
    app.logger.info('Person updated successfully')
    return jsonify({'message': 'Person updated successfully'})

@app.route('/person/<int:id>', methods=['DELETE'])
def delete_person(id):
    result = people_collection.delete_one({'_id': id})
    if result.deleted_count == 0:
        app.logger.error('Person not found')
        return jsonify({'error': 'Person not found'}), 404
    app.logger.info('Person deleted successfully')
    return jsonify({'message': 'Person deleted successfully'})

@app.route('/person/<int:id>', methods=['GET'])
def get_person(id):
    person = people_collection.find_one({'_id': id})
    if not person:
        app.logger.error('Person not found')
        return jsonify({'error': 'Person not found'}), 404
    app.logger.info('Person retrieved successfully')
    return jsonify(person)

@app.route('/person', methods=['GET'])
def get_all_people():
    people = people_collection.find({})
    people_details = []
    for person in people:
        person_details = {
            'id': person['_id'],
            'name': person.get('name', ''),
            'age': person.get('age', '')
        }
        people_details.append(person_details)
    app.logger.info('All people retrieved successfully')
    return jsonify(people_details)

@app.route('/api/hello', methods=['GET'])
def hello():
    app.logger.info('Hello route accessed')
    return jsonify({'message': 'Hello, World!'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
