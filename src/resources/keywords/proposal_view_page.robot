*** Settings ***
Resource    ../variables/governance_constants.robot

*** Variables ***
# proposal
${PROJECT_SUMMARY}  jquery=div[class*="ProjectSummary"]
${PROPOSAL_TITLE_DIV}  ${PROJECT_SUMMARY} [class*="Title"]
${PROPOSAL_FUNDING_DIV}  ${PROJECT_SUMMARY} [class*="FundingStatus"]
${PROPOSAL_REWARD_DIV}  ${PROJECT_SUMMARY} [class*="Reward"] span
${PROPOSAL_DETAILS_DIV}  jquery=[class*="DetailsContainer"]
${PROPOSAL_SHORT_DESC_DIV}  ${PROPOSAL_DETAILS_DIV} [class*="ShortDescription"]
${PROPOSAL_DESC_DIV}  ${PROPOSAL_DETAILS_DIV} [class*="Details"] span
${PROPOSAL_MILESTONE_DIV}  jquery=[class*="MilestonesContainer"]
${PROPOSAL_MILESTONE_ARROW_ICON}  ${PROPOSAL_MILESTONE_DIV} svg:last
${PROPOSAL_MS_DESC_DIV}  ${PROPOSAL_MILESTONE_DIV} [class*="Content"]
${PROPOSAL_MS_AMOUNT_DIV}  ${PROPOSAL_MS_DESC_DIV} > p
${TIMER_DIV}  css=div[class*="QuorumInfoCol"]

*** Keywords ***
#========#
#  WHEN  #
#========#
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

Vote Count Should Increase
  Newly Created Proposal Should Be Visible On "All" Tab
  # Wait And Click Element  ${PROPOSAL_CARD}:eq(0) ${VIEW_PROJECT_LINK}

#=====================#
#  INTERNAL KEYWORDS  #
#=====================#
Replace Salt File According To User Role
  [Arguments]  ${p_filename}  ${p_role}
  ${t_path}=  Normalize Path  ~/Downloads/
  Wait Until Created  ${t_path}/${p_filename}  timeout=${g_TIMEOUT_SEC}
  Move File  ${t_path}/${p_filename}  ${t_path}/${p_role}${SALT_FILE_EXT}

"${e_ACTION}" "${e_USER}" Salt File
  ${t_file}=  Normalize Path  ~/Downloads/${e_USER}${SALT_FILE_EXT}
  Run Keyword If  "${e_ACTION}"=="Upload"  Run Keywords
  ...  Wait Until Element Should Be Visible  ${GOVERNANCE_SIDE_PANEL}
  ...  AND  Choose File  ${SALT_JSON_UPLOAD_BTN}  ${t_file}
  ...  ELSE  Remove File  ${t_file}

Get Remaining Time To Execute Next Step
  Wait Until Element Should Be Visible  ${TIMER_DIV}
  ${t_text}=  Get Text  ${TIMER_DIV}
  Set Global Variable  ${g_TIMER}  ${t_text}

Sleep Until Timer Runs Out
  [Arguments]  ${p_type}=DEFAULT
  # sample data  0D:00H:01M:29S
  Capture Page Screenshot
  ${t_minutes}=  Get Regexp Matches  ${g_TIMER}  (?<=H:)(.*)(?=M)
  ${t_seconds}=  Get Regexp Matches  ${g_TIMER}  (?<=M:)(.*)(?=S)
  ${t_numMin}=  Convert To Number  ${t_minutes[0]}
  ${t_nummSec}=  Convert To Number  ${t_seconds[0]}
  ${t_min}=  Evaluate  ${t_numMin} * 60
  ${t_total}=  Evaluate  ${t_min} + ${t_nummSec}
  ${t_div}=  Evaluate  ${t_total} / 2
  ${t_time}=  Set Variable If  "${p_type}"=="REVEAL"
  ...  ${t_div}  ${t_total}
  Log To Console  ${t_time} remaining seconds to start next step
  Sleep  ${t_time} seconds

Assign ID For Interaction Buttons
  Wait Until Element Should Be Visible  ${PROJECT_SUMMARY}
  @{t_elements}=  Get WebElements  ${PROJECT_SUMMARY} ${ROUND_BTN}
  :FOR  ${locator}  IN  @{t_elements}
  \  ${t_text}=  Get Text  ${locator}
  \  Log  ${t_text}
  \  Assign Id To Element  ${locator}  ${t_text}