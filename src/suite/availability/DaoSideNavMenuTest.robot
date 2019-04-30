*** Settings ***
Documentation  This suite will test assert side nav menu list
...  when a user is in logged in and logged out state. (DGDG-284)
Force Tags  regression  smoke
Default Tags    DaoSideNavMenuTest
Suite Setup  Launch Governance Website  Guest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot

*** Test Cases ***
Guest User Has Successfully Visited Governance Page
  [Setup]  Launch Governance Website  Guest
  Given User Is In "GOVERNANCE" Page
  When Accept DigixDao Terms and Condition
  And Open SideNav Menu If Not Visible
  Then "LOGGED_OUT" SideNav Menu Items Should Be Visible
  [Teardown]  Close All Browsers

User Has Sucessfully Logged In To Governance Page
  [Setup]  Launch Governance Website  Guest
  Given User Is In "GOVERNANCE" Page
  When "${participant}" Submits "json" Wallet
  And Open SideNav Menu If Not Visible
  Then "LOGGED_IN" SideNav Menu Items Should Be Visible
