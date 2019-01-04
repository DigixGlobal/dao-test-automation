*** Variables ***
${BROWSER}  chrome
${ALIAS}  alias1
${PROD_BASE_URL}  https://digix.global
${KOVAN_BASE_URL}  https://www-kovan.digixdev.com
${LOCAL_BASE_URL}  https://localhost:3000
${LOCAL_LABEL}  LOCAL
${ENVIRONMENT}  LOCAL
${LOCAL_SPEED}  0.1 s
${REMOTE_SPEED}  0.2 s

*** Keywords ***
Launch Digix Website
    [Arguments]    ${p_url_ext}    ${p_environment}=${ENVIRONMENT}
    ...  ${p_alias}=${ALIAS}  ${p_browser}=${BROWSER}
    Open Browser    ${${p_environment}_BASE_URL}${p_url_ext}   browser=${p_browser}    alias=${p_alias}
    Set Selenium Speed For "${p_environment}" Environment
    Set Timeout Dependent On Environment
    Maximize Browser Window

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
