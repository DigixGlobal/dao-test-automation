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
