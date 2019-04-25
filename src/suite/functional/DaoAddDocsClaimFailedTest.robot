*** Settings ***
Documentation  This suite will test adding of additional documents after
...  project status is finalized and claiming it as failed project
Force Tags    smoke    regression
Default Tags    DaoAddDocsClaimFailedTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot

*** Variables ***
${NUMBER_OF_MILESTONE}  1

*** Test Cases ***
Proposer Has Successfully Created A Proposal
  [Setup]  "proposer" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  When "proposer" Creates A Governance Propsosal
  Then User Should Be Redirected To "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "Idea" Tab
  And Proposal Status Should Be "IDEA"
  And Project Creator Name Should Be Visible

Moderator Has Successfully Endorsed Newly Created Proposal
  [Setup]  "moderator" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  When "moderator" "Endorses Proposal" On Newly Created Proposal
  Then User Should Be Able To Participate On Proposal
  And Proposal Status Should Be "DRAFT"

Proposer Has Successfully Finalized Proposal
  [Setup]  Switch Browser  proposer
  Given User Is In "Governance" Page
  When "proposer" "finalizes Proposal" On Newly Created Proposal
  Then Proposal Status Should Be "DRAFT"

Proposer Has Successfully Added Additional Documents For Proposal
  Given User Is In "Governance" Page
  When User Adds Additional Documents
  And User Revisits Newly Created Proposal
  Then Additional Document Section Should Be Visible

Proposer Has Successfully Claimed Failed Project
  [Setup]  Run Keywords  Sleep Until Timer Runs Out
  ...  AND  Go Back To Dashboard Page
  Given User Is In "Governance" Page
  When User Claims Failed Project
  Then Project Details Page Status Should Be "ARCHIVED"
  When Go Back To Dashboard Page
  Then Proposal Status Should Be "ARCHIVED"
