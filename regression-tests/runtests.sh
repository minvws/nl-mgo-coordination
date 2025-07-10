#This script can be used to run the regression tests locally.
#For that, you need to have the following variables available in your environment:
# USER, PASSWORD, environment
# The environment can be local, test or acc
export environment=acc

robot \
    --removekeywords tag:secrets\
    --loglevel TRACE:INFO \
    --outputdir=./results \
    -v USER: \
    -v PASSWORD: \
    -v BROWSER:chromium \
    -i local \
    tests/*

rebot --removekeywords tag:secrets --output results/final_output.xml results/output.xml