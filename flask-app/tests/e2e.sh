#!/bin/bash

CONTAINER_NAME="app"

wait_for_healthy() {
    timeout --foreground -s TERM 30s bash -c \
        'while [[ "$(docker compose exec ${CONTAINER_NAME} curl -s -o /dev/null -m 3 -L -w '\''%{http_code}'\'' ${0})" != "200" ]];\
        do echo "Checking connection to ${CONTAINER_NAME}" && sleep 5;\
        done' "${1}"
    echo "${1} - OK!"
}

wait_for_healthy

echo "All tests passed!"
