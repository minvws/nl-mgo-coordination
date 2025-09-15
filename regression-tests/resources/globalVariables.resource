*** Settings ***
Documentation       Set up global variables

Variables           variables.py


*** Variables ***
${USER}    %{HTACCESS_USER}
${PASSWORD}    %{HTACCESS_PASSWORD}
