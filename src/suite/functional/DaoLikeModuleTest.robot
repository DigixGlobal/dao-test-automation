*** Settings ***
Documentation  This suite will test like/unlike module for proposal and
...  comments
Force Tags    smoke    regression  disabled
Default Tags    DaoLikeModuleTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot
Resource  ../../resources/keywords/like_unlike_module.robot
Resource  ../../resources/keywords/comment_module.robot

*** Test Cases ***
Proposer Has Successfully Created A Proposal
  [Setup]  "proposer" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  When "proposer" Creates A Governance Propsosal
  Then User Should Be Redirected To "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "Idea" Tab
  And Proposal Status Should Be "IDEA"

Proposer Has Successfully Liked A Proposal
  Given User Is In "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "All" Tab
  When User "LIKES" Newly Created Proposal In "DASHBOARD" Page
  Then Proposoal Like Counter Should Be Correct In "DASHBOARD" Page
  When Go To Newly Created Proposal View Page
  Then Proposoal Like Counter Should Be Correct In "PROPOSAL_VIEW" Page

Proposer Has Successfully UnLiked A Proposal
  Given User Is In "PROPOSAL_VIEW" Page
  When User "UNLIKES" Newly Created Proposal In "PROPOSAL_VIEW" Page
  Then Proposoal Like Counter Should Be Correct In "PROPOSAL_VIEW" Page
  When Go Back To Dashboard Page
  Then Newly Created Proposal Should Be Visible On "All" Tab
  And Proposoal Like Counter Should Be Correct In "DASHBOARD" Page

Proposer Has Successfully Liked A Comment
  Given User Is In "GOVERNANCE" Page
  When "proposer" Posts "1" Thread On Created Proposal
  Then All Thread Comments Should Be Visible
  When User "LIKES" A Comment
  Then Comment Like Counter Should Be Correct
  When Go Back To Dashboard Page
  And Go To Newly Created Proposal View Page
  Then Comment Like Counter Should Be Correct  NoAction

Proposer Has Successfully Unliked A Comment
  [Setup]  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When Go To Newly Created Proposal View Page
  And User "UNLIKES" A Comment
  Then Comment Like Counter Should Be Correct
  When Go Back To Dashboard Page
  And Go To Newly Created Proposal View Page
  Then Comment Like Counter Should Be Correct  NoAction