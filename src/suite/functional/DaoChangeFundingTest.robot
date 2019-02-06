*** Settings ***
Documentation  This suite will test changing of funding then
...  go to the next phase after edit.
Force Tags  smoke  regression
Default Tags    DaoChangeFundingTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot

*** Variables ***
${NUMBER_OF_MILESTONE}  2

*** Test Cases ***
Proposer Has Successfully Created A Proposal
  [Setup]  "proposer" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  When "proposer" Creates A Governance Propsosal
  Then User Should Be Redirected To "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "Idea" Tab
  And Proposal Status Should Be "IDEA"

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

Proposer Has Successfully Edited funding
  Given User Is In "Governance" Page
  When User Edits Proposal Funding
  Then Funding Should be Changed

Proposer Has Successfully Claimed First Milestone Funding
  [Setup]  Go Back To Dashboard Page
  Given User Is In "Governance" Page
  When "proposer" "Claims Proposal Funding" On Newly Created Proposal
  Then Proposal Status Should Be "ONGOING"
