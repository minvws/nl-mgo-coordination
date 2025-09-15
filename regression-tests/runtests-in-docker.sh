#!/bin/bash

set -euo pipefail

#This script can be used to run the regression tests against the integration docker compose services
#export ENVIRONMENT=local
#export HTACCESS_USER=XXX
#export HTACCESS_PASSWORD=XXX

docker build -t regression-tests .

docker run --name regression-tests-container -d -i --network host \
    -e HTACCESS_USER="$HTACCESS_USER" \
    -e HTACCESS_PASSWORD="$HTACCESS_PASSWORD" \
    -e ENVIRONMENT="$ENVIRONMENT" \
    -v ./docker-results/:/home/pwuser/docker-results \
    regression-tests

docker exec --user pwuser regression-tests-container /bin/bash -e -c '
    cd /home/pwuser &&
    .venv/bin/robot \
      --removekeywords name:Setup \
      --removekeywords tag:secrets \
      --loglevel TRACE:INFO \
      --outputdir=./docker-results \
      -v HTACCESS_USER:"$HTACCESS_USER" \
      -v HTACCESS_PASSWORD:"$HTACCESS_PASSWORD" \
      -v ENVIRONMENT:"$ENVIRONMENT" \
      -i "$TAG" \
      -i "local" \
      -e "fail,test" \
      -v BROWSER:chromium tests/
    ROBOT_EXIT=$?
    .venv/bin/rebot --removekeywords tag:secrets --output docker-results/final_output.xml docker-results/output.xml || true
    exit $ROBOT_EXIT
'

docker stop regression-tests-container
docker rm regression-tests-container