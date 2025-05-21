#!/bin/bash

set -euo pipefail

#This script can be used to run the regression tests against the integration docker compose services
#export environment=local
#export USER=XXX
#export PASSWORD=XXX

docker build -t regression-tests .

docker run --name regression-tests-container -d -i --network host \
    -e USER="$USER" \
    -e PASSWORD="$PASSWORD" \
    -e environment="$environment" \
    -v ./docker-results/:/home/pwuser/docker-results \
    regression-tests

docker exec --user pwuser regression-tests-container /bin/bash -c '
    cd /home/pwuser &&
    robot \
    --removekeywords name:Setup \
    --removekeywords tag:secrets \
    --loglevel TRACE:INFO \
    --outputdir=./docker-results \
    -v USER:"$USER" \
    -v PASSWORD:"$PASSWORD" \
    -v environment:"$environment" \
    -i "$TAG" \
    -i "local" \
    -e "fail,test" \
    -v BROWSER:chromium tests/
    rebot --removekeywords tag:secrets --output docker-results/final_output.xml docker-results/output.xml
    rm docker-results/output.xml
'

docker stop regression-tests-container
docker rm regression-tests-container