*** Settings ***
Resource    ../variables/governance_constants.robot

*** Keywords ***
#========#
#  WHEN  #
#========#
User Submits Locked DGD
  [Arguments]  ${p_amount}=${LOCKED_DGD_AMOUNT}
  Wait Until Element Should Not Be Visible  ${GOVERNANCE_MODAL}
  Wait Until Element Should Be Visible  ${ADDRESS_INFO_SIDEBAR}
  Wait And Click Element  ${LOCK_DGD_BTN}
  Wait Until Element Should Be Visible  ${LOCK_WITH_AMOUNT_BTN}
  Input Text  ${LOCK_DGD_AMOUNT_FIELD}  ${p_amount}
  Wait And Click Element  ${LOCK_WITH_AMOUNT_BTN}

"${e_USER_TYPE}" Submits "${e_WALLET_TYPE}" Wallet To Locked DGD
  Load JQuery Tool
  Wait And Click Element  ${LOAD_WALLET_BTN}
  Wait And Click Element  ${LOAD_WALLET_SIDEBAR_BUTTON}
  Wait And Click Element  ${LOAD_WALLET_SIDEBAR_BUTTON} ${WALLET_${e_WALLET_TYPE}_BTN}
  Wait Until Element Should Be Visible  ${GOVERNANCE_MODAL} ${IMPORT_KEYSTORE_ICON}
  ${t_path}=  Normalize Path  ${CURDIR}/${KEYSTORE_PATH}/${e_USER_TYPE}.json
  Choose File  css=${IMPORT_KEYSTORE_UPLOAD_BTN}  ${t_path}
  User Submits Keystore Password
  Wait Until Element Should Be Visible  ${MESSAGE_SIGNER_FORM}
  User Submits Keystore Password  #sign message modal
  User Submits Locked DGD
  Wait Until Element Should Be Visible  ${GOVERNANCE_MODAL}
  User Submits Keystore Password  #transaction modal

"${e_USER}" Creates A Governance Propsosal
  Wait Until Element Should Be Visible  ${ADDRESS_LABEL}
  Wait And Click Element  ${GOVERNANCE_CREATE_BTN}
  ${t_time}=  Get Time  epoch
  ${t_strValue}=  Convert To String  ${t_time}
  Log To Console  ProjectName:${t_strValue}
  # overview
  Wait Until Element Should Be Visible  ${PROJECT_TITLE_FIELD}
  Input Text  ${PROJECT_TITLE_FIELD}  ${t_strValue}
  Input Text  ${PROJECT_DESC_FIELD}  ${t_strValue}
  Click Element  ${PROPOSAL_MENU_NEXT_BTN}
  #project detail
  Wait Until Element Should Be Visible  ${PROJECT_INFO_FIELD}
  Press Key  ${PROJECT_INFO_FIELD}  ${t_strValue}
  Click Element  ${PROPOSAL_MENU_NEXT_BTN}
  #multimedia
  Wait Until Element Should Be Visible  ${UPLOAD_IMAGE_BTN}
  Modify Element Attribute Via jQuery  ${IMAGE_UPLOAD_BTN}  display  block
  Upload TestData Image  image
  Click Element  ${PROPOSAL_MENU_NEXT_BTN}
  #milestone
  Wait Until Element Should Be Visible  ${MILESTONE_FORM}
  Input Text  ${REWARD_FIELD}  ${MILESTONE_REWARD_AMOUNT}
  Select From List By Label  ${NUM_OF_MILESTONE_FIELD}  ${NUMBER_OF_MILESTONE}
  Input Text  ${MILESTONE_FIELD}:eq(0)  ${MILESTONE_AMOUNT}
  Input Text  ${MILESTONE_DESC_FIELD}:eq(0)  ${t_strValue}
  Click Element  ${CREATE_NOW_BTN}
  #prevew
  Wait And Click Element  ${PROPOSAL_SUBMIT_BTN}
  Wait Until Element Should Not Be Visible  ${GOVERNANCE_MODAL}
  User Submits Keystore Password  #transaction modal
  Set Global Variable  ${g_GENERIC_VALUE}  ${t_strValue}

"${e_USER}" Endorses Newly Created Proposal
  Newly Created Proposal Should Be Visible On "Idea" Tab
  Visit And Click "Endorse" Button On Proposal View Page
  User Submits Keystore Password

#duplicate (parent: Endorses Newly Created Proposal)
"${e_USER}" Finalizes Created Proposal
  Newly Created Proposal Should Be Visible On "All" Tab
  Visit And Click "Finalize" Button On Proposal View Page
  User Submits Keystore Password

"${e_USER}" Approves Newly Drafted Proposal
  Proposal Status Should Be "DRAFT"
  Visit And Click "Approve" Button On Proposal View Page
  Get Remaining Time To Execute Next Step
  Wait Until Element Should Be Visible  ${GOVERNANCE_SIDE_PANEL}
  Wait And Click Element  ${GOVERNANCE_SIDE_PANEL} button:eq(0)
  Wait And Click Element  ${GOVERNANCE_SIDE_PANEL} button:eq(2)
  User Submits Keystore Password

"${e_USER}" Claims Approved Proposal
  Newly Created Proposal Should Be Visible On "All" Tab
  Visit And Click "Claim" Button On Proposal View Page
  User Submits Keystore Password

"${e_USER}" Votes "${e_RESPONSE}" On Proposal
  Newly Created Proposal Should Be Visible On "All" Tab
  Force Element Via jQuery  ${HELP_LAUNCHER}  hide
  Visit And Click "Vote" Button On Proposal View Page
  Get Remaining Time To Execute Next Step
  Wait Until Element Should Be Visible  ${GOVERNANCE_SIDE_PANEL}
  Run Keyword If  "${e_RESPONSE}"=="Yes"
  ...  Click Element  ${GOVERNANCE_SIDE_PANEL} button:eq(0)
  ...  ELSE IF  "${e_RESPONSE}"=="No"
  ...  Click Element  ${GOVERNANCE_SIDE_PANEL} button:eq(1)
  ${t_salt}=  Get Element Attribute  ${GOVERNANCE_SIDE_PANEL} a:eq(0)  download
  Wait And Click Element  ${GOVERNANCE_SIDE_PANEL} a:eq(0)
  Wait And Click Element  ${GOVERNANCE_SIDE_PANEL} button:eq(3)
  Replace Salt File According To User Role  ${t_salt}  ${e_USER}
  User Submits Keystore Password

"${e_USER}" Reveals Vote Via Salt File
  Newly Created Proposal Should Be Visible On "Proposal" Tab
  Visit And Click "Reveal" Button On Proposal View Page
  Get Remaining Time To Execute Next Step
  Upload "${e_USER}" Salt File
  Wait Until Element Should Be Visible  ${NOTE_CONTAINER}
  Wait And Click Element  css=div[class*="IntroContainer"] button[class*="RoundBtn"]
  Remove "${e_USER}" Salt File
  User Submits Keystore Password

"${e_USER}" Claims Voting Result
  Newly Created Proposal Should Be Visible On "All" Tab
  Visit And Click "Reveal" Button On Proposal View Page
  User Submits Keystore Password

"${e_USER}" Claims Proposal Funding
  Newly Created Proposal Should Be Visible On "All" Tab
  Element Should Contain  ${PROPOSAL_CARD}:eq(0) h2  ${g_GENERIC_VALUE}
  Wait And Click Element  ${PROPOSAL_CARD}:eq(0) ${VIEW_PROJECT_LINK}
  Wait Until Element Should Be Visible  ${PROJECT_SUMMARY}
  Click Element  ${PROJECT_SUMMARY} button[class*="RoundBtn"]:eq(1)  #claimFunding button
  User Submits Keystore Password

"${e_USER}" Sets Proposal To Commplete
  Newly Created Proposal Should Be Visible On "All" Tab
  Element Should Contain  ${PROPOSAL_CARD}:eq(0) h2  ${g_GENERIC_VALUE}
  Wait And Click Element  ${PROPOSAL_CARD}:eq(0) ${VIEW_PROJECT_LINK}
  Wait Until Element Should Be Visible  ${PROJECT_SUMMARY}
  Click Element  ${PROJECT_SUMMARY} button[class*="RoundBtn"]:last
  User Submits Keystore Password

#========#
#  THEN  #
#========#
User Should Be Able To Get Started On Governance
  Wait Until Element Should Be Visible  ${CONGRATULATION_BANNER}
  Wait Until Element Should Be Visible  ${GET_STARTED_BTN}

Newly Created Proposal Should Be Visible On "${e_TAB}" Tab
  Update Cards On "${e_TAB}" Tab
  Wait Until Element Should Be Visible  ${PROPOSAL_CARD}:eq(0) h2
  Element Should Contain  ${PROPOSAL_CARD}:eq(0) h2  ${g_GENERIC_VALUE}

User Should Be Able To Participate On Proposal
  Newly Created Proposal Should Be Visible On "All" Tab
  Wait Until Element Is Enabled  ${PROPOSAL_CARD}:eq(0) ${PARTICIPATE_BTN}

Proposal Status Should Be "${e_STATUS}"
  Newly Created Proposal Should Be Visible On "All" Tab
  Element Should Contain  ${PROPOSAL_CARD}:eq(0) ${PROPOSAL_STATUS_BTN}  ${e_STATUS}

Vote Count Should Increase
  Newly Created Proposal Should Be Visible On "All" Tab
  # Wait And Click Element  ${PROPOSAL_CARD}:eq(0) ${VIEW_PROJECT_LINK}

#====================#
#  INTERNAL KEYWORD  #
#====================#
User Submits Keystore Password
  Wait Until Element Should Be Visible  ${IMPORT_PASSWORD_FIELD}
  Input Text  ${IMPORT_PASSWORD_FIELD}  ${DAO_WALLET_PW}
  Wait And Click Element  ${UNLOCK_WALLET_BTN}

Update Cards On "${e_TAB}" Tab
  Wait Until Element Should Be Visible  ${GOVERNANCE_FILTER_SECTION}
  Modify Element Attribute Via jQuery  ${GOVERNANCE_MENU}  display  none
  Wait And Click Element  ${ARCHIVED_TAB}
  Wait And Click Element  ${${e_TAB}_TAB}

Replace Salt File According To User Role
  [Arguments]  ${p_filename}  ${p_role}
  ${t_path}=  Normalize Path  ~/Downloads/
  Wait Until Created  ${t_path}/${p_filename}  timeout= 30 seconds
  Move File  ${t_path}/${p_filename}  ${t_path}/${p_role}_salt.json

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
  Element Should Contain  ${PROPOSAL_CARD}:eq(0) h2  ${g_GENERIC_VALUE}
  Wait And Click Element  ${PROPOSAL_CARD}:eq(0) ${VIEW_PROJECT_LINK}

Visit And Click "${e_BUTTON_NAME}" Button On Proposal View Page
  Go To Newly Created Proposal View Page
  Wait And Click Element  ${PROJECT_SUMMARY} ${ROUND_BTN}

Upload "${e_USER}" Salt File
  Wait Until Element Should Be Visible  ${GOVERNANCE_SIDE_PANEL}
  ${t_file}=  Normalize Path  ~/Downloads/${e_USER}_salt.json
  Choose File  ${SALT_JSON_UPLOAD_BTN}  ${t_file}

Remove "${e_USER}" Salt File
  ${t_file}=  Normalize Path  ~/Downloads/${e_USER}_salt.json
  Remove File  ${t_file}

#====================#
#  SETUP / TEARDOWN  #
#====================#
"${e_USER}" Account Has Successfully Locked DGD
  Launch Digix Website  ${GOVERNANCE_LOGIN_URL_EXT}  ${ENVIRONMENT}  ${e_USER}
  Given User Is In "GOVERNANCE_LOGIN" Page
  When "${e_USER}" Submits "json" Wallet To Locked DGD
  Then User Should Be Able To Get Started On Governance
  Wait And Click Element  ${GET_STARTED_BTN}