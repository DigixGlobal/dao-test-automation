*** Settings ***
Documentation  This suite will test end to end process of
...  creating proposals until marking proposal to complete
Force Tags    smoke    regression  disabled
Default Tags    DAOGovernanceETest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot

*** Test Cases ***
Proposer Has Successfully Created A Proposal
  [Setup]  "proposer" Account Has Successfully Locked DGD
  Given User Is In "GOVERNANCE" Page
  When "proposer" Creates A Governance Propsosal
  Then User Should Be Redirected To "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "Idea" Tab
  And Proposal Status Should Be "IDEA"

Moderator Has Successfully Endorsed Newly Created Proposal
  [Setup]  "moderator" Account Has Successfully Locked DGD
  Given User Is In "GOVERNANCE" Page
  When "moderator" "Endorses Proposal" On Newly Created Proposal
  Then User Should Be Able To Participate On Proposal
  And Proposal Status Should Be "DRAFT"

Participant Has Successfully Locked DGD
  [Setup]  "participant" Account Has Successfully Locked DGD
  Then User Should Be Redirected To "Governance" Page

Proposer Has Successfully Finalized Proposal
  [Setup]  Switch Browser  proposer
  Given User Is In "Governance" Page
  When "proposer" "finalizes Proposal" On Newly Created Proposal
  Then Proposal Status Should Be "DRAFT"

Moderator Has Successfully Approved Created Proposal
  [Setup]  Switch Browser  moderator
  Given User Is In "Governance" Page
  When "moderator" Approves Newly Drafted Proposal
  Then Proposal Status Should Be "DRAFT"

Proposer Has Successfully Claimed Approved Proposal
  [Setup]  Run Keywords  Sleep Until Timer Runs Out
  ...  AND  Switch Browser  proposer
  Given User Is In "Governance" Page
  When "porposer" "Claims Approved Proposal" On Newly Created Proposal
  Then Proposal Status Should Be "PROPOSAL"

Moderator Has Successfully Voted Yes On Proposal
  [Setup]  Switch Browser  moderator
  Given User Is In "Governance" Page
  When "moderator" Votes "Yes" On Proposal
  Then Vote Count Should Increase

Participant Has Successfully Voted No On Proposal
  [Setup]  Switch Browser  participant
  Given User Is In "Governance" Page
  When "participant" Votes "No" On Proposal
  Then Vote Count Should Increase

Proposer Has Successfully Voted Yes On Proposal
  [Setup]  Switch Browser  proposer
  Given User Is In "Governance" Page
  When "proposer" Votes "Yes" On Proposal
  Then Vote Count Should Increase

Moderator Has Successfully Revealed Vote To Proposal
  [Setup]  Run Keywords  Sleep Until Timer Runs Out  REVEAL
  ...  AND  Switch Browser  moderator
  Given User Is In "Governance" Page
  When "moderator" Reveals Vote Via Salt File
  Then Vote Count Should Increase

Participant Has Successfully Revealed Vote To Proposal
  [Setup]  Switch Browser  participant
  Given User Is In "Governance" Page
  When "participant" Reveals Vote Via Salt File
  Then Vote Count Should Increase

Proposer Has Successfully Revealed Vote To Proposal
  [Setup]  Switch Browser  proposer
  Given User Is In "Governance" Page
  When "proposer" Reveals Vote Via Salt File
  Then Vote Count Should Increase

Proposer Has Successfully Claimed Vote Result
  [Setup]  Sleep Until Timer Runs Out
  Given User Is In "Governance" Page
  When "porposer" "Claims Voting Result" On Newly Created Proposal
  Then Proposal Status Should Be "ONGOING"

Proposer Has Successfully Claimed Funding
  Given User Is In "Governance" Page
  When "proposer" "Claims Proposal Funding" On Newly Created Proposal
  Then Proposal Status Should Be "ONGOING"

Proposer Has Successfully Completed Milestone
  Given User Is In "Governance" Page
  When "proposer" "Sets Proposal To Complete" On Newly Created Proposal
  Then Proposal Status Should Be "REVIEW"

# Participant Has Successfully Voted For Completed Proposal

# Moderator Has Successfully Voted For Completed Proposal