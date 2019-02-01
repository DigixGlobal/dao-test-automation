*** Settings ***
Documentation  This suite will test locking and unlocking DGD at Wallet Page
...  on locking phase.
Force Tags  regression  sanity  NotForKOVAN
Default Tags    DAOUnlockDGDTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot
Resource  ../../resources/keywords/wallet_view_page.robot

*** Test Cases ***
User Has Successfully Added Locked DGD On Wallet Page
  [Setup]  "rewardee" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Wallet" View Page
  Then "WALLET_PAGE" Elements Should Be Visible
  And Pulled Wallet Stats
  When "rewardee" Locks "10" DGD on Wallet Page
  Then User Should Successfully "LOCKED" DGD
  And Go Back To Dashboard Page
  And User Goes To "Wallet" View Page
  Then "LOCKED" DGD Computation Should Be Correct

User Has Successfully Unlocked Portion Of User Staked
  [Setup]  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Wallet" View Page
  And "proposer" unlocks "5" Stake On "Locking Phase"
  Then User Should Successfully "UNLOCKED" DGD
  When Go Back To Dashboard Page
  And User Goes To "Wallet" View Page
  Then "UNLOCKED" DGD Computation Should Be Correct

User Has Successfully Locked Whole User Stake
  [Setup]  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Wallet" View Page
  And "proposer" Unlocks "MAX" Stake On "Locking Phase"
  Then User Should Successfully "UNLOCKED" DGD
  Then User Should Not Be Able To Unlocked DGD
  When Go Back To Dashboard Page
  And User Goes To "Wallet" View Page
  Then "UNLOCKED" DGD Computation Should Be Correct
