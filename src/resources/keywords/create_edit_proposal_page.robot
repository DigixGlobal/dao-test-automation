*** Settings ***
Resource   proposal_view_page.robot
Resource    ../variables/governance_constants.robot

*** Variables ***
${GOVERNANCE_CREATE_BTN}  css=[data-digix="Proposal-Create-Btn"]
# create proposal fields
${PROPOSAL_TAB_PANEL}  jquery=div[class*="TabPanel"]
${PROPOSAL_MENU}  ${PROPOSAL_TAB_PANEL} +  [class*="Header"] > div:eq(1)
${PROPOSAL_MENU_PREVIEW_BTN}  css=[data-digix*="-Proposal-Preview"]
${PROPOSAL_MENU_PREVIOUS_BTN}  css=[data-digix*="-Proposal-Previous"]
${PROPOSAL_MENU_NEXT_BTN}  css=[data-digix*="-Proposal-Next"]
${PROJECT_TITLE_FIELD}  css=input[id="title"]
${PROJECT_DESC_FIELD}  css=textarea[id="description"]
${PROJECT_INFO_FIELD}  css=#details .ql-editor
${UPLOAD_IMAGE_BTN}  css=[class*="UploadButton"]
${IMAGE_UPLOAD_BTN}  css=input[id="image-upload"][type="file"]
${REWARD_FIELD}  css=input[id="finalReward"]
${NUM_OF_MILESTONE_FIELD}  css=select[id="noOfMilestones"]
${MILESTONE_FORM}  jquery=div[class*="CreateMilestone"]
${MILESTONE_FIELD}  ${MILESTONE_FORM} input
${MILESTONE_DESC_FIELD}  ${MILESTONE_FORM} .ql-editor  #textarea
${CREATE_NOW_BTN}   css=[data-digix*="-Proposal-Button"]
${PROPOSAL_SUBMIT_BTN}  css=[data-digix="Confirm-Submit-Btn"]
#Preview
${CONTINUE_EDITING_BTN}  css=[data-digix="Preview-Continue"]
#error overlay
${ERROR_OVERLAY_CONTAINER}  css=[data-digix="ProjectError-Notification"]
${ERROR_CARD_TITLE}  css=[data-digix="ProjectError-Notification-Title"]
${ERROR_OVERLAY_RETURN_BTN}  css=[data-digix="ProjectError-Return"]
${ERROR_KYC_NOT_APPROVED_MSG}  KYC IS NOT VALID

*** Keywords ***
#========#
#  WHEN  #
#========#
"${e_USER}" Ticks Create Button On Dashboard Page
  Wait And Click Element  ${GOVERNANCE_CREATE_BTN}

User Closes Error Overlay
  Wait And Click Element  ${ERROR_OVERLAY_RETURN_BTN}

"${e_USER}" Creates A Governance Propsosal
  Pull Project Creator Name
  User Goes To Create Proposal Page
  User Submit Proposal Details

# "${e_USER}" Edits Newly Created Proposal Details
#   Wait And Click Element  ${PROJECT_SUMMARY} ${ROUND_BTN}:last
#   User Submit Proposal Details  3  4  edit

User Submit Proposal Details
  [Arguments]  ${p_reward}=${MILESTONE_REWARD_AMOUNT}  ${p_milestone}=${MILESTONE_AMOUNT}  ${p_type}=Create
  Set Proposal Value  ${p_type}
  # overview
  User Submits Primary Proposal Details  ${g_GENERIC_VALUE}  ${g_GENERIC_VALUE}
  #project detail
  User Submits Secondary Proposal Details  ${g_GENERIC_VALUE}
  #multimedia
  User Submits Multimedia Images
  #milestone
  User Submits Milestone Details  ${p_reward}  ${p_milestone}  ${g_GENERIC_VALUE}
  #prevew
  User Submits Proposal Details

#========#
#  THEN  #
#========#
Error Overlay Should "${e_ACTION}" Visible
  Run Keyword  Wait Until Element Should ${e_ACTION} Visible  ${ERROR_OVERLAY_RETURN_BTN}
  Run Keyword If  '${e_ACTION.lower()}'!='not be'
  ...  Wait Until Element Should Contain  ${ERROR_CARD_TITLE}  ${ERROR_KYC_NOT_APPROVED_MSG}

#=====================#
#  INTERNAL KEYWORDS  #
#=====================#
Compute Suite Total Funding
  ${t_total}=  Set Variable  ${s_MILESTONE_AMOUNT}
  ${t_strFunding}=  Convert To String  ${t_total}
  Set Suite Variable  ${s_TOTAL_FUNDING}  ${t_strFunding}

User Goes To Create Proposal Page
  Wait Until Element Should Be Visible  ${ADDRESS_LABEL}
  Wait And Click Element  ${GOVERNANCE_CREATE_BTN}

User Submits Primary Proposal Details
  [Arguments]  ${p_title}  ${p_shortDesc}
  Wait Until Element Should Be Visible  ${PROJECT_TITLE_FIELD}
  Input Text  ${PROJECT_TITLE_FIELD}  ${p_title}
  Input Text  ${PROJECT_DESC_FIELD}  ${p_shortDesc}
  Click Element  ${PROPOSAL_MENU_NEXT_BTN}

User Submits Secondary Proposal Details
  [Arguments]  ${p_desc}=None
  Wait Until Element Should Be Visible  ${PROJECT_INFO_FIELD}
  Clear Element Text  ${PROJECT_INFO_FIELD}
  Press Key  ${PROJECT_INFO_FIELD}  ${p_desc}
  Click Element  ${PROPOSAL_MENU_NEXT_BTN}

User Submits Multimedia Images
  [Arguments]  ${p_image}=image
  Wait Until Element Should Be Visible  ${UPLOAD_IMAGE_BTN}
  # Modify Element Attribute Via jQuery  ${IMAGE_UPLOAD_BTN}  display  block
  Upload TestData Image  image
  Click Element  ${PROPOSAL_MENU_NEXT_BTN}

User Submits Milestone Details
  [Arguments]  ${p_reward}  ${p_milestone}  ${t_value}
  Wait Until Element Should Be Visible  ${MILESTONE_FORM}
  Input Text  ${REWARD_FIELD}  ${p_reward}
  Select From List By Label  ${NUM_OF_MILESTONE_FIELD}  ${NUMBER_OF_MILESTONE}
  :FOR  ${index}  IN RANGE  0  ${NUMBER_OF_MILESTONE}
  \  Input Text  ${MILESTONE_FIELD}:eq(${index})  ${p_milestone}
  \  Input Text  ${MILESTONE_DESC_FIELD}:eq(${index})  ${t_value}
  Set Suite Variable  ${s_REWARD_AMOUNT}  ${p_reward}
  Set Suite Variable  ${s_MILESTONE_AMOUNT}  ${p_milestone}
  Hide Governance Header Menu
  Compute Suite Total Funding
  Click Element  ${CREATE_NOW_BTN}

User Previews Details
  Wait And Click Element  ${PROPOSAL_MENU_PREVIEW_BTN}

User Edits Proposal Details
  Hide Governance Header Menu
  Wait And Click Element  ${PROJECT_SUMMARY} ${ROUND_BTN}:last

Proposal Preview Should Be Visible
  Wait Until Element Should Be Visible  ${PROPOSAL_TITLE_DIV}
  Element Should Contain  ${PROPOSAL_TITLE_DIV}  ${g_GENERIC_VALUE}  ignore_case=${TRUE}

User Submits Proposal Details
  Wait And Click Element  ${PROPOSAL_SUBMIT_BTN}
  User Submits Keystore Password  #transaction modal
  Run Keyword If  '${ENVIRONMENT}'=='KOVAN'  Run Keywords
  ...  Log To Console  sleep the test due to it runs on ${ENVIRONMENT} for 60 seconds
  ...  AND  Sleep  60 seconds

User Goes Back To Previous Page
  Wait And Click Element  ${CONTINUE_EDITING_BTN}

Set Proposal Value
  [Arguments]  ${p_type}=Create
  ${t_time}=  Get Time  epoch
  ${t_strValue}=  Convert To String  ${t_time}
  ${t_value}=  Set Variable If  "${p_type.lower()}"=="create"
  ...  ${t_strValue}  ${t_strValue} - edit
  Log To Console  ${\n}ProjectName:${t_strValue}
  Set Global Variable  ${g_GENERIC_VALUE}  ${t_value}
