*** Settings ***
Documentation  This suite will test redeeming badge on Profile View Page
Force Tags  regression  sanity  NotForKOVAN
Default Tags    DaoRedeemBadgeTest
Suite Teardown  Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot
Resource  ../../resources/keywords/profile_view_page.robot

*** Test Cases ***
Badge Holder On Contract Has Successfully Redeemed Badge
  [Setup]  "badgeHolder" Account Has Successfully Logged In To DigixDao Using "${WALLET}"
  Given User Is In "GOVERNANCE" Page
  And Pull "badgeHolder" Data From Info Server
  When User Goes To "Profile" View Page
  And "badgeHolder" Marks Himself As Participant
  And "badgeHolder" Redeems Badge
  Then Badge Should Be Successfully Redeemed
  When Go Back To Dashboard Page
  And User Goes To "Profile" View Page
  Then Gain Moderator Card Should Not Be Visible
  And Gain Moderator Status Card Should Be Visible Based On Role

Badge Holder Not On Contract Has Successfully Redeemed Badge
  [Setup]  "badgeHolderNotOnContract" Account Has Successfully Logged In To DigixDao Using "${WALLET}"
  Given User Is In "GOVERNANCE" Page
  And Pull "badgeHolderNotOnContract" Data From Info Server
  When User Goes To "Profile" View Page
  And "badgeHolderNotOnContract" Approves Interaction To Contract
  Then User Should Successfully Interacted To Badge Contract
  When User Goes To "Profile" View Page
  And "badgeHolderNotOnContract" Redeems Badge
  Then Badge Should Be Successfully Redeemed
  When Go Back To Dashboard Page
  And User Goes To "Profile" View Page
  Then Redeem Badge Should Be Disabled

NonBadge Holder Has Successfully Visited Profile Page
  [Setup]  "nonBadgeHolder" Account Has Successfully Logged In To DigixDao Using "${WALLET}"
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Profile" View Page
  When "nonBadgeHolder" Marks Himself As Participant
  Then Redeem Badge Should Be Disabled
