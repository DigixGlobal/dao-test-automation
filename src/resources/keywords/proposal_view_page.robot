*** Settings ***
Resource    ../variables/governance_constants.robot

*** Variables ***
# Interaction Buttons
${PROPOSAL_ADD_UPDATE_BTN}  css=[data-digix="ADD-UPDATES"]
${PROPOSAL_CLAIM_FAILED_BTN}  css=[data-digix="ProposalAction-Approval"]
${PROPOSAL_CLAIM_APPROVAL_BTN}  ${PROPOSAL_CLAIM_FAILED_BTN}
${PROPOSAL_CONFIRMING_CLAIM_BTN}  css=[data-digix="Confirm-Claim-Button"]
${PROPOSAL_ABORT_BTN}  css=[data-digix="ProposalAction-Abort"]
${PROPOSAL_CLAIM_RESULT_BTN}  css=[data-digix="ProposalAction-Results"]
${PROPOSAL_CLAIM_FUNDING_BTN}  css=[data-digix="ProposalAction-ClaimFunding"]
${PROPOSAL_EDIT_FUNDING_BTN}  css=[data-digix="ProposalAction-EditFunding"]
${PROPOSAL_MS_COMPLETE_BTN}  css=[data-digix="ProposalAction-CompleteMilestone"]
${PROPOSAL_VOTE_BTN}  ${PROJECT_SUMMARY} ${ROUND_BTN}:last
${PROPOSAL_EDIT_BTN}  ${PROJECT_SUMMARY} ${ROUND_BTN}:last
${PROPOSAL_CLAIMING_BTN}  ${PROJECT_SUMMARY} ${ROUND_BTN}:last
# proposal
${PROPOSAL_VERSION_HISTORY}  css=[data-digix="Proposal-Version-History"]
${PROPOSAL_VERSION_PREVIOUS}  css=[data-digix="Previous-Version"]
${PROPOSAL_VERSION_NEXT}  css=[data-digix="Next-Version"]
${PROJECT_SUMMARY}  jquery=div[class*="ProjectSummary"]
${PROPOSAL_STATUS_DIV}  css=${PROPOSAL_STATUS_BTN}
${PROPOSAL_TITLE_DIV}  ${PROPOSAL_TITLE}
${PROPOSAL_FUNDING_DIV}  css=[data-digix="funding-amount-label"]
${PROPOSAL_EDIT_FUNDING_LABEL}  css=[data-digix="edit-funding-amount-label"]
${PROPOSAL_REWARD_DIV}  css=[data-digix="reward-amount-label"]
${PROPOSAL_EDIT_REWARD_LABEL}  css=[data-digix="edit-reward-amount-label"]
# ${PROPOSAL_DETAILS_DIV}  jquery=[class*="DetailsContainer"]
${PROPOSAL_SHORT_DESC_DIV}  ${PROPOSAL_SHORT_DESC}
${PROPOSAL_DESC_DIV}  css=[data-digix="Details-Desc"]
${PROPOSAL_UPDATE_SECTION}  css=[data-digix="Add-Updates-Section"]
${PROPOSAL_MILESTONE_DIV}  jquery=[class*="AccordionItem"]
${PROPOSAL_MILESTONE_ARROW_ICON}  ${PROPOSAL_MILESTONE_DIV} svg:last
${PROPOSAL_MS_DESC_DIV}  css=[data-digix="Milestone-Desc"]
${PROPOSAL_MS_AMOUNT_DIV}  css=[data-digix="Milestone-Amount"]
${PROPOSAL_CLAIM_NOTIF_BANNER}  css=[class*="Notifications"]

# Voting Accordion Component
${ACTIVE_ACCORDION_ITEM}  jquery=[data-digix="Timer-Progress"]
${VOTE_USER_COUNT}  css=[data-digix="Vote-User-Count"]
${TIMER_DIV}  [data-digix="Vote-Countdown-Timer"]:first  #[class*="QuorumInfoCol"]:first span:last
${TIMER_ENDED_DIV}  [data-digix="Vote-Countdown-Ended"]
${VOTE_YES_COUNT}  css=[data-digix="Vote-Yes-Count"]
${VOTE_NO_COUNT}  css=[data-digix="Vote-No-Count"]

# Add Documents Component
${ADD_DOCS_BTN}  css=[data-digix="CONFIRM-ADD-MORE-DOCS"]
${ADD_DOCS_UPLOAD_BTN}  css=[id="image-upload-0"]
${ADD_DOCS_REMOVE_BTN}  css=[data-digix="REMOVE-BUTTON"]
${ADD_MORE_DOCS_BTN}  css=[data-digix="ADD-MORE-DOCS"]

# Edit Funding Overlay
${EDIT_FUNDING_REWARD_FIELD}  css=[data-digix="Edit-funding-reward-expected"]
${EDIT_FUNDING_MILESTONE1_FIELD}  css=[data-digix="Edit-milestone-funding-1"]
${EDIT_FUNDING_MILESTONE2_FIELD}  css=[data-digix="Edit-milestone-funding-2"]
${EDIT_FUNDING_BTN}  css=[data-digix="Edit-Funding"]

# contents
${CLAIM_SUCCESS_MSG}  The voting result shows that your project passes the voting.

*** Keywords ***
#========#
#  WHEN  #
#========#
User Go Back To Previous Version
  Hide Governance Header Menu
  Wait And Click Element  ${PROPOSAL_VERSION_PREVIOUS}

 User Aborts The Project
  User Revisits Newly Created Proposal
  Wait And Click Element  ${PROPOSAL_ABORT_BTN}
  User Submits Keystore Password  #transaction modal

User Claims Failed Project
  User Revisits Newly Created Proposal
  Wait And Click Element  ${PROPOSAL_CLAIM_FAILED_BTN}
  User Submits Keystore Password  #transaction modal

User Adds Additional Documents
  User Revisits Newly Created Proposal
  Get Remaining Time To Execute Next Step
  Wait And Click Element  ${PROPOSAL_ADD_UPDATE_BTN}
  Wait Until Element Should Be Visible  ${ADD_DOCS_BTN}
  Upload TestData Image  add_docs
  Wait And Click Element  ${ADD_DOCS_BTN}
  User Submits Keystore Password  #transaction modal

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
  Enable Download On Headless Browser
  Wait And Click Element  ${GOVERNANCE_SIDE_PANEL} a:eq(0)  #Download Json File button
  ${t_name}=  Get Element Attribute  ${GOVERNANCE_SIDE_PANEL} a:eq(0)  download
  ${t_salt}=  Replace String  ${t_name}  :  _
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
  ${t_vote}=  Get Value From Json  ${t_content}  /vote
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

"${e_USER}" Claims "${e_TYPE}" Voting Result
  Newly Created Proposal Should Be Visible On "All" Tab
  Go To Newly Created Proposal View Page
  Wait Until Element Should Contain  ${PROPOSAL_CLAIM_NOTIF_BANNER}  ${CLAIM_SUCCESS_MSG}
  User Claims Multiple Results  ${e_TYPE}
  Go Back To Dashboard Page

User Edits Proposal Funding
  [Arguments]  ${p_reward}=5  ${p_milestone}=8
  Newly Created Proposal Should Be Visible On "All" Tab
  Hide SnackBar
  Go To Newly Created Proposal View Page
  Wait Until Element Should Be Visible  ${PROJECT_SUMMARY}
  ${t_current_MS}=  Get Text  ${PROPOSAL_FUNDING_DIV}
  Set Suite Variable  ${s_CURRENT_TOTAL_MS}  ${t_current_MS}
  ${t_current_reward}=  Get Text  ${PROPOSAL_REWARD_DIV}
  Set Suite Variable  ${s_CURRENT_TOTAL_REWARD}  ${t_current_reward}
  Wait And Click Element  ${PROPOSAL_EDIT_FUNDING_BTN}
  Wait Until Element Should Be Visible  ${EDIT_FUNDING_REWARD_FIELD}
  ${t_ms_one}=  Get Value   ${EDIT_FUNDING_MILESTONE1_FIELD}
  Set Suite Variable  ${s_MS_ONE}  ${t_ms_one}
  Clear Element Text  ${EDIT_FUNDING_REWARD_FIELD}
  Input Text  ${EDIT_FUNDING_REWARD_FIELD}  ${p_reward}
  Set Suite Variable  ${s_EDIT_REWARD_AMOUNT}  ${p_reward}
  Clear Element Text  ${EDIT_FUNDING_MILESTONE2_FIELD}
  Input Text  ${EDIT_FUNDING_MILESTONE2_FIELD}  ${p_milestone}
  Set Suite Variable  ${s_MS_TWO}  ${p_milestone}
  Wait And Click Element  ${EDIT_FUNDING_BTN}
  User Submits Keystore Password  #transaction modal

User Claims Multiple Results
  [Arguments]  ${p_type}
  ${t_locator}=  Set Variable If  '${p_type.lower()}'=='moderator'
  ...  ${PROPOSAL_CLAIM_APPROVAL_BTN}  ${PROPOSAL_CLAIM_RESULT_BTN}
  Wait Until Element Should Be Visible  ${t_locator}
  ${t_value}=  Get Text  ${t_locator}
  ${t_counter}=  Get Regexp Matches  ${t_value}  (?<=\/)(.*)
  :for  ${index}  IN RANGE  ${t_counter[0]}
  \  ${t_label}=  Evaluate  ${index} + 1
  \  Wait Until Element Should Be Enabled  ${t_locator}
  \  Wait Until Element Should Contain  ${t_locator}  ${t_label}/${t_counter[0]}
  \  Wait And Click Element  ${t_locator}
  \  Wait Until Element Should Contain  ${PROPOSAL_CONFIRMING_CLAIM_BTN}  ${t_label}/${t_counter[0]}
  \  Wait And Click Element  ${PROPOSAL_CONFIRMING_CLAIM_BTN}
  \  User Submits Keystore Password  #transaction modal
  \  Sleep  2 seconds

#========#
#  THEN  #
#========#
Additional Document Section Should Be Visible
  Wait Until Element Should Be Visible  ${PROPOSAL_UPDATE_SECTION}

Version Container Should Be Visible
  Wait Until Element Should Be Visible  ${PROPOSAL_VERSION_HISTORY}

Project Details Page Status Should Be "${e_STATUS}"
  Wait Until Element Should Contain  ${PROPOSAL_STATUS_DIV}  ${e_STATUS.upper()}

Proposal Details Should Be Correct On Proposal Details Page
  [Arguments]  ${p_type}=edit
  ${t_value}=  Set Variable If  '${p_type.lower()}'=='edit'
  ...  ${g_GENERIC_VALUE}  ${s_CREATE_GENERIC_VALUE}
  ${t_str}=  Convert To String  ${t_value}
  Wait Until Element Should Be Visible  ${PROPOSAL_TITLE_DIV}
  Element Should Contain Text  ${PROPOSAL_TITLE_DIV}  ${t_value}
  Force Element Via jQuery  ${HELP_LAUNCHER}  hide
  ${t_notVisible}=  Run Keyword And Return Status  Element Should Not Be Visible  ${PROPOSAL_MS_DESC_DIV}
  Run Keyword If  ${t_notVisible}  Wait And Click Element  ${PROPOSAL_MILESTONE_ARROW_ICON}
  Wait Until Element Should Contain  ${PROPOSAL_SHORT_DESC_DIV}  ${t_str}
  Wait Until Element Should Contain  ${PROPOSAL_DESC_DIV}  ${t_str}
  # Wait Until Element Should Contain  ${PROPOSAL_MS_DESC_DIV}  ${t_str}  #temp disabled
  Run Keyword If  '${p_type.lower()}'=='edit'  Run Keywords
  ...  Element Should Contain Text  ${PROPOSAL_MS_AMOUNT_DIV}  ${s_MILESTONE_AMOUNT}
  ...  AND  Element Should Contain Text  ${PROPOSAL_REWARD_DIV}  ${s_REWARD_AMOUNT}
  ...  AND  Element Should Contain Text  ${PROPOSAL_FUNDING_DIV}  ${s_TOTAL_FUNDING}

Vote Count Should Increase
  Newly Created Proposal Should Be Visible On "All" Tab
  # Wait And Click Element  ${PROPOSAL_CARD}:eq(0) ${VIEW_PROJECT_LINK}

Funding Should be Changed
  Newly Created Proposal Should Be Visible On "All" Tab
  Hide SnackBar
  Go To Newly Created Proposal View Page
  ${t_milestone}=  Compute New Milestone Funding
  Element Should Contain Text  ${PROPOSAL_EDIT_FUNDING_LABEL}  ${t_milestone}
  ${t_reward}=  Compute New Reward Funding
  Element Should Contain Text  ${PROPOSAL_EDIT_REWARD_LABEL}  ${t_reward}

#=====================#
#  INTERNAL KEYWORDS  #
#=====================#
Return Number Of User On Config
  [Arguments]  ${p_type}=moderator
  ${t_lookup}=  Set Variable If  '${p_type.lower()}'=='moderator'
  ...  nModerators  nParticipants
  ${t_value}=  Find Value On Json Url  ${${ENVIRONMENT}_DAO_INFO_URL}  /result/${t_lookup}
  [Return]  ${t_value}

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
  Wait Until Element Should Be Visible  ${ACTIVE_ACCORDION_ITEM} ${TIMER_DIV}
  ${t_text}=  Get Text  ${ACTIVE_ACCORDION_ITEM} ${TIMER_DIV}
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

Compute New Milestone Funding
  ${t_total}=  Evaluate  ${s_MS_ONE} + ${s_MS_TWO}
  ${t_edit_funding}=  Evaluate   ${t_total} - ${s_CURRENT_TOTAL_MS}
  ${t_str_edit_funding}=  Convert To String  ${t_edit_funding}
  [Return]  ${t_str_edit_funding}

Compute New Reward Funding
  ${t_reward}=  Evaluate   ${s_EDIT_REWARD_AMOUNT} - ${s_CURRENT_TOTAL_REWARD}
  ${t_strReward}=  Convert To String  ${t_reward}
  [Return]  ${t_strReward}
