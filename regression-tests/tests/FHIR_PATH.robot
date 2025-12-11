*** Settings ***
Documentation       Fhir data request. From Load > Dvp_proxy > DVA Mock
...                 This suite can only run against the Test environment for now.
...                 That is because the DVA Mock is not available at the integration.
...                 The fhir calls are meant to connect us to external parties, not sure it
...                 makes sense to run the tests against Acceptance.
Resource            ../resources/globalResources.resource
Suite Setup         FHIR PATH Setup
Suite Teardown      Close Browser
Test Tags           load    mock    dvp    test


*** Test Cases ***
FHIR Path For BGZ Patient
    [Documentation]    BGZ: Call Load /search to get resource_endpoint and use it as header for dvp_proxy fhir/path
    [Tags]    acc
    Given We Retrieve The Organizations From Load
    When We Have The Resource Endpoint Of    BGZ
    Then We Can Forward The Client Request To The Healthcare Provider    BGZ

FHIR Path For BGLZ Patient
    [Documentation]    BGLZ: Call Load /search to get resource_endpoint and use it as header for dvp_proxy fhir/path
    When We Have The Resource Endpoint Of    BGLZ
    Then We Can Forward The Client Request To The Healthcare Provider    BGLZ


*** Keywords ***
FHIR PATH Setup
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

We Retrieve The Organizations From Load
    [Documentation]    make POST request to get all the organizations from Load
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
    VAR    ${ORGANIZATIONS}
    ...    ${response.json()['organizations']}
    ...    scope=SUITE

We Have The Resource Endpoint Of
    [Documentation]    Retrieve the resource endpoint for a given MedMij organization.
    [Arguments]    ${organization}
    VAR    ${display_name}    Kwalificatie Medmij: ${organization}
    ${org}    Filter From List For A Given Condition Dict
    ...    ${ORGANIZATIONS}
    ...    {"display_name": "${display_name}"}
    VAR    ${endpoint}    ${org[0]['data_services'][0]['roles'][0]['resource_endpoint']}
    VAR    ${${ORGANIZATION}_RESOURCE_ENDPOINT}    ${endpoint}    scope=TEST

We Can Forward The Client Request To The Healthcare Provider
    [Documentation]    Generic GET fhir/Patient
    ...    Usage: pass target suffix (eg BGZ) or pass explicit endpoint as 2nd arg.
    [Arguments]    ${target_suffix}
    VAR    &{headers}
    ...    X-MGO-DVA-TARGET=${${target_suffix}_RESOURCE_ENDPOINT}
    ...    Accept=application/fhir+json; fhirVersion=3.0
    VAR    &{required_params}
    ...    _include=Patient:general-practitioner
    ${response}    GET    http://${DVP_PROXY}/fhir/Patient    headers=${headers}    params=${required_params}
    Status Should Be    200    ${response}    msg=GET fhir/Patient failed
    Should Be Equal As Strings
    ...    ${response.json()['entry'][0]['resource']['resourceType']}
    ...    Patient
    ...    msg=resourceType was not Patient
