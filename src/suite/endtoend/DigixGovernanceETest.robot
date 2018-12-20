*** Settings ***
Documentation    This suite will test end to end process of
...  creation of order up to minting
Force Tags    smoke    regression  disabled
Default Tags    DigixGovernanceETest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot

*** Test Cases ***
Participant Has Successfully Created A Proposal
  [Setup]  "participant" Account Has Successfully Locked DGD
  Given User Is In "GOVERNANCE" Page
  When "participant" Creates A Governance Propsosal
  Then User Should Be Redirected To "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "Idea" Tab
  And Proposal Status Should Be "IDEA"

Moderator Has Successfully Endorsed Newly Created Proposal
  [Setup]  "moderator" Account Has Successfully Locked DGD
  Given User Is In "GOVERNANCE" Page
  When "moderator" Endorses Newly Created Proposal
  Then User Should Be Able To Participate On Proposal
  And Proposal Status Should Be "DRAFT"

Participant Has Successfully Finalized Proposal
  [Setup]  Switch Browser  participant
  Given User Is In "Governance" Page
  When "participant" Finalizes Created Proposal
  Then Proposal Status Should Be "DRAFT"

Moderator Has Successfully Approved Created Proposal
  [Setup]  Switch Browser  moderator
  Given User Is In "Governance" Page
  When "moderator" Approves Newly Drafted Proposal
  Then Proposal Status Should Be "DRAFT"

Participant Has Successfully Claimed Approved Proposal
  [Setup]  Run Keywords  Sleep Until Timer Runs Out
  ...  AND  Switch Browser  participant
  Given User Is In "Governance" Page
  When "particpant" Claims Approved Proposal
  Then Proposal Status Should Be "PROPOSAL"

Moderator Has Successfully Voted On Proposal
  [Setup]  Switch Browser  moderator
  Given User Is In "Governance" Page
  When "moderator" Votes "Yes" On Proposal
  Then Vote Count Should Increase

Participant Has Successfully Voted On Proposal
  [Setup]  Switch Browser  participant
  Given User Is In "Governance" Page
  When "participant" Votes "Yes" On Proposal
  Then Vote Count Should Increase

Moderator Has Successfully Revealed Vote To Proposal
  [Setup]  Run Keywords  Sleep Until Timer Runs Out  REVEAL
  ...  AND  Switch Browser  moderator
  ...  AND  Hide SnackBar
  Given User Is In "Governance" Page
  When "moderator" Reveals Vote Via Salt File
  Then Vote Count Should Increase

Participant Has Successfully Revealed Vote To Proposal
  [Setup]  Run Keywords  Switch Browser  participant
  ...  AND  Hide SnackBar
  Given User Is In "Governance" Page
  When "participant" Reveals Vote Via Salt File
  Then Vote Count Should Increase

Participant Has Successfully Claimed Vote Result
  [Setup]  Run Keywords  Sleep Until Timer Runs Out
  ...  AND  Switch Browser  participant
  ...  AND  Hide SnackBar
  Given User Is In "Governance" Page
  When "particpant" Claims Voting Result
  Then Proposal Status Should Be "ONGOING"

Participant Has Successfully Claimed Funding
  [Setup]  Run Keywords  Switch Browser  participant
  ...  AND  Hide SnackBar
  Given User Is In "Governance" Page
  When "particpant" Claims Proposal Funding
  Then Proposal Status Should Be "ONGOING"

Participant Has Successfully Completed Milestone
  [Setup]  Switch Browser  participant
  Given User Is In "Governance" Page
  When "particpant" Sets Proposal To Commplete
  Then Proposal Status Should Be "REVIEW"

# Participant Has Successfully Voted For Completed Proposal

# Moderator Has Successfully Voted For Completed Proposal