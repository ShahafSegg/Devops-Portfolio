#!/bin/bash

CONTAINER_NAME="app"

create_person() {
    timeout --foreground -s TERM 30s bash -c \
        'while [[ "$(docker compose exec "${CONTAINER_NAME}" curl -s -o /dev/null -w \"%{http_code}\" -X POST http://localhost:80/person/1 -H \"Content-Type: application/json\" -d '{\"name\": \"John Doe\", \"age\": 30}')" != "200" ]];\
        do echo "Creating person using POST..." && sleep 5;\
        done' "${1}"
    echo "${1} - OK!"
}

get_person() {
    timeout --foreground -s TERM 30s bash -c \
        'while [[ "$(docker compose exec "${CONTAINER_NAME}" curl -s -o /dev/null -w \"%{http_code}\" ${0})" != "200" ]];\
        do echo "Gettings person using GET" && sleep 5;\
        done' "${1}"
    echo "${1} - OK!"
}

delete_person() {
    echo "Deleting Person..."
    timeout --foreground -s TERM 30s bash -c \
        'while [[ "$(docker compose exec "${CONTAINER_NAME}" curl -s -o /dev/null -w \"%{http_code}\" -X DELETE http://localhost:80/person/1)" != "200" ]];\
        do echo "Deleting person using DELETE" && sleep 5;\
        done' "${1}"
    echo "${1} - OK!"
}

create_person
get_person
delete_person

echo "All tests passed!"
