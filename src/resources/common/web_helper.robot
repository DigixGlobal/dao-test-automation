*** Settings ***
Library     ../custom/internal_json.py
Library     OperatingSystem
Library     SeleniumLibrary
Library     Collections
Library     String
Resource    launcher.robot
Resource    global_constants.robot
Resource    ../variables/url_extension.robot

*** Variables ***
${HELP_LAUNCHER}  css=#launcher
@{EXCLUDE_KNOWN_CONSOLE_LOG_LIST}
...    miketestmike

*** Keywords ***
User Is In "${e_URL_EXT}" Page
    Wait Until Keyword Succeeds    ${g_TIMEOUT}    ${g_INTERVAL}
    ...    Location Should Contain    ${${e_URL_EXT}_url_ext}

User Should Be Redirected To "${e_URL_EXT}" Page
    User Is In "${e_URL_EXT}" Page

#====================#
#  ELEMENT KEYWORDS  #
#====================#
Wait Until Element Should Be Visible
    [Arguments]    ${p_locator}
    Wait Until Element Is Visible  ${p_locator}  timeout=${g_TIMEOUT_SEC}

Wait Until Element Should Not Be Visible
    [Arguments]    ${p_locator}
    Wait Until Element Is Not Visible  ${p_locator}  timeout=${g_TIMEOUT_SEC}

Wait And Click Element
    [Arguments]  ${p_locator}
    Wait Until Element Is Visible  ${p_locator}  timeout=${g_TIMEOUT_SEC}
    Set Focus To Element  ${p_locator}
    Click Element  ${p_locator}

Wait Until Element Is Disabled
    [Arguments]  ${p_locator}
    Wait Until Keyword Succeeds    ${g_TIMEOUT}    ${g_INTERVAL}
    ...  Element Should Be Disabled  ${p_locator}

Wait Until ELement Should Contain
    [Arguments]  ${p_locator}  ${p_text}
    Wait Until Element Contains  ${p_locator}  ${p_text}  timeout=${g_TIMEOUT_SEC}

Wait Until ELement Should Not Contain
    [Arguments]  ${p_locator}  ${p_text}
    Wait Until Element Does Not Contain  ${p_locator}  ${p_text}  timeout=${g_TIMEOUT_SEC}

"${e_NAME}" Elements Should Be Visible
  :FOR  ${locator}  IN  @{${e_NAME}_ELEMENT_LIST}
  \  Wait Until Element Should Be Visible  ${locator}

Wait Until Element Should Be Enabled
  [Arguments]  ${p_locator}
  Wait Until Element Is Enabled  ${p_locator}  timeout=${g_TIMEOUT_SEC}

#===========================================#
#               CONSOLE LOGGER              #
#===========================================#
Log Console Errors
    Capture Page Screenshot
    ${t_consolelogs}=     Get Browser Logs
    ${t_consoleLogIsNotEmpty}=    Run Keyword And Return Status
    ...   Should Not Be Empty    ${t_consolelogs}
    Run Keyword If    ${t_consoleLogIsNotEmpty}
    ...    Append Logs Not On Excluded List    ${t_consolelogs}    ${EXCLUDE_KNOWN_CONSOLE_LOG_LIST}

Append Logs Not On Excluded List
    [Arguments]    ${p_consoleErrorContent}   ${t_excludedLogs}
    ${t_getLocation}=     Get Location
    Set Suite Documentation
    ...    \n\n\n[CONSOLE LOG LOCATED]: ${t_getLocation}\n\n[CONSOLE LOGS]\n\n    append=True
    :FOR  ${t_logContentPerLine}  IN  @{p_consoleErrorContent}
    \  Exclude Console Log If Known  ${t_excludedLogs}    ${t_logContentPerLine}

Exclude Console Log If Known
    [Arguments]    ${p_excludeLogs}    ${p_logContent}
    ${t_logToString}=    Convert To String    ${p_logContent}
    :FOR  ${t_valueOfLog}  IN  @{p_excludeLogs}
    \    ${t_excludedLogExist}=   Run Keyword And Return Status
    ...    Should Contain    ${t_logToString}    ${t_valueOfLog}
    \    Run Keyword If    ${t_excludedLogExist}    Run Keywords
    ...    Log    Known Console Error
    ...    AND    Exit For Loop
    ...    ELSE
    ...    Add Console Logs To Suite Documentation    ${p_logContent}

Add Console Logs To Suite Documentation
    [Arguments]    ${p_logContent}
    :FOR  ${t_indexKey}  IN  @{p_logContent}
    \    ${t_indexValue}=    Get From Dictionary     ${p_logContent}    ${t_indexKey}
    \    Set Suite Documentation    \n\n${t_indexKey} : ${t_indexValue}    append=True

#==========#
#  HELPER  #
#==========#
Load JQuery Tool
  Execute Javascript  (document.onload=function() {var script = document.createElement('script'); script.setAttribute("type", "text/javascript"); script.setAttribute("src", "https://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"); document.getElementsByTagName("head")[0].appendChild(script);})();
  :FOR  ${index}  IN RANGE  0  10
  \  ${t_val}=  Run Keyword And Return Status
  ...  Execute Javascript  return jQuery.active
  \  Run Keyword If  ${t_val}
  ...  Exit For Loop
  ...  ELSE  Sleep  1 s

Force Element Via jQuery
  [Arguments]  ${p_element}  ${p_action}
  ${t_extracted}=  Remove String Using Regexp  ${p_element}    ^.*?=
  Execute Javascript  jQuery('${t_extracted}').${p_action}()

Modify Element Attribute Via jQuery
  [Arguments]  ${p_locator}  ${p_key}  ${p_value}
  ${t_extractLocator}=    Remove String Using Regexp    ${p_locator}    ^.*?=
  ${r_elementCount}=    Execute Javascript
  ...   jQuery('${t_extractLocator}').css("${p_key}", "${p_value}")

Get Matching Locator Count
    [Documentation]   This keyword will count all possible elements in the page using jQuery length.
    ...    Do not use ID since it will only return 1 result. Use class as argument.
    [Arguments]    ${p_elementLocator}
    ${t_extractLocator}=    Remove String Using Regexp    ${p_elementLocator}    ^.*?=
    ${r_elementCount}=    Execute Javascript   return jQuery('${t_extractLocator}').length
    Log   ${r_elementCount}
    [Return]    ${r_elementCount}

#====================#
#  GENERIC KEYWORDS  #
#====================#
Upload TestData Image
  [Arguments]  ${p_filename}
  Load JQuery Tool
  ${t_path}=  Normalize Path  ${CURDIR}/../testdata/images/${p_filename}.png
  Modify Element Attribute Via jQuery  ${${p_filename}_UPLOAD_BTN}  visibility  visible
  Wait Until Element Should Be Visible  ${${p_filename}_UPLOAD_BTN}
  Choose File  ${${p_filename}_UPLOAD_BTN}  ${t_path}

User Submits Keystore Password
  Wait Until Element Should Be Visible  ${IMPORT_PASSWORD_FIELD}
  Input Text  ${IMPORT_PASSWORD_FIELD}  ${${ENVIRONMENT}_DAO__WALLET_PW}
  Wait And Click Element  ${UNLOCK_WALLET_BTN}

LookUp Value On Info Server
  [Arguments]  ${p_address}  ${p_lookUp}
  ${t_url}=  Set Variable  ${${ENVIRONMENT}_INFO_URL}/address/${p_address}
  ${t_lookup}=  Set Variable  ${p_lookUp}
  ${t_value}=  Find Value On Json URL  ${t_url}  ${p_lookUp}
  [Return]  ${t_value}

Hide SnackBar
  ${t_bar}=  Get Matching Locator Count  ${SNACK_BAR_DIV}
  :For  ${index}  IN RANGE  0  ${t_bar}
  \  Force Element Via jQuery  ${SNACK_BAR_DIV}:eq(${index})  hide

Hide Governance Header Menu
  Modify Element Attribute Via jQuery  ${GOVERNANCE_MENU}  display  none

Get SnackBar Text
  Wait Until Element Should Be Visible  ${SNACK_BAR_DIV}:last
  ${t_value}=  Get Text  ${SNACK_BAR_DIV}:last
  Log To Console  ${t_value}
