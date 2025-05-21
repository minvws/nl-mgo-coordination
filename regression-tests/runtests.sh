#This script can be used to run the regression tests locally.
#For that, you need to have the following variables available in your environment:
# USER, PASSWORD, environment
export environment=test

robot \
    --removekeywords tag:secrets\
    --loglevel TRACE:INFO \
    --outputdir=./results \
    -v USER: \
    -v PASSWORD: \
    -v BROWSER:chromium \
    -e fail \
    -e local \
    -i test \
    tests/*

rebot --removekeywords tag:secrets --output results/final_output.xml results/output.xml