*** Variables ***
${CHROME_NAME}  Chrome
${BROWSER}  Chrome
${ALIAS}  alias1
${PROD_BASE_URL}  https://digix.global
${KOVAN_BASE_URL}  https://www-kovan.digixdev.com
${LOCAL_BASE_URL}  https://localhost:3000
${LOCAL_INFO_SERVER_URL}  http://localhost:3001
${LOCAL_DAO_INFO_URL}  ${LOCAL_INFO_SERVER_URL}/daoInfo
${LOCAL_INFO_DETAILS_URL}  ${LOCAL_INFO_SERVER_URL}/proposals/details
${PRICE_FEED_URL}  https://min-api.cryptocompare.com/data/pricemulti?fsyms=DGD,DGX,ETH&tsyms=USD
${LOCAL_LABEL}  LOCAL
${ENVIRONMENT}  LOCAL
${LOCAL_SPEED}  0.1 s
${REMOTE_SPEED}  0.2 s
${HEADLESS}  yes
${HEIGHT}  1080
${WIDTH}  1920
${PLUGIN_FILE_PATH}  /../../resources/testdata/etc/unload.crx

*** Keywords ***
Launch Digix Website
  [Arguments]    ${p_url_ext}    ${p_environment}=${ENVIRONMENT}
  ...  ${p_alias}=${ALIAS}  ${p_browser}=${BROWSER}
  Launch Browser Based On Browser Type And Wallet Type  ${p_browser}  ${p_alias}
  Go To  ${${p_environment}_BASE_URL}${p_url_ext}
  Set Browser Size  ${p_browser}
  Set Selenium Speed For "${p_environment}" Environment
  Set Timeout Dependent On Environment
  Maximize Browser Window

Launch Browser With Metamask Extension
  [Arguments]  ${p_alias}=${ALIAS}  ${p_browser}=${BROWSER}
  ${t_browser}=  Set Variable If  '${p_browser.lower()}'=='chrome'
  ...  Chrome  ${BROWSER}
  ${chrome_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys
  Should Exist  ${CURDIR}${PLUGIN_FILE_PATH}
  Call Method  ${chrome_options}  add_extension  ${CURDIR}${PLUGIN_FILE_PATH}
  Run Test To Headless Browser  ${t_browser}
  Create Webdriver  ${CHROME_NAME}  alias=${p_alias}  chrome_options=${chrome_options}
  Set Browser Size  ${p_browser}
  Set Selenium Speed For "${ENVIRONMENT}" Environment
  Set Timeout Dependent On Environment
  Sleep  5 seconds

Run Test To Headless Browser
  [Arguments]  ${p_browser}
  Run Keyword If  '${p_browser.lower()}'!='chrome'
  ...  Start Virtual Display  ${HEIGHT}  ${WIDTH}

Launch Browser Based On Browser Type And Wallet Type
  [Arguments]  ${p_browser}  ${p_alias}  ${p_wallet}=json
  ${t_browser}=  Set Variable If  '${p_browser.lower()}'=='chrome'
  ...  Chrome  ${BROWSER}
  ${chrome_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys
  Run Keyword If  '${t_browser.lower()}'!='chrome'  Run Keywords
  ...  Call Method  ${chrome_options}  add_argument  --headless
  ...  AND  Call Method  ${chrome_options}  add_argument  --disable-gpu
  Create Webdriver  ${CHROME_NAME}  alias=${p_alias}  chrome_options=${chrome_options}

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

Set Browser Size
  [Arguments]  ${p_browser}
  Run Keyword If  '${p_browser.lower()}'=='chrome'
  ...  Maximize Browser Window
  ...  ELSE  Set Window Size  ${WIDTH}  ${HEIGHT}

Enable Download On Headless Browser
  ${t_library}=  Get Library Instance    SeleniumLibrary
  ${t_driver}=  Call Method  ${t_library}  _current_browser
  ${t_path}=  Normalize Path  ~/Downloads/
  Enable Download In Headless Chrome    ${t_driver}  ${t_path}

Run Test To Xvfb
  [Arguments]  ${p_browser}
  Run Keyword If  '${p_browser.lower()}'!='chrome'
  ...  Start Virtual Display  ${HEIGHT}  ${WIDTH}

Insert Metamask Plugin
  ${chrome_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys
  Should Exist  ${CURDIR}${PLUGIN_FILE_PATH}
  Call Method  ${chrome_options}  add_extension  ${CURDIR}${PLUGIN_FILE_PATH}
  [Return]  ${chrome_options}