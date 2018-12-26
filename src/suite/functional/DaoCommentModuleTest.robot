*** Settings ***
Documentation    This suite will test end to end process of
...  creation of order up to minting
Force Tags    smoke    regression  disabled
Default Tags    DaoCommentModuleTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot
Resource  ../../resources/keywords/comment_module.robot

*** Test Cases ***
Proposer Has Successfully Created A Proposal
  [Setup]  "participant" Account Has Successfully Locked DGD
  Given User Is In "GOVERNANCE" Page
  When "participant" Creates A Governance Propsosal
  Then User Should Be Redirected To "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "Idea" Tab
  And Proposal Status Should Be "IDEA"

Participant Has Successfully Posted Multiple Threads
  Given User Is In "GOVERNANCE" Page
  When "participant" Posts Multiple Thread On Created Proposal
  Then All Thread Comments Should Be Visible

Participant Has Successfully Posted Multiple Comments
  Given User Is In "PROPOSAL_VIEW" Page
  WHEN "participant" Posts Multiple "REPLIES" To Thread "10"
  Then All Comments Should Be Visible

Participant Has Successfully Posted Multiple Nested Comments
  Given User Is In "PROPOSAL_VIEW" Page
  WHEN "participant" Posts Multiple "NESTED_REPLIES" To Thread "9"
  Then All Comments Should Be Visible

# Participant Has Successfully Showed All Comments
#   [Setup]  Run Keywords  User Goes Back To Goverance Dashboard
#   ...  AND  Go To Newly Created Proposal View Page
#   Given User Is In "PROPOSAL_VIEW" Page
#   When User Shows All Main Thread Comments
#   Then All Main Thread Comments Should Be Visible
#   When User Shows All Reply Comments
#   Then All Replies Comments Should Be Visible
#   When User Shows All Nested Comments
#   Then All Nested Comments Should Be Visible

# Participant Has Successfully Deleted A Comment

# Participant Has Successfully Liked A Comment

# Participant Has Successfully Sorted Thread