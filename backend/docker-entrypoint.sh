#!/bin/bash -e

if [[ "${1}" == "dev" ]]; then
    python3 manage.py migrate
    python3 manage.py runserver 0.0.0.0:8000
elif [[ "${1}" == "test" ]]; then
    pyresttest proxy:8080 ./tests/api.yml
else
    exec "${@}"
fi