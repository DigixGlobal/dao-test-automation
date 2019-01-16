*** Settings ***
Documentation  This suite will test asserting values on Profile Overview are
...  correct and validate components are showing correcly based on user role
Force Tags  regression
Default Tags    DaoProfileOverviewTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot
Resource  ../../resources/keywords/profile_view_page.robot

*** Test Cases ***
Participant Has Successfully Validated Stats On Profile View Page
  [Setup]  "participant" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  And Pull Profile Stats Data
  When User Goes To "Profile" View Page
  Then Assert User Profile Values Are Correct
  And Gain Moderator Status Card Should Be Visible Based On Role

Moderator Has Successfully Validated Stats On Profile View Page
  [Setup]  "moderator" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  And Pull Profile Stats Data
  When User Goes To "Profile" View Page
  Then Assert User Profile Values Are Correct
  And Gain Moderator Status Card Should Be Visible Based On Role
