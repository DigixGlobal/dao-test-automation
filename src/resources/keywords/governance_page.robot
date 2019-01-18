*** Settings ***
Resource    create_edit_proposal_page.robot
Resource    proposal_view_page.robot
Resource    ../variables/governance_constants.robot
*** Keywords ***
#=========#
#  GIVEN  #
#=========#
Pull Profile Stats Data
  Wait Until Element Should Be Visible  ${DASHBOARD_STATS_DIV}
  ${t_qp}=  Get Text  ${STAT_QUARTER_POINT}
  ${t_rp}=  Get Text  ${STAT_REPUTATION_POINT}
  ${t_sp}=  Get Text  ${STAT_MYSTAKE_POINT}
  Set Suite Variable  ${s_QUARTER_PTS}  ${t_qp}
  Set Suite Variable  ${s_REPUTATION_PTS}  ${t_rp}
  Set Suite Variable  ${s_STAKE_PTS}  ${t_sp}

#========#
#  WHEN  #
#========#
User Goes To "${e_SIDEMENU}" View Page
  Wait Until Element Should Be Visible  ${SIDE_MENU_DIV}
  Wait And Click Element  ${${e_SIDEMENU}_SIDE_MENU_ICON}

User Submits Locked Stake
  [Arguments]  ${p_amount}=${LOCKED_DGD_AMOUNT}
  Wait Until Element Should Be Visible  ${LOCK_WITH_AMOUNT_BTN}
  Input Text  ${LOCK_DGD_AMOUNT_FIELD}  ${p_amount}
  Wait Until Element Should Be Visible  ${LOCK_DGD_STATUS}
  Wait And Click Element  ${LOCK_WITH_AMOUNT_BTN}
  User Submits Keystore Password

"${e_USER}" Submits "${e_WALLET_TYPE}" Wallet
  # uploading
  Load JQuery Tool
  Wait And Click Element  ${LOAD_WALLET_BTN}
  Wait And Click Element  ${LOAD_WALLET_SIDEBAR_BUTTON}
  Wait And Click Element  ${LOAD_WALLET_SIDEBAR_BUTTON} ${WALLET_${e_WALLET_TYPE}_BTN}
  Wait Until Element Should Be Visible  ${IMPORT_KEYSTORE_ICON} svg
  Run Keyword If  "${e_WALLET_TYPE}"=="json"
  ...  Upload Json Wallet Based On Environment  ${e_USER}
  User Submits Keystore Password  #validate wallet password
  Wait Until Element Should Be Visible  ${MESSAGE_SIGNER_FORM}
  User Submits Keystore Password  #sign message modal
  Wait Until Element Should Not Be Visible  ${GOVERNANCE_MODAL}
  Wait Until Element Should Be Visible  ${ADDRESS_INFO_SIDEBAR}
  Click Element  ${CLOSE_ICON}
  Wait Until Element Should Not Be Visible  ${GOVERNANCE_MODAL}

Go Back To Dashboard Page
  Wait And Click Element  ${HOME_SIDE_MENU_ICON}
  Wait Until Element Should Be Visible  ${GOVERNANCE_FILTER_SECTION}

Go To Newly Created Proposal View Page
  Get Proposal Card Index
  Hide SnackBar
  Hide Governance Header Menu
  Wait And Click Element  ${s_PROPOSAL_INDEX}

Visit Newly Created Proposal And Click "${e_ACTION}" Action
  Go To Newly Created Proposal View Page
  Wait And Click Element  ${PROJECT_SUMMARY} ${ROUND_BTN}:last
  # Assign ID For Interaction Buttons
  # ${t_button}=  Return Action Button Names On Proposal  ${e_ACTION}
  # Wait And Click Element  ${t_button}

#========#
#  THEN  #
#========#
"${e_STATE}" SideNav Menu Items Should Be Visible
  :FOR  ${locator}  IN  @{${e_STATE}_SIDENAV_LIST}
  \  Wait Until Element Should Be Visible  ${locator}

Newly Created Proposal Should Be Visible On "${e_TAB}" Tab
  Switch "${e_TAB}" Tab To Update Content
  ${t_speed}=  Get Selenium Speed
  Run Keyword If  "${ENVIRONMENT}"=="KOVAN"
  ...  Set Selenium Speed  0.5 s
  Repeat Until Newly Created Project Is On "${e_TAB}" Tab
  Set Selenium Speed  ${t_speed}

Proposal Status Should Be "${e_STATUS}"
  Newly Created Proposal Should Be Visible On "All" Tab
  Run Keyword If  '${ENVIRONMENT}'!='KOVAN'  #temporary
  ...  Wait Until ELement Should Contain  ${PROPOSAL_CARD}:eq(0) ${PROPOSAL_STATUS_BTN}  ${e_STATUS}

Snackbox Should Contain "${e_MESSAGE}"
  Wait Until ELement Should Contain  ${SNACK_BAR_DIV}  ${e_MESSAGE}
  Modify Element Attribute Via jQuery  ${SNACK_BAR_DIV}  display  none

#====================#
#  INTERNAL KEYWORD  #
#====================#
#temporary
# Return Action Button Names On Proposal
#   [Arguments]  ${p_action}
#   ${t_smallCase}=  Convert To Lowercase  ${p_action}
#   ${t_dict}=  Create Dictionary
#   ...  endorses proposal=ENDORSE
#   ...  abort=ABORT
#   ...  edit=EDIT
#   ...  finalizes proposal=FINALIZE
#   ...  approve=APPROVE
#   ...  claims approved proposal=CLAIM APPROVAL
#   ...  vote=VOTE
#   ...  reveal=REVEAL VOTE
#   ...  claims voting result=CLAIM RESULTS
#   ...  claims proposal funding= CLAIM FUNDING
#   ...  sets proposal to complete=MY MILESTONE IS COMPLETED
#   ${t_value}=  Get From Dictionary  ${t_dict}  ${t_smallCase}
#   [Return]  ${t_value}

Upload Json Wallet Based On Environment
  [Arguments]  ${p_filename}  ${p_environment}=${ENVIRONMENT}
  ${t_path}=  Normalize Path  ${CURDIR}/${KEYSTORE_PATH}/${p_environment}/${p_filename}.json
  Choose File  ${IMPORT_KEYSTORE_UPLOAD_BTN}  ${t_path}

Repeat Until Newly Created Project Is On "${e_TAB}" Tab
  Wait Until Element Should Be Visible  ${PROPOSAL_CARD}:eq(0) h2
  :FOR  ${index}  IN RANGE  0  5
  \  ${t_status}=  Run Keyword And Return Status
  ...  Wait Until Element Contains  ${PROPOSAL_CARD}:eq(0) h2  ${g_GENERIC_VALUE}  timeout=5 seconds
  \  Run Keyword If  ${t_status}
  ...  Exit For Loop
  ...  ELSE  Switch "${e_TAB}" Tab To Update Content

Switch "${e_TAB}" Tab To Update Content
  Wait Until Element Should Be Visible  ${GOVERNANCE_FILTER_SECTION}
  Modify Element Attribute Via jQuery  ${GOVERNANCE_MENU}  display  none
  Wait And Click Element  ${ARCHIVED_TAB}
  Wait And Click Element  ${${e_TAB}_TAB}

User Should Be Able To Participate On Proposal
  Newly Created Proposal Should Be Visible On "All" Tab

#====================#
#  SETUP / TEARDOWN  #
#====================#
"${e_USER}" Account Has Successfully Logged In To DigixDao Using "${e_WALLET_TYPE}"
  "${e_USER}" Launch Governance Page
  "${e_USER}" Submits "${e_WALLET_TYPE}" Wallet

"${e_USER}" Launch Governance Page
  ${t_entry}=  Set Variable If  "${ENVIRONMENT}"=="KOVAN"
  ...  ${KOVAN_GOVERNANCE_URL_EXT}  ${GOVERNANCE_LOGIN_URL_EXT}
  Launch Digix Website  ${t_entry}  ${ENVIRONMENT}  ${e_USER}

#===========#
#  HELPERS  #
#===========#
Get Proposal Card Index
  Wait Until Element Should Be Visible  ${PROPOSAL_CARD}:eq(0) h2
  @{t_elements}=  Get WebElements  ${PROPOSAL_CARD} ${VIEW_PROJECT_LINK}
  :FOR  ${index}  ${locator}  IN ENUMERATE  @{t_elements}
  \  ${t_text}=  Get Text  ${PROPOSAL_CARD}:eq(${index}) h2
  \  ${t_same}=  Evaluate  '${t_text}'=='${g_GENERIC_VALUE}'
  \  Run Keyword If  '${t_same}'=='True'  Run Keywords
  ...  Set Suite Variable  ${s_PROPOSAL_INDEX}  ${locator}
  ...  AND  Exit For Loop
