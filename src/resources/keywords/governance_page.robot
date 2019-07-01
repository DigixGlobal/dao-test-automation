*** Settings ***
Resource    create_edit_proposal_page.robot
Resource    proposal_view_page.robot
Resource    common_keywords.robot
Resource    metamask.robot
Resource    ../variables/governance_constants.robot

*** Keywords ***
#=========#
#  GIVEN  #
#=========#
Pull Profile Stats Data
  Wait Until Element Should Be Visible  ${STAT_QUARTER_OVERVIEW_DIV}
  Wait And Click Element  ${USER_STATISTIC_TOGGLE}
  ${t_mod}=  Run Keyword And Return Status  Should Contain  ${TEST NAME}  Moderator
  ${t_mod_pt}=  Run Keyword If  ${t_mod}
  ...  Get Text  ${STAT_MODERATOR_POINT}
  Run Keyword If  ${t_mod}
  ...  Set Suite Variable  ${s_MOD_QP}  ${t_mod_pt}
  ${t_qp}=  Get Text  ${STAT_QUARTER_POINT}
  ${t_rp}=  Get Text  ${STAT_REPUTATION_POINT}
  ${t_sp}=  Get Text  ${STAT_MYSTAKE_POINT}
  Set Suite Variable  ${s_QUARTER_PTS}  ${t_qp}
  Set Suite Variable  ${s_REPUTATION_PTS}  ${t_rp}
  Set Suite Variable  ${s_STAKE_PTS}  ${t_sp}

#========#
#  WHEN  #
#========#
User Approves DigixDao Interaction To Wallet
  Wait And Click Element  ${APPROVE_INTERACTION_BTN}
  User Submits Keystore Password  #transaction modal

User Locks DGD Via Connect Wallet
  Wait And Click Element  ${CONNECT_WALLET_LOCKED_DGD_BTN}
  User Submits Locked Stake

User Signs Proof Of Control
  Wait Until Element Is Visible  ${PROOF_OF_CONTROL_PASSWORD_FIELD}  timeout=60 seconds
  User Submits Keystore Password

User Submits Locked Stake
  [Arguments]  ${p_amount}=${LOCKED_DGD_AMOUNT}
  Wait Until Element Should Be Visible  ${LOCK_WITH_AMOUNT_BTN}
  Input Text  ${LOCK_DGD_AMOUNT_FIELD}  ${p_amount}
  Wait Until Element Should Be Visible  ${LOCK_DGD_STATUS}
  ${t_stake}=  Return Stake Value Based On Inputted DGD Amount
  Set Suite Variable  ${s_LOCK_STAKE}  ${t_stake}
  Set Suite Variable  ${s_LOCkED_AMOUNT_DGD}  ${p_amount}
  Wait And Click Element  ${LOCK_WITH_AMOUNT_BTN}
  User Submits Keystore Password

"${e_USER}" Submits "${e_WALLET_TYPE}" Wallet
  # uploading
  Set Suite Variable  ${s_WALLET_TYPE}  ${e_WALLET_TYPE}
  Load JQuery Tool
  Accept DigixDao Terms and Condition
  Wait And Click Element  ${LOAD_WALLET_BTN}
  Wait And Click Element  ${LOAD_WALLET_SIDEBAR_BUTTON}
  Wait And Click Element  ${LOAD_WALLET_SIDEBAR_BUTTON} ${WALLET_${e_WALLET_TYPE}_BTN}
  Wait Until Element Should Be Visible  ${IMPORT_KEYSTORE_ICON} svg
  Run Keyword If  '${e_WALLET_TYPE}'=='json'
  ...  Submit Json Wallet  ${e_USER}  ${e_WALLET_TYPE}
  ...  ELSE
  ...  Submit Metamask Wallet

Submit Json Wallet
  [Arguments]  ${p_user}  ${p_wallet_type}=json
  Run Keyword If  "${p_wallet_type}"=="json"
  ...  Upload Json Wallet Based On Environment  ${p_user}
  User Submits Keystore Password  #validate wallet password
  Wait Until Element Should Be Visible  ${MESSAGE_SIGNER_FORM}
  User Submits Keystore Password  #sign message modal
  Wait Until Element Should Not Be Visible  ${GOVERNANCE_MODAL}

Visit Newly Created Proposal And Click "${e_ACTION}" Action
  Go To Newly Created Proposal View Page
  Wait And Click Element  ${PROJECT_SUMMARY} ${ROUND_BTN}:last

Logged In Account Using Metamask
  Select Window  main
  Maximize Browser Window
  Go to  ${${ENVIRONMENT}_BASE_URL}${s_ENTRY_POINT}
  Load JQuery Tool
  # Wait And Click Element  ${LOAD_WALLET_BTN}
  # Wait And Click Element  ${LOAD_WALLET_SIDEBAR_BUTTON}
  # Wait And Click Element  ${LOAD_WALLET_SIDEBAR_BUTTON} ${WALLET_METAMASK_BTN}
  # Wait Until Element Should Be Visible  ${IMPORT_KEYSTORE_ICON} svg

Submit Metamask Wallet
  Input Text  ${METAMASK_NICKNAME}  test
  Wait And Click Element  ${UNLOCK_WALLET_BTN}
  Approve Metamask Interaction  #approve Interaction
  Approve Metamask Interaction  #proof of control modal
  Wait Until Element Should Not Be Visible  ${GOVERNANCE_MODAL}

User Closes Connected Wallet Overlay
  Wait Until Element Should Be Visible  ${CONNECTED_WALLET_OVERLAY}
  Click Element  ${OVERLAY_CLOSE_ICON}

#========#
#  THEN  #
#========#
User Should Successfully Be A Participant
  Wait Until Element Should Be Visible  ${USER_STATISTIC_DIV}

Total Funding Should Be Correct
  Wait Until Element Should Contain  ${PROPOSAL_CARD}:eq(0) ${PROPOSAL_TOTAL_FUNDING}  ${s_OVERALL_FUNDING}

Connect Wallet Overlay Should Be Visible
  Wait Until Element Should Be Visible  ${CONNECTED_WALLET_OVERLAY}

Project Creator Name Should Be Visible
  Wait Until Element Should Contain  ${PROPOSAL_CARD}:eq(0) ${PROPOSAL_AUTHOR}  ${s_PROJECT_CREATOR.upper()}

Quarter Points Should Increase
  Wait Until Element Should Be Visible  ${STAT_QUARTER_OVERVIEW_DIV}
  Wait And Click Element  ${USER_STATISTIC_TOGGLE}
  ${t_pt}=  Evaluate  ${s_QUARTER_PTS} + 1
  ${t_str}=  Convert To String  ${t_pt}
  Wait Until Element Should Contain  ${STAT_QUARTER_POINT}  ${t_str}

Moderator Quarter Points Should Increase
  Wait Until Element Should Be Visible  ${STAT_QUARTER_OVERVIEW_DIV}
  Wait And Click Element  ${USER_STATISTIC_TOGGLE}
  ${t_pt}=  Evaluate  ${s_MOD_QP} + 1
  ${t_str}=  Convert To String  ${t_pt}
  Wait Until Element Should Contain  ${STAT_MODERATOR_POINT}  ${t_str}

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
Approve Metamask Interaction
  Sleep  5 seconds
  ${t_count}=  Get Window Handles
  ${t_intCount}=  Get Length  ${t_count}
  Should Be Equal As Integers  ${t_intCount}  2
  Select Window  new
  Wait And Click Element  css=[class*="footer"] button:nth-of-type(2)
  Select Window  main
  ${t_close}=  Get Window Handles
  ${t_intClose}=  Get Length  ${t_close}
  Should Be Equal As Integers  ${t_intClose}  1

# Repeat Until Newly Created Project Is On "${e_TAB}" Tab
#   Wait Until Element Should Be Visible  ${PROPOSAL_CARD}:eq(0) h2
#   :FOR  ${index}  IN RANGE  0  5
#   \  ${t_status}=  Run Keyword And Return Status
#   ...  Wait Until Element Contains  ${PROPOSAL_CARD}:eq(0) h2  ${g_GENERIC_VALUE}  timeout=5 seconds
#   \  Run Keyword If  ${t_status}
#   ...  Exit For Loop
#   ...  ELSE  Switch "${e_TAB}" Tab To Update Content

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
  Set Entry Point Based On Environment
  Run keyword If  "${e_WALLET_TYPE.lower()}"=="metamask"  Run Keywords
  ...  "${e_USER}" Launches Browser With Plugins
  ...  AND  Logged In Account Using Metamask
  ...  ELSE
  ...  Launch Digix Website  ${s_ENTRY_POINT}  ${ENVIRONMENT}  ${e_USER}
  "${e_USER}" Submits "${e_WALLET_TYPE}" Wallet
  Set Suite Variable  ${s_WALLET_TYPE}  ${e_WALLET_TYPE}

Launch Governance Website
  [Arguments]  ${p_user_alias}=${ALIAS}
  Set Entry Point Based On Environment
  Launch Digix Website  ${s_ENTRY_POINT}  ${ENVIRONMENT}  ${p_user_alias}

#===========#
#  HELPERS  #
#===========#
Get Proposal Card Index
  Wait Until Element Should Be Visible  ${PROPOSAL_CARD}:eq(0) h2
  @{t_elements}=  Get WebElements  ${PROPOSAL_CARD} ${PARTICIPATE_BTN}
  :FOR  ${index}  ${locator}  IN ENUMERATE  @{t_elements}
  \  ${t_text}=  Get Text  ${PROPOSAL_CARD}:eq(${index}) h2
  \  ${t_same}=  Evaluate  '${t_text}'=='${g_GENERIC_VALUE}'
  \  Run Keyword If  '${t_same}'=='True'  Run Keywords
  ...  Set Suite Variable  ${s_PROPOSAL_INDEX}  ${locator}
  ...  AND  Exit For Loop

Return Stake Value Based On Inputted DGD Amount
  Wait Until Element Should Be Visible  ${LOCK_DGD_STAKE_LABEL}
  ${t_stake}=  Get Text  ${LOCK_DGD_STAKE_LABEL}
  ${t_value}=  Remove String  ${t_stake}  STAKE
  [Return]  ${t_value}

"${e_USER}" Uploads "${e_WALLET_TYPE}" Wallet Account
  Set Suite Variable  ${s_WALLET_TYPE}  ${e_WALLET_TYPE}
  Load JQuery Tool
  Accept DigixDao Terms and Condition
  Wait And Click Element  ${LOAD_WALLET_BTN}
  Wait And Click Element  ${LOAD_WALLET_SIDEBAR_BUTTON}
  Wait And Click Element  ${LOAD_WALLET_SIDEBAR_BUTTON} ${WALLET_${e_WALLET_TYPE}_BTN}
  Wait Until Element Should Be Visible  ${IMPORT_KEYSTORE_ICON} svg
  Upload Json Wallet Based On Environment  ${e_USER}
  User Submits Keystore Password  #validate wallet password
