*** Settings ***
Documentation  This suite will test claiming rewards on Wallet Page
Force Tags  regression  sanity  NotForKOVAN
Default Tags    DaoClaimRewardTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot
Resource  ../../resources/keywords/wallet_view_page.robot

*** Test Cases ***
User Has Successfully Claimed Rewards On Wallet Page
  [Setup]  "rewardee" Account Has Successfully Logged In To DigixDao Using "${WALLET}"
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Wallet" View Page
  And "rewardee" Claims Reward
  Then User Should Be Successfully Claimed Reward
  And Claim Reward Value Should Be Zero

Claimed Reward User Has Successfully Visited Wallet Page
  [Setup]  "rewardee" Account Has Successfully Logged In To DigixDao Using "${WALLET}"
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Wallet" View Page
  Then User Should Already Claimed Reward

User Has Successfully Viewed DGD,DGX, And Eth Usd Conversion
  [Setup]  Go Back To Dashboard Page
  Given Given User Is In "GOVERNANCE" Page
  When User Goes To "Wallet" View Page
  Then User Should Successfully Viewed Token USD Conversion
