*** Settings ***
Library     ../custom/internal_json.py
Library     ../custom/headless_download.py
Library     OperatingSystem
Library     SeleniumLibrary
Library     Collections
Library     String
Library     XvfbRobot
Resource    launcher.robot
Resource    global_constants.robot
Resource    ../variables/url_extension.robot

*** Variables ***
${HELP_LAUNCHER}  css=#launcher
${TOS_AGREE_BTN}  css=[data-digix="TOC-READ-AGREE"]
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
    Wait Until Element Should Be Enabled  ${p_locator}
    Set Focus To Element  ${p_locator}
    Click Element  ${p_locator}

Wait Until Element Should Be Enabled
    [Arguments]    ${p_locator}
    Wait Until Element Is Enabled  ${p_locator}  timeout=${g_TIMEOUT_SEC}

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

Element Should Contain Text
  [Arguments]  ${p_locator}  ${p_text}
  Wait Until Element Should Be Visible  ${p_locator}
  Element Should Contain  ${p_locator}  ${p_text}  ignore_case=${TRUE}

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
Wait Until New Window Pops Up
  [Arguments]  ${p_count}
  Return Windows Count
  :FOR  ${index}  IN RANGE  0  5
  \  ${t_same}=  Evaluate  '${tc_COUNT}'=='${p_count}'
  \  Run Keyword If  ${t_same}  Run Keywords
  ...  Exit For Loop
  ...  ELSE  Return Windows Count

Return Windows Count
  ${t_windows}=  Get Window Handles  #Get Window Identifiers
  ${t_count}=  Get Length  ${t_windows}
  Set Test Variable  ${tc_COUNT}  ${t_count}

Upload TestData Image
  [Arguments]  ${p_filename}
  Load JQuery Tool
  ${t_path}=  Normalize Path  ${CURDIR}/../testdata/images/${p_filename}.png
  Modify Element Attribute Via jQuery  ${${p_filename}_UPLOAD_BTN}  display  block
  Wait Until Element Should Be Visible  ${${p_filename}_UPLOAD_BTN}
  Choose File  ${${p_filename}_UPLOAD_BTN}  ${t_path}

User Submits Keystore Password
  ${t_lower}=  Convert To Lowercase  ${s_WALLET_TYPE}
  Run Keyword If  '${t_lower}'=='metamask'  Run Keywords
  ...  Wait Until Element Should Be Visible  ${GOVERNANCE_MODAL}
  ...  AND  Wait Until New Window Pops Up  2
  ...  AND  Select Window  new
  ...  AND  Wait And Click Element  css=.btn-confirm
  ...  AND  Wait Until New Window Pops Up  1
  ...  AND  Select Window  main
  ...  ELSE  Run Keywords
  ...  Wait Until Element Should Be Visible  ${IMPORT_PASSWORD_FIELD}
  ...  AND  Input Text  ${IMPORT_PASSWORD_FIELD}  ${${ENVIRONMENT}_DAO__WALLET_PW}
  ...  AND  Wait And Click Element  ${UNLOCK_WALLET_BTN}

LookUp Value On Info Server
  [Arguments]  ${p_address}  ${p_lookUp}
  ${t_url}=  Set Variable  ${${ENVIRONMENT}_INFO_SERVER_URL}/address/${p_address}
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

Generate Suite Unique Value
  ${t_time}=  Get Time  epoch
  Set Suite Variable  ${s_UNIQUE}  ${t_time}

Open SideNav Menu If Not Visible
  ${t_visible}=  Run Keyword And Return Status
  ...  Element Should Be Visible  ${HAMBURGER_CLOSE_ICON}
  Run Keyword Unless  ${t_visible}  Run Keywords
  ...  Click Element  ${HAMBURGER_MENU}
  ...  AND  Wait Until Element Should Be Visible  ${HAMBURGER_CLOSE_ICON}

Accept DigixDao Terms and Condition
  Wait Until Element Should Be Visible  ${TOS_AGREE_BTN}
  Execute Javascript  var test=document.querySelector('[id="overlayDiv"]'); test.scrollTop +=test.scrollHeight
  Wait And Click Element  ${TOS_AGREE_BTN}

Pull Project Creator Name
  ${t_isNotVisible}=  Run Keyword And Return Status
  ...  Element Should Not Be Visible  ${SIDE_NAV_USER_LABEL}
  Run Keyword If  ${t_isNotVisible}
  ...  Click Element  ${HAMBURGER_MENU}
  ${t_value}=  Get Text  ${SIDE_NAV_USER_LABEL}
  ${t_text}=  Fetch From Right  ${t_value}  ,
  ${t_remove}=  Remove String  ${t_text}  ${SPACE}  !
  Set Suite Variable  ${s_PROJECT_CREATOR}  ${t_remove}
