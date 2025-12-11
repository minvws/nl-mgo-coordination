*** Settings ***
Documentation       Tests to cover the VAD POC
...                 NOTE: this suite currently runs only locally!
Resource            ../resources/globalResources.resource
Suite Setup         Open Browser
Test Tags           vad-poc    load    cbp    local


*** Variables ***
${DUMMY_DOMAIN}     localhost:8888
${CLIENT_ID}        006fbf34-a80b-4c81-b6e9-593600675fb1
${OIDC_LOGIN}       http://${HOST}/oidc/login


*** Test Cases ***
Auth Session in VAD POC
    [Documentation]    Go to VAD and Start the Auth Session
    Given The User Navigates To Vertrouwde AuthenticatieDienst
    Then The User Follows Up On The Login Steps
    When The User Can Fill In The User Profile Form
    And Auth Session Should Be Set
    Then They Should See Their Profile Page
    When The Cookie Is Renewed With New Expiry Date
    Then The User Should Not Need To Login Again
    And The User Can Logout

Extract User's Information
    [Documentation]    OIDC, follow redirects and get encrypted user info
    [Tags]    test    acc
    Given The User Makes A Call To The OIDC-start
    And The User Follows The Authorization Url
    Then The User Should See Their Information In The Callback Url

Cookie is expired
    [Documentation]    When Auth session is expired the user needs to login
    Given The User Is Requested To Login Again When The Session Is Expired
    And The Cookie Should Be Expired

Changing the URI on CBP cannot authenticate
    [Documentation]    Once the URI is changed on CBP, then MAX should not allow authenticating
    Given We Update The URI On CBP
    Then Vad Poc Should Not Authenticate


*** Keywords ***
Open Browser
    [Documentation]    Suite Setup for VAD POC
    VAR    @{list}    --disable-web-security    --allow-running-insecure-content    --ignore-certificate-errors
    Log To Console    %{ENVIRONMENT}
    Log To Console    ${BROWSER}
    New Browser    ${BROWSER}    args=${list}    slowMo=1
    New Context    ignoreHTTPSErrors=True

The User Navigates To Vertrouwde AuthenticatieDienst
    [Documentation]    Go to VAD and submit
    New Page    ${HOST}
    Get Text    a    contains    Vertrouwde AuthenticatieDienst poc
    Get Element    css=button[type="submit"]

The User Follows Up On The Login Steps
    [Documentation]    Login
    # Catch the GET /authorize call 'cause is needed later
    ${promise}    Promise To
    ...    Wait For Request
    ...    matcher=request => request.url().includes('/authorize?') && request.method() === 'GET'
    ...    timeout=5s
    # button: Login met Vertrouwde Authenticatiedienst
    Click    css=button[type="submit"]
    ${get_authorize_request}    Wait For    ${promise}
    Log    ${get_authorize_request}
    VAR    ${GET_AUTHORIZE_REQUEST}    ${get_authorize_request}    scope=SUITE
    Get Url    contains    ${MAX}/digid-mock
    Get Text    h1    contains    DigiD Mock
    Get Element    css=form[method="GET"] [id="bsn_inp"]
    Click    css=button[type="submit"]    # Login/Submit

The User Can Fill In The User Profile Form
    [Documentation]    Fill in the Form
    Wait Until Keyword Succeeds    30s    10s
    ...    Get Url    contains    ${HOST}/profile
    Get Text    h2    contains    User Profile
    Get Element    css=#full_name[value="${USER_NAME}"]
    Get Element    css=input#rid
    # Refresh RID
    Type Text    css=input#count    7
    Click    css=button#refreshRID
    Get Element Count    css=#ridsContainer li    ==    7

They Should See Their Profile Page
    [Documentation]    Submit form, assert
    Click    css=button#submitButton
    Get Text    div#responseContainer    contains    "lievelingskleur": "paars"

Auth Session Should Be Set
    [Documentation]    Check in Application's storage that cookie auth_session is set
    ...    Set cookie's value and expires as variables
    ${auth_session}    Get Cookie    auth_session    dict
    Log    ${auth_session}
    Should Be String    ${auth_session['value']}
    ${expiry_first_cookie}    Convert Date
    ...    ${auth_session}[expires]
    ...    exclude_millis=yes
    ...    date_format=%m.%d.%Y %H:%M
    VAR    ${EXPIRY_FIRST_COOKIE}    ${expiry_first_cookie}    scope=TEST
    VAR    ${AUTH_SESSION_VALUE}    ${auth_session['value']}    scope=SUITE

The Cookie Is Renewed With New Expiry Date
    [Documentation]    Make POST to the OIDC /renew endpoint using the cookie auth_session
    ...    Then check that time difference between the first cookie and the renewed is bigger than 0
    # We need to sleep 2s because otherwise the test execution is too fast and the cookie that
    # is being returned in the POST request has the exact same date
    Sleep    2s
    VAR    &{cookie}
    ...    auth_session=${AUTH_SESSION_VALUE}
    ...    domain=localhost
    ...    path=/
    ...    expires=${EXPIRY_FIRST_COOKIE}
    ...    httpOnly=True
    ...    secure=True
    ${response}    POST
    ...    https://${MAX}/auth/session/renew
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
    VAR    ${NEW_EXPIRY}    ${new_expiry}    scope=SUITE
    # Check that there is a difference between the old & new expiry date
    ${time_between}    Subtract Date From Date    ${NEW_EXPIRY}    ${EXPIRY_FIRST_COOKIE}
    Should Be True    ${time_between} > 0

The User Should Not Need To Login Again
    [Documentation]    After already logging in, DigiD step will be skipped when clicking 'Login met Vertrouwde Authenticatiedienst'
    Go To    ${HOST}/profile
    ${auth_session}    Get Cookie    auth_session    dict
    Log    ${auth_session}
    Log    ${auth_session}[expires]
    Go To    ${HOST}
    # button: Login met Vertrouwde Authenticatiedienst
    Click    css=button[type="submit"]
    # Digid Step should be skipped
    The User Can Fill In The User Profile Form

The User Is Requested To Login Again When The Session Is Expired
    [Documentation]    Wait until the GET /authorize returns the Digid-mock in the response
    Wait Until Keyword Succeeds    70 s    10 s    Check Digid Mock Appears In The Response

Check Digid Mock Appears In The Response
    [Documentation]    Verify that text 'digid-mock' is in the content of the GET /authorize response.
    VAR    &{cookie}
    ...    auth_session=${AUTH_SESSION_VALUE}
    ...    domain=localhost
    ...    path=/
    ...    expires=${NEW_EXPIRY}
    ...    httpOnly=True
    ...    secure=True
    ${response}    GET    ${GET_AUTHORIZE_REQUEST}    cookies=${cookie}    verify=${False}
    Status Should Be    200    ${response}    msg=GET /authorize call failed
    Log    ${response.content}
    Should Contain    ${response.content}    digid-mock

The Cookie Should Be Expired
    [Documentation]    Verify that current time is bigger than expiry time of cookie.
    ${new_expiry_epoch}    Convert Date
    ...    ${NEW_EXPIRY}
    ...    result_format=epoch
    ${now}    Get Time    format=epoch    time_=NOW
    Should Be True    ${now} > ${new_expiry_epoch}

The User Makes A Call To The OIDC-start
    [Documentation]    Does a POST to /oidc/start and verify 200 response. Then set's the AUTHORIZATION_URL variable
    [Tags]    secrets
    ${auth}    Evaluate    ("${USER}", "${PASSWORD}")
    ${response}    POST
    ...    http://${DVP_PROXY}/oidc/start
    ...    data={"client_callback_url":"https://${DUMMY_DOMAIN}/oidc/userinfo/callback"}
    ...    auth=${auth}
    Status Should Be    200    ${response}    msg=POST to /oidc/start failed Reason:\t${response.text}
    ${authorization_url}    Replace String    ${response.json()['authz_url']}    https://max:8006    https://${MAX}
    VAR    ${AUTHORIZATION_URL}    ${authorization_url}    scope=SUITE

The User Follows The Authorization Url
    [Documentation]    Follows all redirects of the authorization url and sets the final url as a variable.
    VAR    @{list}
    ...    --disable-web-security
    ...    --allow-running-insecure-content
    ...    --ignore-certificate-errors
    ...    --disable-features=IsolateOrigins,site-per-process
    New Browser    ${BROWSER}    args=${list}
    New Page    ${AUTHORIZATION_URL}
    # Assemble the URL to follow up on
    ${action}    Get Attribute    form    action
    ${bsn}    Get Property    input[name="bsn"]    value
    ${samlart}    Get Property    input[name="SAMLart"]    value
    ${relay}    Get Property    input[name="RelayState"]    value
    VAR    ${url_to_follow}    https://${MAX}/${action}?bsn=${bsn}&SAMLart=${samlart}&RelayState=${relay}
    Log    ${url_to_follow}
    ${final_url}    Follow Redirects    url=${url_to_follow}    stop_condition=userinfo=
    # Log the entire redirect chain
    Log    Redirect final url: ${final_url}
    Extract Userinfo Parameter    ${final_url}

Extract Userinfo Parameter
    [Documentation]    Get userinfo from url query params and set as variable
    [Arguments]    ${url}
    ${userinfo}    Get Query Param    ${url}    userinfo
    VAR    ${USERINFO}    ${userinfo}    scope=SUITE

The User Should See Their Information In The Callback Url
    [Documentation]    Decode with Base64 the userinfo found as parameter in the URL
    ...    and deduct user's name and check on RID's length
    ${decoded_userinfo}    Decode Base64 String    ${USERINFO}
    Should Contain    ${decoded_userinfo}    "full_name":"${USER_NAME}"
    Should Contain    ${decoded_userinfo}    "sub":
    ${userinfo_json}    Evaluate    json.loads('''${decoded_userinfo}''')    json
    Length Should Be    ${userinfo_json['rid']}    64

Decode Base64 String
    [Documentation]    Decode and return Base64 string
    [Arguments]    ${encoded_string}
    ${decoded}    Evaluate    base64.b64decode('${encoded_string}').decode('utf-8')    base64
    Log    ${decoded}
    RETURN    ${decoded}

The User Can Logout
    [Documentation]    User logs out and sees the text 'Login'
    # Logout
    Click    css=form[action="http://${HOST}/logout"] button[type="submit"]
    Get Text    h2    contains    Login

We Update The URI On CBP
    New Page    ${CBP}/clients/${CLIENT_ID}
    Take Screenshot    CBP-edit-client-page
    Focus    css=#id[value="${CLIENT_ID}"]
    Type Text    css=input[value="${OIDC_LOGIN}"]    http://${HOST}/oidc/login/fail
    Click    //button[contains(text(),"Client wijzigen")]
    Wait For Elements State    css=*[aria-label="succes"]    visible

Vad Poc Should Not Authenticate
    [Documentation]    Going to the VAD POC and trying to authenticate in MAX should not succeed since the URI is amended on CBP
    New Page    ${HOST}
    # button: Login met Vertrouwde Authenticatiedienst
    Click    //button[contains(text(),"Login met Vertrouwde Authenticatiedienst")]
    Wait For Elements State    //h2[contains(text(),"unauthorized_client")]    visible
