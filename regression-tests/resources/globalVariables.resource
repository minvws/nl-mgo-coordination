*** Settings ***
Documentation       Set up global variables

Variables           variables.py


*** Variables ***
${basicAuth_load}           ${USER}:${PASSWORD}@${load}
${basicAuth_dvp_proxy}      ${USER}:${PASSWORD}@${dvp_proxy}
