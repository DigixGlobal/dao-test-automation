*** Settings ***
Library     Collections
Library     OperatingSystem
Library     String
Library     SeleniumLibrary
Library     ../custom/internal_json.py
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

Upload TestData Image
  [Arguments]  ${p_filename}
  Load JQuery Tool
  ${t_path}=  Normalize Path  ${CURDIR}/../testdata/images/${p_filename}.png
  Modify Element Attribute Via jQuery  ${${p_filename}_UPLOAD_BTN}  visibility  visible
  Wait Until Element Should Be Visible  ${${p_filename}_UPLOAD_BTN}
  Choose File  ${${p_filename}_UPLOAD_BTN}  ${t_path}

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

Wait Until ELement Should Contain
    [Arguments]  ${p_locator}  ${p_text}
    Wait Until Element Contains  ${p_locator}  ${p_text}  timeout=${g_TIMEOUT_SEC}

Get Matching Locator Count
    [Documentation]   This keyword will count all possible elements in the page using jQuery length.
    ...    Do not use ID since it will only return 1 result. Use class as argument.
    [Arguments]    ${p_elementLocator}
    ${t_extractLocator}=    Remove String Using Regexp    ${p_elementLocator}    ^.*?=
    ${r_elementCount}=    Execute Javascript   return jQuery('${t_extractLocator}').length
    Log   ${r_elementCount}
    [Return]    ${r_elementCount}

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

Force Element Via jQuery
  [Arguments]  ${p_element}  ${p_action}
  ${t_extracted}=  Remove String Using Regexp  ${p_element}    ^.*?=
  Execute Javascript  jQuery('${t_extracted}').${p_action}()

Modify Element Attribute Via jQuery
  [Arguments]  ${p_locator}  ${p_key}  ${p_value}
  ${t_extractLocator}=    Remove String Using Regexp    ${p_locator}    ^.*?=
  ${r_elementCount}=    Execute Javascript
  ...   jQuery('${t_extractLocator}').css("${p_key}", "${p_value}")

Sleep Until Timer Runs Out
  [Arguments]  ${p_type}=DEFAULT
  # sample data  0D:00H:01M:29S
  Capture Page Screenshot
  ${t_minutes}=  Get Regexp Matches  ${g_TIMER}  (?<=H:)(.*)(?=M)
  ${t_seconds}=  Get Regexp Matches  ${g_TIMER}  (?<=M:)(.*)(?=S)
  ${t_numMin}=  Convert To Number  ${t_minutes[0]}
  ${t_nummSec}=  Convert To Number  ${t_seconds[0]}
  ${t_min}=  Evaluate  ${t_numMin} * 60
  ${t_total}=  Evaluate  ${t_min} + ${t_nummSec}
  ${t_div}=  Evaluate  ${t_total} / 2
  ${t_time}=  Set Variable If  "${p_type}"=="REVEAL"
  ...  ${t_div}  ${t_total}
  Log To Console  ${t_time} remaining seconds to start next step
  Sleep  ${t_time} seconds
