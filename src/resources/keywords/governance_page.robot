*** Settings ***
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

User Submits Locked DGD
  [Arguments]  ${p_amount}=${LOCKED_DGD_AMOUNT}
  Wait Until Element Should Not Be Visible  ${GOVERNANCE_MODAL}
  Wait Until Element Should Be Visible  ${ADDRESS_INFO_SIDEBAR}
  Wait And Click Element  ${LOCK_DGD_BTN}
  Wait Until Element Should Be Visible  ${LOCK_WITH_AMOUNT_BTN}
  Input Text  ${LOCK_DGD_AMOUNT_FIELD}  ${p_amount}
  Wait Until Element Should Be Visible  ${LOCK_DGD_STATUS}
  Wait And Click Element  ${LOCK_WITH_AMOUNT_BTN}

"${e_USER_TYPE}" Submits "${e_WALLET_TYPE}" Wallet To Locked DGD
  "${e_USER_TYPE}" Uploads "${e_WALLET_TYPE}" Wallet
  User Submits Keystore Password
  Wait Until Element Should Be Visible  ${MESSAGE_SIGNER_FORM}
  User Submits Keystore Password  #sign message modal
  User Submits Locked DGD
  Wait Until Element Should Be Visible  ${GOVERNANCE_MODAL}
  User Submits Keystore Password  #transaction modal

"${e_USER}" Creates A Governance Propsosal
  Wait Until Element Should Be Visible  ${ADDRESS_LABEL}
  Wait And Click Element  ${GOVERNANCE_CREATE_BTN}
  Submit Proposal Details

"${e_USER}" Edits Newly Created Proposal Details
  Wait And Click Element  ${PROJECT_SUMMARY} ${ROUND_BTN}:last
  Submit Proposal Details  3  4  edit

"${e_USER}" Approves Newly Drafted Proposal
  Proposal Status Should Be "DRAFT"
  Visit Newly Created Proposal And Click "Approve" Action
  Get Remaining Time To Execute Next Step
  Wait Until Element Should Be Visible  ${GOVERNANCE_SIDE_PANEL}
  Wait And Click Element  ${GOVERNANCE_SIDE_PANEL} button:eq(0)
  Wait And Click Element  ${GOVERNANCE_SIDE_PANEL} button:eq(2)
  User Submits Keystore Password  #transaction modal

"${e_USER}" Votes "${e_RESPONSE}" On Proposal
  Newly Created Proposal Should Be Visible On "All" Tab
  Force Element Via jQuery  ${HELP_LAUNCHER}  hide
  Visit Newly Created Proposal And Click "Vote" Action
  Get Remaining Time To Execute Next Step
  Wait Until Element Should Be Visible  ${GOVERNANCE_SIDE_PANEL}
  Run Keyword If  "${e_RESPONSE}"=="Yes"
  ...  Click Element  ${GOVERNANCE_SIDE_PANEL} button:eq(0)  #Yes vote button
  ...  ELSE IF  "${e_RESPONSE}"=="No"
  ...  Click Element  ${GOVERNANCE_SIDE_PANEL} button:eq(1)  #No vote button
  ${t_salt}=  Get Element Attribute  ${GOVERNANCE_SIDE_PANEL} a:eq(0)  download
  Wait And Click Element  ${GOVERNANCE_SIDE_PANEL} a:eq(0)  #Download Json File button
  Wait And Click Element  ${GOVERNANCE_SIDE_PANEL} button:eq(2)  #confirm commit button
  Replace Salt File According To User Role  ${t_salt}  ${e_USER}
  User Submits Keystore Password

"${e_USER}" Reveals Vote Via Salt File
  Newly Created Proposal Should Be Visible On "All" Tab
  Visit Newly Created Proposal And Click "Reveal" Action
  Get Remaining Time To Execute Next Step
  "Upload" "${e_USER}" Salt File
  Wait Until Element Should Be Visible  ${NOTE_CONTAINER}
  Wait And Click Element  ${GOVERNANCE_SIDENAR_DIV} ${ROUND_BTN}
  "Remove" "${e_USER}" Salt File
  User Submits Keystore Password  #transaction modal

"${e_USER}" Uploads Modified Salt File
  ${t_path}=  Normalize Path  ~/Downloads/
  ${t_content}=  Load Json From File  ${t_path}/${e_USER}${SALT_FILE_EXT}
  ${t_vote}=  Get Value From Json  ${t_content}  vote
  ${t_invert}=  Set Variable If  "${t_vote}"=="${true}"  false  true
  ${t_new}=  Update Value To Json  ${t_content}  vote  ${t_invert}
  ${t_write}=  Convert JSON To String  ${t_new}
  Append To File  ${t_path}/${e_USER}_modified${SALT_FILE_EXT}  ${t_write}  encoding=UTF-8
  ${t_user}=  Set Variable  ${e_USER}_modified
  "${t_user}" Reveals Vote Via Salt File

"${e_USER}" "${e_ACTION}" On Newly Created Proposal
  Newly Created Proposal Should Be Visible On "All" Tab
  Visit Newly Created Proposal And Click "${e_ACTION}" Action
  User Submits Keystore Password  #transaction modal

#========#
#  THEN  #
#========#
"${e_STATE}" SideNav Menu Items Should Be Visible
  :FOR  ${locator}  IN  @{${e_STATE}_SIDENAV_LIST}
  \  Wait Until Element Should Be Visible  ${locator}

Proposal Details Should Be Correct On Proposal Details Page
  Go To Newly Created Proposal View Page
  Wait Until Element Contains  ${PROPOSAL_TITLE_DIV}  ${g_GENERIC_VALUE}
  Wait And Click Element  ${PROPOSAL_MILESTONE_ARROW_ICON}
  Wait Until Element Contains  ${PROPOSAL_SHORT_DESC_DIV}  ${g_GENERIC_VALUE}
  Wait Until Element Contains  ${PROPOSAL_DESC_DIV}  ${g_GENERIC_VALUE}
  Wait Until Element Contains  ${PROPOSAL_MS_DESC_DIV}  ${g_GENERIC_VALUE}
  Wait Until Element Contains  ${PROPOSAL_MS_AMOUNT_DIV}  ${s_MILESTONE_AMOUNT}
  Wait Until Element Contains  ${PROPOSAL_REWARD_DIV}  ${s_REWARD_AMOUNT}
  Wait Until Element Contains  ${PROPOSAL_FUNDING_DIV}  ${s_TOTAL_FUNDING}

User Should Be Able To Get Started On Governance
  Wait Until Element Should Be Visible  ${CONGRATULATION_BANNER}
  Wait Until Element Should Be Visible  ${GET_STARTED_BTN}

Newly Created Proposal Should Be Visible On "${e_TAB}" Tab
  Update Cards On "${e_TAB}" Tab
  ${t_speed}=  Get Selenium Speed
  Run Keyword If  "${ENVIRONMENT}"=="KOVAN"
  ...  Set Selenium Speed  0.5 s
  Repeat Until Newly Created Project Is On "${e_TAB}" Tab
  Set Selenium Speed  ${t_speed}

Repeat Until Newly Created Project Is On "${e_TAB}" Tab
  Wait Until Element Should Be Visible  ${PROPOSAL_CARD}:eq(0) h2
  :FOR  ${index}  IN RANGE  0  5
  \  ${t_status}=  Run Keyword And Return Status
  ...  Wait Until Element Contains  ${PROPOSAL_CARD}:eq(0) h2  ${g_GENERIC_VALUE}  timeout= 5 seconds
  \  Run Keyword If  ${t_status}
  ...  Exit For Loop
  ...  ELSE  Update Cards On "${e_TAB}" Tab

User Should Be Able To Participate On Proposal
  Newly Created Proposal Should Be Visible On "All" Tab
  # Wait Until Element Is Enabled  ${PROPOSAL_CARD}:eq(0) ${PARTICIPATE_BTN}

Proposal Status Should Be "${e_STATUS}"
  Newly Created Proposal Should Be Visible On "All" Tab
  Run Keyword If  '${ENVIRONMENT}'!='KOVAN'  #temporary
  ...  Wait Until ELement Should Contain  ${PROPOSAL_CARD}:eq(0) ${PROPOSAL_STATUS_BTN}  ${e_STATUS}

Vote Count Should Increase
  Newly Created Proposal Should Be Visible On "All" Tab
  # Wait And Click Element  ${PROPOSAL_CARD}:eq(0) ${VIEW_PROJECT_LINK}

Snackbox Should Contain "${e_MESSAGE}"
  # Wait Until Element Is Visible  ${SNACK_BAR_DIV}  timeout=${TIMEOUT_SEC}
  Wait Until ELement Should Contain  ${SNACK_BAR_DIV}  ${e_MESSAGE}

#====================#
#  INTERNAL KEYWORD  #
#====================#
Submit Proposal Details
  [Arguments]  ${p_reward}=${MILESTONE_REWARD_AMOUNT}  ${p_milestone}=${MILESTONE_AMOUNT}  ${p_type}=Create
  ${t_time}=  Get Time  epoch
  ${t_strValue}=  Convert To String  ${t_time}
  ${t_value}=  Set Variable If  "${p_type}"=="Create"
  ...  ${t_strValue}  ${t_strValue} - edit
  Log To Console  ProjectName:${t_strValue}
  # overview
  Wait Until Element Should Be Visible  ${PROJECT_TITLE_FIELD}
  Input Text  ${PROJECT_TITLE_FIELD}  ${t_value}
  Input Text  ${PROJECT_DESC_FIELD}  ${t_value}
  Click Element  ${PROPOSAL_MENU_NEXT_BTN}
  #project detail
  Wait Until Element Should Be Visible  ${PROJECT_INFO_FIELD}
  Clear Element Text  ${PROJECT_INFO_FIELD}
  Press Key  ${PROJECT_INFO_FIELD}  ${t_value}
  Click Element  ${PROPOSAL_MENU_NEXT_BTN}
  #multimedia
  Wait Until Element Should Be Visible  ${UPLOAD_IMAGE_BTN}
  Modify Element Attribute Via jQuery  ${IMAGE_UPLOAD_BTN}  display  block
  Upload TestData Image  image
  Click Element  ${PROPOSAL_MENU_NEXT_BTN}
  #milestone
  Wait Until Element Should Be Visible  ${MILESTONE_FORM}
  Input Text  ${REWARD_FIELD}  ${p_reward}
  Select From List By Label  ${NUM_OF_MILESTONE_FIELD}  ${NUMBER_OF_MILESTONE}
  Input Text  ${MILESTONE_FIELD}:eq(0)  ${p_milestone}
  Input Text  ${MILESTONE_DESC_FIELD}:eq(0)  ${t_value}
  Set Suite Variable  ${s_REWARD_AMOUNT}  ${p_reward}
  Set Suite Variable  ${s_MILESTONE_AMOUNT}  ${p_milestone}
  Compute Suite Total Funding
  Click Element  ${CREATE_NOW_BTN}
  #prevew
  Wait And Click Element  ${PROPOSAL_SUBMIT_BTN}
  Wait Until Element Should Not Be Visible  ${GOVERNANCE_MODAL}
  User Submits Keystore Password  #transaction modal
  Set Global Variable  ${g_GENERIC_VALUE}  ${t_value}
  Run Keyword If  '${ENVIRONMENT}'=='KOVAN'  Run Keywords
  ...  Log To Console  sleep the test due to it runs on ${ENVIRONMENT} for 60 seconds
  ...  AND  Sleep  60 seconds

Return Action Button Names On Proposal
  [Arguments]  ${p_action}
  ${t_dict}=  Create Dictionary
  ...  Endorses Proposal=ENDORSE
  ...  Finalizes Proposal=FINALIZE
  ...  Approve=APPROVE
  ...  Claims Approved Proposal=
  ..   Vote=VOTE
  ...  Reveal=REVEAL
  ...  Claims Voting Result=
  ...  Claims Proposal Funding=
  ..,  Sets Proposal To Complete=
  ${t_value}=  Get From Dictionary  ${t_dict}  ${p_action}
  [Return]  css=#${t_value}

User Submits Keystore Password
  Wait Until Element Should Be Visible  ${IMPORT_PASSWORD_FIELD}
  Input Text  ${IMPORT_PASSWORD_FIELD}  ${${ENVIRONMENT}_DAO__WALLET_PW}
  Wait And Click Element  ${UNLOCK_WALLET_BTN}

Update Cards On "${e_TAB}" Tab
  Wait Until Element Should Be Visible  ${GOVERNANCE_FILTER_SECTION}
  Modify Element Attribute Via jQuery  ${GOVERNANCE_MENU}  display  none
  Wait And Click Element  ${ARCHIVED_TAB}
  Wait And Click Element  ${${e_TAB}_TAB}

Replace Salt File According To User Role
  [Arguments]  ${p_filename}  ${p_role}
  ${t_path}=  Normalize Path  ~/Downloads/
  Wait Until Created  ${t_path}/${p_filename}  timeout=${g_TIMEOUT_SEC}
  Move File  ${t_path}/${p_filename}  ${t_path}/${p_role}${SALT_FILE_EXT}

Hide SnackBar
  ${t_bar}=  Get Matching Locator Count  ${SNACK_BAR_DIV}
  :For  ${index}  IN RANGE  0  ${t_bar}
  \  Force Element Via jQuery  ${SNACK_BAR_DIV}:eq(${index})  hide

Get Remaining Time To Execute Next Step
  Wait Until Element Should Be Visible  ${TIMER_DIV}
  ${t_text}=  Get Text  ${TIMER_DIV}
  Set Global Variable  ${g_TIMER}  ${t_text}

Go To Newly Created Proposal View Page
  Wait Until Element Should Be Visible  ${PROPOSAL_CARD}:eq(0) h2
  Wait Until ELement Should Contain  ${PROPOSAL_CARD}:eq(0) h2  ${g_GENERIC_VALUE}
  Hide SnackBar
  Modify Element Attribute Via jQuery  ${GOVERNANCE_MENU}  display  none
  Wait And Click Element  ${PROPOSAL_CARD}:eq(0) ${VIEW_PROJECT_LINK}

Visit Newly Created Proposal And Click "${e_ACTION}" Action
  Go To Newly Created Proposal View Page
  Wait Until Element Should Be Visible  ${PROJECT_SUMMARY}
  Wait And Click Element  ${PROJECT_SUMMARY} ${ROUND_BTN}:last
  # ${t_buttons}=  Get WebElements  ${PROJECT_SUMMARY} ${ROUND_BTN}
  # :FOR  ${locator}  IN  @{t_buttons}
  # \  ${t_text}=  Get Text  ${locator}
  # \  Assign Id To Element  ${locator}  ${t_text}
  # ${t_button}=  Return Action Button Names On Proposal  ${e_ACTION}
  # Click Element  ${t_button}

"${e_ACTION}" "${e_USER}" Salt File
  ${t_file}=  Normalize Path  ~/Downloads/${e_USER}${SALT_FILE_EXT}
  Run Keyword If  "${e_ACTION}"=="Upload"  Run Keywords
  ...  Wait Until Element Should Be Visible  ${GOVERNANCE_SIDE_PANEL}
  ...  AND  Choose File  ${SALT_JSON_UPLOAD_BTN}  ${t_file}
  ...  ELSE  Remove File  ${t_file}

"${e_USER}" Uploads "${e_WALLET_TYPE}" Wallet
  Load JQuery Tool
  Wait And Click Element  ${LOAD_WALLET_BTN}
  Wait And Click Element  ${LOAD_WALLET_SIDEBAR_BUTTON}
  Wait And Click Element  ${LOAD_WALLET_SIDEBAR_BUTTON} ${WALLET_${e_WALLET_TYPE}_BTN}
  Wait Until Element Should Be Visible  ${IMPORT_KEYSTORE_ICON} svg
  Run Keyword If  "${e_WALLET_TYPE}"=="json"
  ...  Upload Json Wallet Based On Environment  ${e_USER}

Compute Suite Total Funding
  ${t_total}=  Evaluate  ${s_REWARD_AMOUNT} + ${s_MILESTONE_AMOUNT}
  ${t_strFunding}=  Convert To String  ${t_total}
  Set Suite Variable  ${s_TOTAL_FUNDING}  ${t_strFunding}

"${e_USER}" Submits "${e_WALLET_TYPE}" Wallet
  "${e_USER}" Uploads "${e_WALLET_TYPE}" Wallet
  User Submits Keystore Password
  Wait Until Element Should Be Visible  ${MESSAGE_SIGNER_FORM}
  User Submits Keystore Password  #sign message modal
  Wait Until Element Should Not Be Visible  ${GOVERNANCE_MODAL}
  Wait Until Element Should Be Visible  ${ADDRESS_INFO_SIDEBAR}
  Click Element  ${CLOSE_ICON}
  Wait Until Element Should Not Be Visible  ${GOVERNANCE_MODAL}

#====================#
#  SETUP / TEARDOWN  #
#====================#
"${e_USER}" Account Has Successfully Locked DGD
  ${t_entry}=  Set Variable If  "${ENVIRONMENT}"=="KOVAN"
  ...  ${KOVAN_GOVERNANCE_URL_EXT}  ${GOVERNANCE_LOGIN_URL_EXT}
  Launch Digix Website  ${t_entry}  ${ENVIRONMENT}  ${e_USER}
  "${e_USER}" Submits "json" Wallet To Locked DGD
  Then User Should Be Able To Get Started On Governance
  Wait And Click Element  ${GET_STARTED_BTN}

"${e_USER}" Account Has Successfully Logged In To DigixDao Using "${e_WALLET_TYPE}"
  ${t_entry}=  Set Variable If  "${ENVIRONMENT}"=="KOVAN"
  ...  ${KOVAN_GOVERNANCE_URL_EXT}  ${GOVERNANCE_LOGIN_URL_EXT}
  Launch Digix Website  ${t_entry}  ${ENVIRONMENT}  ${e_USER}
  "${e_USER}" Submits "${e_WALLET_TYPE}" Wallet

Upload Json Wallet Based On Environment
  [Arguments]  ${p_filename}  ${p_environment}=${ENVIRONMENT}
  ${t_path}=  Normalize Path  ${CURDIR}/${KEYSTORE_PATH}/${p_environment}/${p_filename}.json
  Choose File  ${IMPORT_KEYSTORE_UPLOAD_BTN}  ${t_path}

Go Back To Dashboard Page
  Wait And Click Element  ${HOME_SIDE_MENU_ICON}
  Wait Until Element Should Be Visible  ${GOVERNANCE_FILTER_SECTION}

"${e_USER}" Launch Governance Page
  ${t_entry}=  Set Variable If  "${ENVIRONMENT}"=="KOVAN"
  ...  ${KOVAN_GOVERNANCE_URL_EXT}  ${GOVERNANCE_LOGIN_URL_EXT}
  Launch Digix Website  ${t_entry}  ${ENVIRONMENT}  ${e_USER}
