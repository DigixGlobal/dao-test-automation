*** Settings ***
Resource    ../variables/governance_constants.robot

*** Variables ***
${GOVERNANCE_CREATE_BTN}  css=a[href="#/proposals/create"] button
# create proposal fields
${PROPOSAL_TAB_PANEL}  jquery=div[class*="TabPanel"]
${PROPOSAL_MENU}  ${PROPOSAL_TAB_PANEL} +  [class*="Header"] > div:eq(1)
${PROPOSAL_MENU_PREVIEW_BTN}  ${PROPOSAL_MENU} button:eq(0)
${PROPOSAL_MENU_PREVIOUS_BTN}  ${PROPOSAL_MENU} button:eq(1)
${PROPOSAL_MENU_NEXT_BTN}  ${PROPOSAL_MENU} button:eq(2)
${PROJECT_TITLE_FIELD}  css=input[id="title"]
${PROJECT_DESC_FIELD}  css=textarea[id="description"]
${PROJECT_INFO_FIELD}  css=#details .ql-editor
${UPLOAD_IMAGE_BTN}  css=[class*="UploadButton"]
${IMAGE_UPLOAD_BTN}  css=input[id="image-upload"][type="file"]
${REWARD_FIELD}  css=input[id="finalReward"]
${NUM_OF_MILESTONE_FIELD}  css=select[id="noOfMilestones"]
${MILESTONE_FORM}  jquery=div[class*="CreateMilestone"]
${MILESTONE_FIELD}  ${MILESTONE_FORM} input
${MILESTONE_DESC_FIELD}  ${MILESTONE_FORM} textarea
${CREATE_NOW_BTN}  ${PROPOSAL_MENU_NEXT_BTN}
${PROPOSAL_SUBMIT_BTN}  jquery=div[class*="ContentWrapper"] button:eq(1)
*** Keywords ***
#========#
#  WHEN  #
#========#
"${e_USER}" Creates A Governance Propsosal
  Wait Until Element Should Be Visible  ${ADDRESS_LABEL}
  Wait And Click Element  ${GOVERNANCE_CREATE_BTN}
  User Submit Proposal Details

"${e_USER}" Edits Newly Created Proposal Details
  Wait And Click Element  ${PROJECT_SUMMARY} ${ROUND_BTN}:last
  User Submit Proposal Details  3  4  edit

User Submit Proposal Details
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

#=====================#
#  INTERNAL KEYWORDS  #
#=====================#
Compute Suite Total Funding
  ${t_total}=  Evaluate  ${s_REWARD_AMOUNT} + ${s_MILESTONE_AMOUNT}
  ${t_strFunding}=  Convert To String  ${t_total}
  Set Suite Variable  ${s_TOTAL_FUNDING}  ${t_strFunding}
