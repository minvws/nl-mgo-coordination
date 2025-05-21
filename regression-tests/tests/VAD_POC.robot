*** Settings ***
Documentation       Tests to cover the VAD POC
...                 NOTE: this suite currently runs only locally!

Resource            ../resources/globalResources.resource

Suite Setup         Setup

Test Tags           vad-poc    load    local


*** Variables ***
${dummy_domain}     localhost:8888


*** Test Cases ***
Auth Session in VAD POC
    [Documentation]    Go to VAD and Start the Auth Session
    Given The user navigates to Vertrouwde AuthenticatieDienst
    Then the user follows up on the login steps
    When the user can fill in the User Profile form
    And Auth session should be set
    Then they should see their profile page
    When The cookie is renewed with new expiry date
    Then the user should not need to login again
    And The User Can Logout

Extract User's Information
    [Documentation]    OIDC, follow redirects and get encrypted user info
    [Tags]    test
    Given the user makes a call to the OIDC-start
    And The user follows the authorization url
    Then the user should see their information in the callback url

Cookie is expired
    [Documentation]    When Auth session is expired the user needs to login
    Given The user is requested to login again when the session is expired
    And The cookie should be expired


*** Keywords ***
Setup
    ${list}    Create List    --disable-web-security    --allow-running-insecure-content    --ignore-certificate-errors
    New Browser    ${BROWSER}    args=${list}
    New Context    ignoreHTTPSErrors=True

## Auth Session in VAD POC

The user navigates to Vertrouwde AuthenticatieDienst
    [Documentation]    Go to VAD and submit
    New Page    ${host}
    Get Text    a    contains    Vertrouwde AuthenticatieDienst poc
    Get Element    css=button[type="submit"]

the user follows up on the login steps
    [Documentation]    Login
    # Catch the GET /authorize call 'cause is needed later
    ${promise}    Promise to
    ...    Wait For Request
    ...    matcher=request => request.url().includes('/authorize?') && request.method() === 'GET'
    ...    timeout=5s
    # button: Login met Vertrouwde Authenticatiedienst
    Click    css=button[type="submit"]
    ${GET_authorize_request}    Wait for    ${promise}
    Log    ${GET_authorize_request}
    VAR    ${GET_authorize_request}    ${GET_authorize_request}    scope=SUITE

    Get Url    *=    ${max}/digid-mock
    Get Text    h1    contains    DigiD MOCK
    Get Element    css=form[method="GET"] [id="bsn_inp"]

    Click    css=a#submit_two    # Login/Submit

the user can fill in the User Profile form
    [Documentation]    Fill in the Form
    Wait Until Keyword Succeeds    30s    10s
    ...    Get Url    *=    ${host}/profile
    Get Text    h2    contains    User Profile
    Get element    css=#full_name[value="${user_name}"]
    Get Element    css=input#rid

    # Refresh RID
    Type Text    css=input#count    7
    Click    css=button#refreshRID
    Get Element Count    css=#ridsContainer li    ==    7

they should see their profile page
    [Documentation]    Submit form, assert
    Click    css=button#submitButton
    Get Text    div#responseContainer    contains    "lievelingskleur": "paars"

Auth session should be set
    [Documentation]    Check in Application's storage that cookie auth_session is set
    ...    Set cookie's value and expires as variables
    ${auth_session}    Get Cookie    auth_session    dict
    log    ${auth_session}
    Should Be String    ${auth_session['value']}

    ${expiry_first_cookie}    Convert Date
    ...    ${auth_session}[expires]
    ...    exclude_millis=yes
    ...    date_format=%m.%d.%Y %H:%M
    VAR    ${expiry_first_cookie}    ${expiry_first_cookie}    scope=SUITE
    VAR    ${auth_session_value}    ${auth_session['value']}    scope=SUITE

The cookie is renewed with new expiry date
    [Documentation]    Make POST to the OIDC /renew endpoint using the cookie auth_session
    ...    Then check that time difference between the first cookie and the renewed is bigger than 0
    # We need to sleep 2s because otherwise the test execution is too fast and the cookie that
    # is being returned in the POST request has the exact same date
    Sleep    2s
    &{cookie}    Create Dictionary
    ...    auth_session=${auth_session_value}
    ...    domain=localhost
    ...    path=/
    ...    expires=${expiry_first_cookie}
    ...    httpOnly=True
    ...    secure=True
    ${response}    POST
    ...    ${max}/auth/session/renew
    ...    verify=${False}
    ...    cookies=${cookie}
    Status Should Be    204    ${response}    msg=POST to max/auth/session/renew failed Reason:\t${response.text}
    ${response_headers}    Get From Dictionary    ${response.headers}    set-cookie
    Log    ${response_headers}

    # Get the expiry date of the new cookie out of the response headers using regex
    ${expires}    Evaluate    re.search(r"expires=(.*?); HttpOnly", """${response_headers}""").group(1)    re

    ${new_expiry}    Convert Date
    ...    ${expires}
    ...    exclude_millis=yes
    ...    date_format=%a, %d %b %Y %H:%M:%S %Z
    VAR    ${new_expiry}    ${new_expiry}    scope=SUITE
    # Check that there is a difference between the old & new expiry date
    ${time_between}    Subtract Date From Date    ${new_expiry}    ${expiry_first_cookie}
    Should Be True    ${time_between} > 0

the user should not need to login again
    Go to    ${host}/profile
    ${auth_session}    Get Cookie    auth_session    dict
    log    ${auth_session}
    log    ${auth_session}[expires]

    Go to    ${host}
    # button: Login met Vertrouwde Authenticatiedienst
    Click    css=button[type="submit"]
    # Digid Step should be skipped
    the user can fill in the User Profile form

## Cookie is expired

The user is requested to login again when the session is expired
    [Documentation]    Wait until the GET /authorize returns the Digid-mock in the response
    Wait Until Keyword Succeeds    70 s    10 s    Check digid mock appears in the response

Check digid mock appears in the response
    &{cookie}    Create Dictionary
    ...    auth_session=${auth_session_value}
    ...    domain=localhost
    ...    path=/
    ...    expires=${new_expiry}
    ...    httpOnly=True
    ...    secure=True
    ${response}    GET    ${GET_authorize_request}    cookies=${cookie}    verify=${False}
    Status Should Be    200    ${response}    msg=GET /authorize call failed
    Log    ${response.content}
    Should Contain    ${response.content}    digid-mock

The cookie should be expired
    ${new_expiry_epoch}    Convert Date
    ...    ${new_expiry}
    ...    result_format=epoch
    ${now}    Get Time    format=epoch    time_=NOW
    Should Be True    ${now} > ${new_expiry_epoch}

## Extract User's Information

the user makes a call to the OIDC-start
    [Tags]    secrets
    ${response}    POST
    ...    http://${basicAuth_dvp_proxy}/oidc/start
    ...    data={"client_callback_url":"https://${dummy_domain}/oidc/userinfo/callback"}
    Status Should Be    200    ${response}    msg=POST to /oidc/start failed Reason:\t${response.text}
    ${authorization_URL}    Replace String    ${response.json()['authz_url']}    https://max:8006    ${max}
    VAR    ${authorization_URL}    ${authorization_URL}    scope=SUITE

The user follows the authorization url
    ${list}    Create List
    ...    --disable-web-security
    ...    --allow-running-insecure-content
    ...    --ignore-certificate-errors
    ...    --disable-features=IsolateOrigins,site-per-process
    New Browser    ${BROWSER}    args=${list}
    New Page    ${authorization_URL}
    ${href_value}    Get Attribute    css=a#submit_two    href
    ${href_value}    catenate    SEPARATOR=/    ${max}    ${href_value}

    ${final_url}    Follow Redirects    ${href_value}    userinfo=

    # Log the entire redirect chain
    Log    Redirect final url: ${final_url}

    Extract Userinfo Parameter    ${final_url}

Extract Userinfo Parameter
    [Arguments]    ${url}
    ${userinfo}    Get Query Param    ${URL}    userinfo
    VAR    ${userinfo}    ${userinfo}    scope=SUITE

the user should see their information in the callback url
    [Documentation]    Decode with Base64 the userinfo found as parameter in the URL
    ...    and deduct user's name and check on RID's length
    ${decoded_userinfo}    Decode Base64 String    ${userinfo}
    Should Contain    ${decoded_userinfo}    "full_name":"${user_name}"
    Should Contain    ${decoded_userinfo}    "sub":

    ${userinfo_json}    evaluate    json.loads('''${decoded_userinfo}''')    json
    Length Should Be    ${userinfo_json['rid']}    64

Decode Base64 String
    [Arguments]    ${encoded_string}
    ${decoded}    Evaluate    base64.b64decode('${encoded_string}').decode('utf-8')    base64
    Log    ${decoded}
    RETURN    ${decoded}

the user can logout
    # Logout
    Click    css=form[action="${host}/logout"] button[type="submit"]
    Get Text    h2    contains    Login
