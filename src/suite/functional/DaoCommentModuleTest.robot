*** Settings ***
Documentation  This suite will test end to end process of
...  posting comments on newly created proposal
Force Tags  smoke  regression
Default Tags   DaoCommentModuleTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot
Resource  ../../resources/keywords/comment_module.robot

*** Test Cases ***
Proposer Has Successfully Created A Proposal
  [Setup]  "proposer" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  When "proposer" Creates A Governance Propsosal
  Then User Should Be Redirected To "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "Idea" Tab
  And Proposal Status Should Be "IDEA"

Proposer Has Successfully Posted Multiple Threads
  Given User Is In "GOVERNANCE" Page
  When "proposer" Posts "11" Thread On Created Proposal
  Then All Thread Comments Should Be Visible

Proposer Has Successfully Sorted Main Thread From Oldest
  Given User Is In "PROPOSAL_VIEW" Page
  When "proposer" Sorts Main Thread From "Oldest"
  And "proposer" Sorts Main Thread From "Latest"
  Then Main Thread Should Be Sorted

Proposer Has Successfully Posted Multiple Comments
  Given User Is In "PROPOSAL_VIEW" Page
  When "proposer" Posts Multiple "REPLIES" To Thread "1"
  Then All Comments Should Be Visible

Proposer Has Successfully Posted Multiple Nested Comments
  Given User Is In "PROPOSAL_VIEW" Page
  When "proposer" Posts Multiple "NESTED_REPLIES" To Thread "2"
  Then All Comments Should Be Visible

Proposer Has Successfully Showed All Comments
  [Setup]  User Revisits Newly Created Proposal
  Given User Is In "PROPOSAL_VIEW" Page
  When "proposer" Sorts Main Thread From "Oldest"
  Then Main Thread Should Be Sorted
  When User Shows All Main Thread Comments
  Then All Thread Comments Should Be Visible
  When "proposer" Sorts Main Thread From "Latest"
  Then Main Thread Should Be Sorted
  When User Shows All "REPLIES" Comments
  Then All Comments Should Be Visible
  When User Shows All "NESTED_REPLIES" Comments
  Then All Comments Should Be Visible

Proposer Has Successfully Deleted A Comment
  Given User Is In "PROPOSAL_VIEW" Page
  When "proposer" Deletes Main Thread "0"
  Then Main Thread "0" Messages Should Be Empty
