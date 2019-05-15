*** Settings ***
Documentation  This suite will test posting a project using founder/account3
...  wallet without funding limit
Force Tags    smoke    regression
Default Tags    DaoNoLimitFundingTest
Suite Setup  Get Max Limit Funding
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot

*** Variables ***
${NUMBER_OF_MILESTONE}  1

*** Test Cases ***
Founder Has Successfully Created A Proposal Without Funding Limit
  [Setup]  Run Keywords  Set Proposal Value  create
  ...  AND  "${founder}" Account Has Successfully Logged In To DigixDao Using "${WALLET}"
  Given User Is In "GOVERNANCE" Page
  When User Goes To Create Proposal Page
  And User Submits Primary Proposal Details  ${g_GENERIC_VALUE}  ${g_GENERIC_VALUE}
  And User Submits Secondary Proposal Details  ${g_GENERIC_VALUE}
  And User Submits Multimedia Images
  And User Submits Milestone Details  ${s_MAX_FUNDING}  ${s_MAX_FUNDING}  ${g_GENERIC_VALUE}
  And User Submits Proposal Details
  Then User Should Be Redirected To "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "Idea" Tab
  And Proposal Status Should Be "IDEA"
  When Go To Newly Created Proposal View Page
  Then Proposal Details Should Be Correct On Proposal Details Page

Founder Has Successfully Edited A Proposal Without Funding Limit
  [Setup]  Set Proposal Value  edit
  Given User Is In "PROPOSAL_VIEW" Page
  When User Edits Proposal Details
  And User Submits Primary Proposal Details  ${g_GENERIC_VALUE}  ${g_GENERIC_VALUE}
  And User Submits Secondary Proposal Details  ${g_GENERIC_VALUE}
  And User Submits Multimedia Images
  And User Submits Milestone Details  ${s_MAX_FUNDING}  ${s_MAX_FUNDING}  ${g_GENERIC_VALUE}
  And User Submits Proposal Details
  Then User Should Be Redirected To "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "Idea" Tab
  And Proposal Status Should Be "IDEA"
  When Go To Newly Created Proposal View Page
  Then Proposal Details Should Be Correct On Proposal Details Page
  And Version Container Should Be Visible
