*** Settings ***
Documentation  This suite will test redeeming badge on Profile View Page
Force Tags  regression  NotForKOVAN
Default Tags    DaoRedeemBadgeTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot
Resource  ../../resources/keywords/profile_view_page.robot

*** Test Cases ***
Badge Holder Has Successfully Redeemed Badge
  [Setup]  "badgeHolder" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  And Pull "badgeHolder" Data From Info Server
  When User Goes To "Profile" View Page
  When "badgeHolder" Marks Himself As Participant
  And "badgeHolder" Redeems Badge
  Then Badge Should Be Successfully Redeemed

Redeemed Badge User Has Successfully Visited Profile Page
  [Setup]  "badgeHolder" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Profile" View Page
  Then Badge Has Already Been Redeemed

NonBadge Holder Has Successfully Visited Profile Page
  [Setup]  "nonBadgeHolder" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Profile" View Page
  When "nonBadgeHolder" Marks Himself As Participant
  Then Redeem Badge Should Be Disabled