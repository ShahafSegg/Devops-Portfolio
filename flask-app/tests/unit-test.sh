#!/bin/bash

API_URL="http://0.0.0.0:5000"

POST_DATA='{
    "name": "roey",
    "age": "22"
}'

# Run a local mongodb
docker run -d --name mongo -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=rootpassword -p 27017:27017 mongo:4.4

echo "Testing POST request..."
curl -s -X POST -H "Content-Type: application/json" -d "${POST_DATA}" "$API_URL/person/1"

echo "Testing GET request..."
curl -s -X GET "$API_URL"

echo "Testing DELETE request..."
curl -s -X DELETE "$API_URL"

echo "All tests passed!"
