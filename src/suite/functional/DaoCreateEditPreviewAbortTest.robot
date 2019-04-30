*** Settings ***
Documentation  This suite will test creating,and editing proposals
...  also included preview function and aborting of project.
Force Tags    smoke    regression
Default Tags    DaoCreateEditPreviewAbortTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot

*** Variables ***
${address}  proposer
${wallet}  json

*** Test Cases ***
Proposer Has Successfully Created A Proposal While Preview Each Steps
  [Setup]  Run Keywords  Set Proposal Value  create
  ...  AND  "${address}" Account Has Successfully Logged In To DigixDao Using "${wallet}"
  Given User Is In "GOVERNANCE" Page
  When User Goes To Create Proposal Page
  # primary details
  And User Submits Primary Proposal Details  ${g_GENERIC_VALUE}  ${g_GENERIC_VALUE}
  And User Previews Details
  Then Proposal Preview Should Be Visible
  # secondary details
  When User Goes Back To Previous Page
  And User Submits Secondary Proposal Details  ${g_GENERIC_VALUE}
  And User Previews Details
  Then Proposal Preview Should Be Visible
  #multimedia
  When User Goes Back To Previous Page
  And User Submits Multimedia Images
  And User Previews Details
  Then Proposal Preview Should Be Visible
  #milestone
  When User Goes Back To Previous Page
  And User Submits Milestone Details  3  4  ${g_GENERIC_VALUE}
  And User Submits Proposal Details
  Then User Should Be Redirected To "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "Idea" Tab
  And Proposal Status Should Be "IDEA"
  When Go To Newly Created Proposal View Page
  And Proposal Details Should Be Correct On Proposal Details Page

Proposer Has Successfully Edited A Proposal While Preview Each Steps
  [Setup]  Set Proposal Value  edit
  Given User Is In "PROPOSAL_VIEW" Page
  When User Edits Proposal Details
  # primary details
  And User Submits Primary Proposal Details  ${g_GENERIC_VALUE}  ${g_GENERIC_VALUE}
  And User Previews Details
  Then Proposal Preview Should Be Visible
  # secondary details
  When User Goes Back To Previous Page
  And User Submits Secondary Proposal Details  ${g_GENERIC_VALUE}
  And User Previews Details
  Then Proposal Preview Should Be Visible
  #multimedia
  When User Goes Back To Previous Page
  And User Submits Multimedia Images
  And User Previews Details
  Then Proposal Preview Should Be Visible
  #milestone
  When User Goes Back To Previous Page
  And User Submits Milestone Details  5  6  ${g_GENERIC_VALUE}
  And User Submits Proposal Details
  Then User Should Be Redirected To "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "Idea" Tab
  And Proposal Status Should Be "IDEA"
  When Go To Newly Created Proposal View Page
  And Proposal Details Should Be Correct On Proposal Details Page
  And Version Container Should Be Visible

Proposer Has Successfully Validated Version Data Are Correct
  [Setup]  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When Go To Newly Created Proposal View Page
  Then Proposal Details Should Be Correct On Proposal Details Page
  When User Go Back To Previous Version
  Then Proposal Details Should Be Correct On Proposal Details Page  create

Proposer Has Successfully Aborted Newly Created Project
  [Setup]  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When User Aborts The Project
  And User Revisits Newly Created Proposal
  Then Project Details Page Status Should Be "ARCHIVED"
  When Go Back To Dashboard Page
  Then Newly Created Proposal Should Be Visible On "All" Tab
  And Newly Created Proposal Should Be Visible On "Archived" Tab
  Then Then Proposal Status Should Be "ARCHIVED"
