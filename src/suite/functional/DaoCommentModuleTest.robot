*** Settings ***
Documentation    This suite will test end to end process of
...  creation of order up to minting
Force Tags    smoke    regression  disabled
Default Tags    DaoCommentModuleTest
# Suite Teardown    Close All Browsers
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
  When "participant" Posts Multiple Replies To Thread "0"
  # When "participant" Posts Nested Replies To Thread "1"

