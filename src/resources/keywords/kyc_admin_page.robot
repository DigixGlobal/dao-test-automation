*** Settings ***
Resource    ../variables/kyc_admin_constants.robot

*** Keywords ***
KycOfficer Is Logged In
  Wait Until Element Should Be Visible  ${KYC_DASHBOARD_SIDE_MENU_ICON}

#========#
#  WHEN  #
#========#
User "${e_ACTION}" An Account
  Load JQuery Tool
  ${t_date}=  Generate Valid Expiration ID
  Wait And Click Element  ${KYC_ADMIN_PENDING_TAB}
  Wait Until Element Should Be Visible  ${KYC_ADMIN_TABLE_PAGINATION_DIV}
  Wait And Click Element  ${KYC_ADMIN_ROW_DIV}:eq(0)
  Wait Until Element Should Be Visible  ${KYC_ADMIN_ACTION_TOGGLE}
  ${t_userID}=  Get Text  ${KYC_ADMIN_MODAL_USER_ID}
  Set Suite Variable  ${s_USER_ID}  ${t_userID}
  Run Keyword If  "${e_ACTION}"=="Approves"  Run Keywords
  ...  Click Element  ${KYC_ADMIN_ACTION_TOGGLE}
  ...  AND  Wait Until Element Should Be Visible  ${KYC_ADMIN_EXPIRATION_FIELD}
  ...  AND  Press Key  ${KYC_ADMIN_EXPIRATION_FIELD}  ${t_date}
  ...  AND  Wait Until Element Should Be Enabled  ${KYC_ADMIN_MODAL_BTN}
  ...  AND  Click Element  ${KYC_ADMIN_MODAL_BTN}
  ...  ELSE  Run Keywords
  ...  Select From List By Label  ${KYC_ADMIN_REJECTION_DD}  Unspecified
  ...  AND  Wait Until Element Should Be Enabled  ${KYC_ADMIN_MODAL_BTN}
  ...  AND  Click Element  ${KYC_ADMIN_MODAL_BTN}

User Forcely Goes To KYC Dashboard Page
  Go To  ${${ENVIRONMENT}_BASE_URL}${KYC_ADMIN_URL_EXT}

#========#
#  THEN  #
#========#
Account Status Should Be "${e_STATUS}"
  Load JQuery Tool
  Wait And Click Element  ${KYC_ADMIN_${e_STATUS}_TAB}
  Wait Until Element Should Be Visible  ${KYC_ADMIN_TABLE_PAGINATION_DIV}
  Open UserID Modal
  Wait Until Element Should Contain  ${KYC_ADMIN_MODAL_USER_ID}  ${s_USER_ID}
  Wait Until Element Should Contain  ${KYC_ADMIN_MODAL_STATUS}  ${e_STATUS}
  Click Element  ${CLOSE_MODAL_ICON}

User Should Be Able To Visit KYC Dashboard
  Wait Until Element Should Be Visible  ${STAT_QUARTER_POINT}
  Wait Until Element Should Be Visible  ${STAT_REPUTATION_POINT}
  Wait Until Element Should Be Visible  ${STAT_MYSTAKE_POINT}
  Wait Until Element Should Not Be Visible  ${KYC_ADMIN_PENDING_TAB}
#=====================#
#  INTERNAL KEYWORDS  #
#=====================#
Generate Valid Expiration ID
  ${yyyy}  ${mm}  ${dd}=  Get Time  year,month,day  NOW - 10 day
  ${t_plus_year}=  Evaluate   ${yyyy} + 5
  ${t_date}=  Convert To String  ${dd}${mm}${t_plus_year}
  [Return]  ${t_date}

Open UserID Modal
  Wait Until Element Should Be Visible  ${KYC_ADMIN_TABLE}
  ${t_elements}=  Get Matching Locator Count  ${KYC_ADMIN_ROW_DIV}
  :FOR  ${INDEX}  IN RANGE  0  ${t_elements}
  \  ${t_userID_div}=  Set Variable  ${KYC_ADMIN_ROW_DIV}:eq(${index}) .rt-td:eq(0)
  \  ${t_text}=  Get Text  ${t_userID_div}
  \  ${t_same}=  Evaluate  "${t_text}"=="${s_USER_ID}"
  \  Run Keyword If  ${t_same}  Run Keywords
  ...  Click Element  ${t_userID_div}
  ...  AND  Exit For Loop
  \  Run Keyword If  '${INDEX}'=='${t_elements}'
  ...  FAIL  msg=${s_USER_ID} not found
