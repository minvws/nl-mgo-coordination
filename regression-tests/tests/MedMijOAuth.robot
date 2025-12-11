*** Settings ***
Documentation       MedMij Authentication in MGO.
...                 Read more:
...                 https://nextcloud.irealisatie.nl/apps/files/files/469290?dir=/MGO/03%20Development/Backend/DVP/Koppelingen&openfile=true
...                 This suite currently runs only against Test
Resource            ../resources/globalResources.resource
Suite Setup         Setup
Suite Teardown      Close Browser
Test Tags           load    dvp    local    test    acc


*** Test Cases ***
Obtain access token from MedMij
    [Documentation]    MedMij Authentication via InteropLAB
    Given We Retrieve The Signed Urls From Load
    Then The Client Does A POST Request To The Getstate Endpoint
    And We Check That Each ZorgAanbieder Has 1 Gegevensdienst
#    Muting the following steps temporary, till we have prio to fix the connection to Interoplab
#    When the user navigates to the InteropLab page and logs-in
#    Then the user gives his permission


*** Keywords ***
Setup
    [Documentation]    First open the Browser in order to initiate a session with the BasicAuth
    [Tags]    secrets
    Log To Console    ${BROWSER}
    New Browser    ${BROWSER}
    IF    '%{ENVIRONMENT}' == 'local'
        New Page    http://${DVP_PROXY}
        New Page    http://${LOAD}
    ELSE
        New Page    https://${USER}:${PASSWORD}@${DVP_PROXY}
        New Page    https://${USER}:${PASSWORD}@${LOAD}
    END

We Retrieve The Signed Urls From Load
    [Documentation]    make POST request to get all the organizations from Lo-ad
    [Tags]    secrets
    ${auth}    Evaluate    ("${USER}", "${PASSWORD}")
    ${response}    POST
    ...    http://${LOAD}/localization/organization/search
    ...    {"name":"test","city":"test"}
    ...    auth=${auth}
    Status Should Be
    ...    200
    ...    ${response}
    ...    msg=POST to /localization/organization/search failed Reason:\t${response.text}
    VAR    ${AUTHORIZATION_SERVER_URL}
    ...    ${response.json()['organizations'][0]['data_services'][0]['auth_endpoint']}
    ...    scope=TEST
    VAR    ${TOKEN_ENDPOINT_URL}
    ...    ${response.json()['organizations'][0]['data_services'][0]['token_endpoint']}
    ...    scope=TEST
    VAR    ${ORGANIZATIONS}
    ...    ${response.json()['organizations']}
    ...    scope=TEST

We Check That Each ZorgAanbieder Has 1 Gegevensdienst
    [Documentation]    Iterate through the organizations from Lo-ad
    ...    and check that the Medmij Zorgaanbieders have only 1 data_service
    Validate Medmij Org Has One Data Service    ${ORGANIZATIONS}    Kwalificatie Medmij: BGZ
    Validate Medmij Org Has One Data Service    ${ORGANIZATIONS}    Kwalificatie Medmij: PDFA
    Validate Medmij Org Has One Data Service    ${ORGANIZATIONS}    Kwalificatie Medmij: BGLZ
    Validate Medmij Org Has One Data Service
    ...    ${ORGANIZATIONS}
    ...    Kwalificatie Medmij: VACCINATION_IMMUNIZATION
    Validate Medmij Org Has One Data Service    ${ORGANIZATIONS}    Kwalificatie Medmij: GPDATA

Validate Medmij Org Has One Data Service
    [Documentation]    Use custom keyword to filter out a dictionary for a specific organization
    [Arguments]    ${organizations}    ${zorgaanbieder}
    ${filtered}    Filter From List For A Given Condition Dict
    ...    ${organizations}
    ...    {"display_name": "${zorgaanbieder}"}
    ${count}    Get Length    ${filtered[0]["data_services"]}
    Should Be Equal As Integers    ${count}    1

The Client Does A POST Request To The Getstate Endpoint
    [Documentation]    POST to /getstate and get the url_to_request
    VAR    ${medmij_scope}    medmij.ontwikkel.verplicht.interoplab
    VAR    ${client_target_url}    https://client.example.com/callback
    ${response}    POST
    ...    http://${DVP_PROXY}/getstate
    ...    data={"authorization_server_url":"${AUTHORIZATION_SERVER_URL}","token_endpoint_url":"${TOKEN_ENDPOINT_URL}","medmij_scope":"${medmij_scope}","client_target_url":"${client_target_url}"}
    Status Should Be    200    ${response}    msg=POST to /getstate failed Reason:\t${response.text}
    Log    ${response.json()}
    VAR    ${INTEROP_LAB_URL}    ${response.json()['url_to_request']}    scope=TEST

The User Navigates To The InteropLab Page And Logs-in
    [Documentation]    follow the steps to log-in
    New Page    ${INTEROP_LAB_URL}
    # Hide the survey pop-up
    Run Keyword And Ignore Error    Click    css=#hj-survey-toggle-1[aria-label="Hide survey"]
    # Click on Inloggen
    Click    css=a[href$="https://${HOST}/auth/callback"]
    Get Text    css=#gegevensdiensten h2    contains    Gegevensdiensten
    Wait For Elements State
    ...    css=button[onclick*="openPatienten"]:first-of-type
    ...    enabled
    ...    70s
    ...    message=Afspraken option is not enabled
    Click    css=button[onclick*="openPatienten"]:first-of-type
    Get Text    css=#kiesTestdossier h2    contains    Kies een testdossier
    Wait For Elements State
    ...    css=button[onclick="openPatient('example_eafspraak_kwalificatie1', this)"]
    ...    enabled
    ...    70s
    ...    message=Kwalificatie 1 button is not enabled
    Click    css=button[onclick="openPatient('example_eafspraak_kwalificatie1', this)"]
    Get Text    css=#example_eafspraak_kwalificatie1 h2    contains    Kwalificatie 1
    # Click on Inloggen
    Click    css=#example_eafspraak_kwalificatie1 div form[method="post"] button[type="submit"]

The User Gives His Permission
    [Documentation]    Toestemming geven steps
    ${url}    Get Url
    Should Contain    ${url}    ontwikkel/verplicht/
    # Click on the checkbox
    Click    css=#consent[type="checkbox"]
    # Toestemming geven
    Click    id=submit-consent
    # ON Submit we should check for a 200 response.
    # Currently there 's an ISE 500 error triggered.
