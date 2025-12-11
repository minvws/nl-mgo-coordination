*** Settings ***
Documentation       Test the connection of CBP > MAX-VAD
...                 Via the web interface of the Cliëntbeheerportaal, CBP, create an active client
...                 use the newly created client ID to authorize via MAX-VAD
Resource            ../resources/globalResources.resource
Suite Setup         Setup CBP
Suite Teardown      Close Browser
Test Tags           cbp    max-vad    local


*** Variables ***
${DOMAIN_SUFFIX}        example.com
${PROTOCOL}             https
${RF_URI}               ${EMPTY}
${CLIENT_ID}            ${EMPTY}
${NONCE}                b22a20cc4b05d9c5cb4c2b688cdd20df
${STATE}                23d30cd64d9a43cb2cfd0675fbec4410
${CODE_CHALLENGE}       4A4C_IRNoTjNtHdb_-4COMSAaQwb2KwmhcK76r3Ecs4


*** Test Cases ***
Create a client on CBP application
    [Documentation]    Via the web interface create a client. Max service should be able to request the updated list
    Given We Generate Random URI
    When The User Creates A Client In The CBP Portal
    Then The Client Should Be Available

New Client should be able to get authorized
    [Documentation]    OIDC flow with new client
    ...    Depends on the above test case
    And The New Client Should Be Able To Get Authorized


*** Keywords ***
Setup CBP
    New Browser    ${BROWSER}
    New Page    ${CBP}
    Take Screenshot    open-cbp-page
    ${url}    Get Url
    Should Contain    ${url}    /dashboard

We Generate Random URI
    [Documentation]    Generate a random string and use it for the new Client's URI.
    ...    The URI is the redirect address where the client is sent after successfully authenticating with the VAD service.
    ${random_part}    Generate Random String    8    [LOWER]
    VAR    ${RANDOM_URI}    ${PROTOCOL}://${random_part}.${DOMAIN_SUFFIX}    scope=TEST

The User Creates A Client In The CBP Portal
    Click    css=a[href$="clients"]
    Focus    //h1[contains(text(),"Clients")]
    Click    css=a.button[href$="create"]
    Click    css=input[placeholder="Organisatie"]
    Click    # Click first Organization
    ...    css=#searchable-select-organisation_id .searchable-select-option[tabindex="0"]
    Click    css=input[placeholder="Token Endpoint Auth Methode"]
    Click    # Click first Auth Method
    ...    css=#searchable-select-token_endpoint_auth_method .searchable-select-option:first-of-type
    Type Text    css=input[type="url"]    ${RANDOM_URI}
    Click    css=button[aria-label="Voeg toe"]
    VAR    ${RF_URI}    ${RANDOM_URI}/robot-framework    scope=SUITE
    Type Text    css=.two-thirds-one-third:last-of-type input    ${RF_URI}
    Focus    id=active
    Click    css=#active + span
    Sleep    1s    # clicking on the toggle
    Click    css=button.cta[type="submit"]
    Wait For Elements State    css=*[aria-label="succes"]    visible

The Client Should Be Available
    [Documentation]    Check that the new client is part of the clients' json on CBP
    Go To    ${CBP}/api/v1/clients
    ${clients_text}    Get Text    css=body pre
    ${clients_json}    Evaluate    json.loads('''${clients_text}''')    json
    Log    ${clients_json}
    Should Be Equal As Strings    ${clients_json['clients'][-1]['redirect_uris'][-1]}    ${RF_URI}
    VAR    ${CLIENT_ID}    ${clients_json['clients'][-1]['id']}    scope=SUITE

The New Client Should Be Able To Get Authorized
    [Documentation]    GET /authorize on MAX-VAD using the new client id
    VAR    &{params}
    ...    response_type=code
    ...    redirect_uri=${RF_URI}
    ...    client_id=${CLIENT_ID}
    ...    nonce=${NONCE}
    ...    state=${STATE}
    ...    scope=openid
    ...    code_challenge=${CODE_CHALLENGE}
    ...    code_challenge_method=S256
    ${response}    GET
    ...    https://${MAX}/authorize
    ...    params=${params}
    ...    verify=${False}
    Status Should Be    200    ${response}    msg=GET /authorize call failed Reason:\t${response.text}
    Log    ${response.content}
    Should Contain    ${response.content}    digid-mock
