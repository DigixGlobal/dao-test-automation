*** Keywords ***
User Goes To "${e_SIDEMENU}" View Page
  Open SideNav Menu If Not Visible
  Wait And Click Element  ${${e_SIDEMENU}_SIDE_MENU_ICON}

Pull "${e_ACCOUNT}" From SideNav
  Pull Project Creator Name
  Set Suite Variable  ${${e_ACCOUNT}_USERNAME}  ${s_PROJECT_CREATOR}

Go Back To Dashboard Page
  User Goes To "Home" View Page
  Wait Until Element Should Be Visible  ${GOVERNANCE_FILTER_SECTION}

Go To Newly Created Proposal View Page
  Get Proposal Card Index
  Hide SnackBar
  Hide Governance Header Menu
  Wait And Click Element  ${s_PROPOSAL_INDEX}

"${e_STATE}" SideNav Menu Items Should Be Visible
  :FOR  ${locator}  IN  @{${e_STATE}_SIDENAV_LIST}
  \  Wait Until Element Should Be Visible  ${locator}

Upload Json Wallet Based On Environment
  [Arguments]  ${p_filename}  ${p_environment}=${ENVIRONMENT}
  ${t_path}=  Normalize Path  ${CURDIR}/${KEYSTORE_PATH}/${p_environment}/${p_filename}.json
  Choose File  ${IMPORT_KEYSTORE_UPLOAD_BTN}  ${t_path}

User Locks DGD on "${e_ENTRY_POINT}"
  ${t_entry_btn}=  Set Variable If
  ...  '${e_ENTRY_POINT.lower()}'=='header'  ${HEADER_LOCK_DGD_BTN}
  ...  '${e_ENTRY_POINT.lower()}'=='wallet'  ${WALLET_LOCKED_DGD_BTN}
  ...  '${e_ENTRY_POINT.lower()}'=='profile'  ${PROFILE_LOCKED_DGD_BTN}
  ${t_dgd_value}=  LookUp Value On Info Server  ${s_ADDRESS}  /result/lockedDgd
  Set Suite Variable  ${s_LOCKED_DGD}  ${t_dgd_value}
  Wait And Click Element  ${t_entry_btn}
  User Submits Locked Stake

Locked DGD Value Should Increase
  ${t_previous_value}=  Convert To Integer  ${s_LOCKED_DGD}
  ${t_current_value}=  Evaluate  ${t_previous_value} + ${s_LOCkED_AMOUNT_DGD}
  ${t_str}=  Convert To String  ${t_current_value}
  Wait Until Element Should Contain  ${STAT_LOCKED_DGD_POINT}  ${t_str}

Get Max Limit Funding
  ${t_url}=  Set Variable  ${${ENVIRONMENT}_INFO_SERVER_URL}/daoConfigs
  ${t_value}=  Find Value On Json URL  ${t_url}  /result/CONFIG_MAX_FUNDING_FOR_NON_DIGIX
  Set Suite Variable  ${s_MAX_FUNDING}  ${t_value}


Repeat Until Newly Created Project Is On "${e_TAB}" Tab
  Wait Until Element Should Be Visible  ${PROPOSAL_CARD}:eq(0) h2
  :FOR  ${index}  IN RANGE  0  5
  \  ${t_titles}=  Get WebElements  ${PROPOSAL_TITLE}
  \  Assert Title Is Visible In List  ${t_titles}
  # \  ${t_status}=  Run Keyword And Return Status
  # ...  Wait Until Element Contains  ${PROPOSAL_CARD}:eq(0) h2  ${g_GENERIC_VALUE}  timeout=5 seconds
  \  Run Keyword If  '${s_CARD_INDEX}'!='None'
  ...  Exit For Loop
  ...  ELSE  Switch "${e_TAB}" Tab To Update Content

Assert Title Is Visible In List
  [Arguments]  ${p_list}
  : For  ${index}  ${locator}  IN ENUMERATE  @{p_list}
  \  ${t_title}=  Get Text  ${locator}
  \  ${t_index}=  Run Keyword If  '${t_title}'=='${g_GENERIC_VALUE}'
  ...  Set Variable  ${index}  ELSE  Set Variable  None
  \  Exit For Loop If  '${t_title}'=='${g_GENERIC_VALUE}'
  Set Suite Variable  ${s_CARD_INDEX}  ${t_index}

Quorum Percentage Progress Bar Value Shoule Be Correct
  [Arguments]  ${p_type}=Special
  Load JQuery Tool
  Wait Until Element Should Be Visible  ${ACCORDION_ITEM}:first ${QUORUM_PROGRESS_BAR}
  ${t_totalLockedDGD}=  Find Value On Json URL  ${LOCAL_DAO_INFO_URL}  /result/totalLockedDgds
  ${t_url}=  Get Location
  ${t_proposalID}=  Fetch From Right  ${t_url}  /proposals
  ${t_stakePath}=  Set Variable  /result/votingRounds/0/totalVoterStake
  ${t_totalStake}=  Find Value On Json URL  ${${ENVIRONMENT}_INFO_DETAILS_URL}${t_proposalID}  ${t_stakePath}
  ${t_result}=  Evaluate  (${t_totalStake} / ${t_totalLockedDGD})
  ${t_int}=   Evaluate  "%.2f" % ${t_result}
  ${t_attr}=  Get Element Attribute  ${ACCORDION_ITEM}:first ${QUORUM_PROGRESS_BAR}  style
  ${t_value}=  Get Regexp Matches  ${t_attr}  scaleX\\((.*)\\)  1
  ${t_precise}=   Evaluate  "%.2f" % ${t_value[0]}
  Should Be Equal  ${t_int}  ${t_precise}

Compute Minimum Quorum Required
  [Arguments]  ${p_type}=Special
  Load JQuery Tool
  ${t_url}=  Set Variable  ${${ENVIRONMENT}_INFO_SERVER_URL}/daoConfigs
  ${t_numerator}=  Find Value On Json URL  ${t_url}  /result/CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR
  ${t_denominator}=  Find Value On Json URL  ${t_url}  /result/CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR
  ${t_result}=  Evaluate  (${t_numerator} / ${t_denominator}) * 100
  ${t_int}=  =  Evaluate  "%.2f" % ${t_number}
