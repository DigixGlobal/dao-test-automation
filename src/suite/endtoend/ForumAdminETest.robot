*** Settings ***
Documentation  This suite will test end to end process of
...  posting comments on newly created proposal and hide/unhide commit via forumAdmin Account
Force Tags  smoke  regression
Default Tags   ForumAdminETest
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

Proposer Has Successfully Posted Multiple ThreadsA And Sorted To Oldest
  Given User Is In "GOVERNANCE" Page
  When "proposer" Posts "2" Thread On Created Proposal
  And "proposer" Sorts Main Thread From "Oldest"
  Then All Thread Comments Should Be Visible

ForumAdmin Has Successfully Remove A Comment
  [Setup]  "forumAdmin" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  When Go To Newly Created Proposal View Page
  And ForumAdmin "Removes" Thread "0"
  Then Thread "0" Button Should Be "Restore"

Proposer Has Successfully Viewed Removed Commment
  [Setup]  Run Keywords  Switch Browser  proposer
  ...  AND  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When Go To Newly Created Proposal View Page
  Then Thread "0" Should Be "Remove"

ForumAdmin Has Successfully Restore A Comment
  [Setup]  Run Keywords  Switch Browser  forumAdmin
  ...  AND  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When Go To Newly Created Proposal View Page
  And ForumAdmin "Restores" Thread "0"
  Then Thread "0" Button Should Be "Remove"

Proposer Has Successfully Viewed Restored Comment
  [Setup]  Run Keywords  Switch Browser  proposer
  ...  AND  Go Back To Dashboard Page
  ...  AND  Pull "proposer" From SideNav
  Given User Is In "GOVERNANCE" Page
  When Go To Newly Created Proposal View Page
  Then Thread "0" Should Be "Restore"

ForumAdmin Has Successfully Banned A User For Commenting
  [Setup]  Run Keywords  Switch Browser  forumAdmin
  ...  AND  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Admin" View Page
  And Admin "BANS" "${PROPOSER_USERNAME}" From Commenting
  Then Ban Button Label Should Be "UNBAN"

Proposer Has Not Successfully Posted A Comment Due to Banned
  [Setup]  Run Keywords  Switch Browser  proposer
  ...  AND  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When Go To Newly Created Proposal View Page
  Then User Should "NOT BE" Able To Post A Comment

ForumAdming Has Successfully UnBanned A User For Commenting
  [Setup]  Run Keywords  Switch Browser  forumAdmin
  ...  AND  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Admin" View Page
  And Admin "UNBANS" "${PROPOSER_USERNAME}" From Commenting
  Then Ban Button Label Should Be "BAN"

Proposer Has Successfully Posted A New Comment
  [Setup]  Run Keywords  Switch Browser  proposer
  ...  AND  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When Go To Newly Created Proposal View Page
  Then User Should "BE" Able To Post A Comment
  When Go Back To Dashboard Page
  And "proposer" Posts "1" Thread On Created Proposal
