*** Settings ***
Documentation       MedMij Authentication in MGO.
...                 Read more:
...                 https://nextcloud.irealisatie.nl/apps/files/files/469290?dir=/MGO/03%20Development/Backend/DVP/Koppelingen&openfile=true
...                 This suite currently runs only against Test

Resource            ../resources/globalResources.resource

Suite Setup         Setup
Suite Teardown      Close Browser

Test Tags           dvp    test    acc


*** Test Cases ***
Obtain access token from MedMij
    [Documentation]    MedMij Authentication via InteropLAB
    Given we retrieve the signed urls from load
    Then the client does a POST request to the getstate endpoint
    And we check that each ZorgAanbieder has 1 gegevensdienst
#    Muting the following steps temporary, till we have prio to fix the connection to Interoplab
#    When the user navigates to the InteropLab page and logs-in
#    Then the user gives his permission


*** Keywords ***
Setup
    [Documentation]    First open the Browser in order to initiate a session with the BasicAuth
    [Tags]    secrets
    Log To Console    ${BROWSER}

    New Browser    ${BROWSER}
    New Page    https://${basicAuth_dvp_proxy}
    New Page    https://${basicAuth_load}

we retrieve the signed urls from load
    [Documentation]    make POST request to get all the organizations from Lo-ad
    [Tags]    secrets
    ${response}    POST
    ...    https://${basicAuth_load}/localization/organization/search
    ...    {"name":"test","city":"test"}
    Status Should Be
    ...    200
    ...    ${response}
    ...    msg=POST to /localization/organization/search failed Reason:\t${response.text}

    VAR    ${authorization_server_url}
    ...    ${response.json()['organizations'][0]['data_services'][0]['auth_endpoint']}
    ...    scope=TEST
    VAR    ${token_endpoint_url}
    ...    ${response.json()['organizations'][0]['data_services'][0]['token_endpoint']}
    ...    scope=TEST
    VAR    ${organizations}
    ...    ${response.json()['organizations']}
    ...    scope=TEST

we check that each ZorgAanbieder has 1 gegevensdienst
    [Documentation]    Iterate through the organizations from Lo-ad
    ...    and check that the Medmij Zorgaanbieders have only 1 data_service

    # Kwalificatie Medmij: BGZ
    ${Medmij_BGZ}    Filter from list for a given condition dict
    ...    ${organizations}
    ...    {"display_name": "Kwalificatie Medmij: BGZ"}

    ${count}    Get Length    ${Medmij_BGZ[0]["data_services"]}
    Should Be Equal As Integers    ${count}    1

    # Kwalificatie Medmij: PDFA
    ${Medmij_PDFA}    Filter from list for a given condition dict
    ...    ${organizations}
    ...    {"display_name": "Kwalificatie Medmij: PDFA"}

    ${count}    Get Length    ${Medmij_PDFA[0]["data_services"]}
    Should Be Equal As Integers    ${count}    1

    # Kwalificatie Medmij: VACCINATION_IMMUNIZATION
    ${Medmij_vaccin_immun}    Filter from list for a given condition dict
    ...    ${organizations}
    ...    {"display_name": "Kwalificatie Medmij: VACCINATION_IMMUNIZATION"}

    ${count}    Get Length    ${Medmij_vaccin_immun[0]["data_services"]}
    Should Be Equal As Integers    ${count}    1

    # Kwalificatie Medmij: GPDATA
    ${Medmij_GPDATA}    Filter from list for a given condition dict
    ...    ${organizations}
    ...    {"display_name": "Kwalificatie Medmij: GPDATA"}

    ${count}    Get Length    ${Medmij_GPDATA[0]["data_services"]}
    Should Be Equal As Integers    ${count}    1

the client does a POST request to the getstate endpoint
    [Documentation]    POST to /getstate and get the url_to_request
    [Tags]    secrets
    ${medmij_scope}    Set Variable    medmij.ontwikkel.verplicht.interoplab
    ${client_target_url}    Set Variable    https://client.example.com/callback

    ${response}    POST
    ...    https://${basicAuth_dvp_proxy}/getstate
    ...    data={"authorization_server_url":"${authorization_server_url}","token_endpoint_url":"${token_endpoint_url}","medmij_scope":"${medmij_scope}","client_target_url":"${client_target_url}"}
    Status Should Be    200    ${response}    msg=POST to /getstate failed Reason:\t${response.text}
    log    ${response.json()}
    VAR    ${interopLab_URL}    ${response.json()['url_to_request']}    scope=TEST

the user navigates to the InteropLab page and logs-in
    [Documentation]    follow the steps to log-in
    New Page    ${interopLab_URL}

    # Hide the survey pop-up
    Run Keyword And Ignore Error    Click    css=#hj-survey-toggle-1[aria-label="Hide survey"]

    # Click on Inloggen
    Click    css=a[href$="https://${host}/auth/callback"]
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

the user gives his permission
    [Documentation]    Toestemming geven steps
    ${url}    Get Url
    Should Contain    ${url}    ontwikkel/verplicht/

    # Click on the checkbox
    Click    css=#consent[type="checkbox"]

    # Toestemming geven
    Click    id=submit-consent
    # ON Submit we should check for a 200 response.
    # Currently there 's an ISE 500 error triggered.
