*** Settings ***
Resource    ../variables/kyc_admin_constants.robot

*** Keywords ***
KycOfficer Is Logged In
  Open SideNav Menu If Not Visible
  Wait Until Element Should Be Visible  ${KYC_DASHBOARD_SIDE_MENU_ICON}

#========#
#  WHEN  #
#========#
User "${e_ACTION}" "${e_NAME}" Account
# User "${e_ACTION}" An Account
  Load JQuery Tool
  ${t_date}=  Generate Valid Expiration ID
  Wait And Click Element  ${KYC_ADMIN_PENDING_TAB}
  Open "${e_NAME}" KYC Modal
  Wait Until Element Should Be Visible  ${KYC_ADMIN_ACTION_TOGGLE}
  Run Keyword If  "${e_ACTION}"=="Approves"  Run Keywords
  ...  Click Element  ${KYC_ADMIN_ACTION_TOGGLE}
  ...  AND  Wait Until Element Should Be Visible  ${KYC_ADMIN_EXPIRATION_FIELD}
  ...  AND  Press Key  ${KYC_ADMIN_EXPIRATION_FIELD}  ${t_date}
  ...  ELSE
  ...  Select From List By Label  ${KYC_ADMIN_REJECTION_DD}  ${REJECTION_REASON}
  Wait And Click Element  ${KYC_ADMIN_MODAL_BTN}

User Forcely Goes To KYC Dashboard Page
  Go To  ${${ENVIRONMENT}_BASE_URL}${KYC_ADMIN_URL_EXT}

#========#
#  THEN  #
#========#
Account Status Should Be "${e_STATUS}"
  Load JQuery Tool
  Wait And Click Element  ${KYC_ADMIN_${e_STATUS}_TAB}
  Wait Until Element Should Be Visible  ${KYC_ADMIN_TABLE_PAGINATION_DIV}
  Open "${s_FIRST_NAME}" KYC Modal
  Wait Until Element Should Contain  ${KYC_ADMIN_MODAL_FIRST_NAME}  ${s_FIRST_NAME}
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

Open "${e_NAME}" KYC Modal
  Wait Until Element Should Be Visible  ${KYC_ADMIN_TABLE_PAGINATION_DIV}
  Run Keyword If  "${e_NAME}"=="ANY"
  ...  Wait And Click Element  ${KYC_ADMIN_ROW_DIV}:eq(0)
  ...  ELSE
  ...  Look "${e_NAME}" Account On Table
  ${t_first_name}=  Get Text  ${KYC_ADMIN_MODAL_FIRST_NAME}
  Set Suite Variable  ${s_FIRST_NAME}  ${t_first_name}
  # Set Suite LookUp For KYC "${e_NAME}" Account

Look "${e_NAME}" Account On Table
  Wait Until Element Should Be Visible  ${KYC_ADMIN_TABLE}
  ${t_elements}=  Get Matching Locator Count  ${KYC_ADMIN_ROW_DIV}
  :FOR  ${INDEX}  IN RANGE  0  ${t_elements}
  \  ${t_div}=  Set Variable  ${KYC_ADMIN_ROW_DIV}:eq(${index}) ${KYC_ADMIN_TABLE_NAME}
  \  ${t_visible}=  Run Keyword And Return Status
  ...  Element Should Contain  ${t_div}  ${e_NAME}
  \  ${t_click}=  Run Keyword If  ${t_visible}  Run Keywords
  ...  Click Element  ${t_div}
  ...  AND  Exit For Loop
  \  Run Keyword If  '${INDEX}'=='${t_elements}'
  ...  FAIL  msg=${e_NAME} not found

# Set Suite LookUp For KYC "${e_NAME}" Account
#   ${t_div}=  Set Variable If  "${e_NAME}"=="ANY"
#   ...  ${KYC_ADMIN_MODAL_USER_ID}  ${KYC_ADMIN_MODAL_FIRST_NAME}
#   ${t_text}=  Get Text  ${t_div}
#   Set Suite Variable  ${s_LOOKUP}  ${t_text}
#   Set Suite Variable  ${s_DIV}  ${t_div}
#   Set Suite Variable  ${s_NAME}  ${e_NAME}
