*** Variables ***
${BROWSER}    chrome
${ALIAS}    alias1
${PROD_BASE_URL}    https://digix.global
${TEST_BASE_URL}    https://www-kovan.digixdev.com
${LOCAL_BASE_URL}    https://localhost:3000
${ENVIRONMENT}  LOCAL

*** Keywords ***
Launch Digix Website
    [Arguments]    ${p_url_ext}    ${p_environment}=${ENVIRONMENT}
    ...  ${p_alias}=${ALIAS}  ${p_browser}=${BROWSER}
    Open Browser    ${${p_environment}_BASE_URL}${p_url_ext}   browser=${p_browser}    alias=${p_alias}
    Maximize Browser Window
    Set Selenium Speed For "${p_environment}" Environment

Set Selenium Speed For "${e_ENVIRONMENT}" Environment
  Run Keyword If  '${e_ENVIRONMENT}'=='LOCAL'
  ...  Set Selenium Speed  0.1 s
