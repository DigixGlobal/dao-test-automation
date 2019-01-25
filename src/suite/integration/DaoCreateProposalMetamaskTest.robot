*** Settings ***
Documentation  This suite will test creating of proposal
...  using metamask as Entry Point
Force Tags  regression  sanity  NotForKOVAN
Default Tags    DaoCreateProposalMetamaskTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/metamask.robot
Resource  ../../resources/keywords/governance_page.robot

*** Test Cases ***
Proposer Has Successfully Created A Proposal
  [Setup]  "proposer" Account Has Successfully Logged In To DigixDao Using "metamask"
  Given User Is In "GOVERNANCE" Page
  When "proposer" Creates A Governance Propsosal
  Then User Should Be Redirected To "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "Idea" Tab
  And Proposal Status Should Be "IDEA"