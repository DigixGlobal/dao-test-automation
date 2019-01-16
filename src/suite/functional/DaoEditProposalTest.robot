*** Settings ***
Documentation  This suite will test editing of proposal
...  and validate the edited details on Proposal View Page
Force Tags    sanity  regression
Default Tags    DaoEditProposalTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot

*** Test Cases ***
Proposer Has Successfully Created A Proposal
  [Setup]  "proposer" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  When "proposer" Creates A Governance Propsosal
  Then User Should Be Redirected To "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "Idea" Tab
  And Proposal Status Should Be "IDEA"
  And Proposal Details Should Be Correct On Proposal Details Page

Proposer Has Successfully Edited Created Proposal
  [Setup]  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When Go To Newly Created Proposal View Page
  And "proposer" Edits Newly Created Proposal Details
  Then Newly Created Proposal Should Be Visible On "All" Tab
  And Proposal Details Should Be Correct On Proposal Details Page
