*** Settings ***
Documentation  This suite will test commiting/revealing votes for
...  special proposals and quorum/quota values are correct
Force Tags  regression  smoke
Default Tags  DaoSpecialProposalTest
Suite Teardown  Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot

*** Test Cases ***
User Has Succesfully Voted On Special Proposal
  [Setup]  Run Keywords  Create Special Proposal
  ...  AND  "${proposer}" Account Has Successfully Logged In To DigixDao Using "${WALLET}"
  Given User Is In "Governance" Page
  When "${proposer}" Votes "Yes" On Proposal
  Then Vote Count Should Increase

User Has Successfully Revealed Vote To Proposal
  [Setup]  Sleep Until Timer Runs Out  REVEAL
  Given User Is In "Governance" Page
  And Pull Profile Stats Data
  When "${proposer}" Reveals Vote Via Salt File
  Then Quarter Points Should Increase
  When Go To Newly Created Proposal View Page
  Then Quorum Percentage Progress Bar Value Shoule Be Correct
