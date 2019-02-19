*** Variables ***
${BROWSER}  Chrome
${ALIAS}  alias1
${PROD_BASE_URL}  https://digix.global
${KOVAN_BASE_URL}  https://www-kovan.digixdev.com
${LOCAL_BASE_URL}  https://localhost:3000
${LOCAL_INFO_URL}  http://localhost:3001
${LOCAL_LABEL}  LOCAL
${ENVIRONMENT}  LOCAL
${LOCAL_SPEED}  0.1 s
${REMOTE_SPEED}  0.2 s
${HEADLESS}  no
${HEIGHT}  1080
${WIDTH}  1920

*** Keywords ***
Launch Digix Website
  [Arguments]    ${p_url_ext}    ${p_environment}=${ENVIRONMENT}
  ...  ${p_alias}=${ALIAS}  ${p_browser}=${BROWSER}
  ${chrome_options}=  Set Chrome Headless
  # Create Webdriver    ${p_browser}    alias=${p_alias}  chrome_options=${chrome_options}
  # Go To  ${${p_environment}_BASE_URL}${p_url_ext}
  Run Test To Headless Browser
  Open Browser    ${${p_environment}_BASE_URL}${p_url_ext}   browser=${p_browser}    alias=${p_alias}
  Set Selenium Speed For "${p_environment}" Environment
  Set Timeout Dependent On Environment
  Maximize Browser Window

Launch Browser With Metamask Extension
  [Arguments]  ${p_alias}=${ALIAS}  ${p_browser}=Chrome
  ${chrome_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()    sys
  Should Exist  ${CURDIR}/../../resources/testdata/etc/unload.crx
  Call Method  ${chrome_options}  add_extension  ${CURDIR}/../../resources/testdata/etc/unload.crx
  Call Method  ${chrome_options}  add_argument  "--window-size\=1920,1080"
  Run Test To Headless Browser
  Create Webdriver    ${p_browser}    ${p_alias}    chrome_options=${chrome_options}
  Set Selenium Speed For "${ENVIRONMENT}" Environment
  Set Timeout Dependent On Environment
  Sleep  5 seconds

#=====================#
#  INTERNAL KEYWORDS  #
#=====================#
Set Selenium Speed For "${e_ENVIRONMENT}" Environment
  ${t_speed}=  Set Variable If  '${e_ENVIRONMENT}'=='${LOCAL_LABEL}'
  ...  ${LOCAL_SPEED}  ${REMOTE_SPEED}
  Set Selenium Speed  ${t_speed}

Set Timeout Dependent On Environment
  ${t_timeout}=  Set Variable If  "${ENVIRONMENT}"=="${LOCAL_LABEL}"
  ...  ${SHORT_TIMEOUT}  ${LONG_TIMEOUT}
  ${t_interval}=  Set Variable If  "${ENVIRONMENT}"=="${LOCAL_LABEL}"
  ...  ${SHORT_INTERVAL}  ${LONG_INTERVAL}
  ${t_timeout_sec}=  Set Variable If  "${ENVIRONMENT}"=="${LOCAL_LABEL}"
  ...  ${TIMEOUT_SEC}  ${LONG_TIMEOUT_SEC}
  Set Global Variable  ${g_TIMEOUT}  ${t_timeout}
  Set Global Variable  ${g_INTERVAL}  ${t_interval}
  Set Global Variable  ${g_TIMEOUT_SEC}  ${t_timeout_sec}

Set Entry Point Based On Environment
  ${t_entry}=  Set Variable If  "${ENVIRONMENT}"=="KOVAN"
  ...  ${KOVAN_GOVERNANCE_URL_EXT}  ${GOVERNANCE_LOGIN_URL_EXT}
  Set Suite Variable  ${s_ENTRY_POINT}  ${t_entry}

Set Chrome Headless
  ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
  Run Keyword If  '${HEADLESS.lower()}'=='yes'
  ...  Call Method    ${options}    add_argument    --headless
  [Return]    ${options}

Run Test To Headless Browser
  Run Keyword If  '${HEADLESS.lower()}'=='yes'
  ...  Start Virtual Display  ${HEIGHT}  ${WIDTH}