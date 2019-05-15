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