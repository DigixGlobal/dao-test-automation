*** Settings ***
Documentation  This suite will test assert side nav menu list
...  when a user is in logged in and logged out state. (DGDG-284)
Force Tags   sanity  regression
Default Tags    DaoSideNavMenuTest
Suite Setup  "Guest" Launch Governance Page
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot

*** Test Cases ***
Guest User Has Successfully Visited Governance Page
  Given User Is In "GOVERNANCE" Page
  Then "LOGGED_OUT" SideNav Menu Items Should Be Visible

User Has Sucessfully Logged In To Governance Page
  Given User Is In "GOVERNANCE" Page
  When "participant" Submits "json" Wallet
  Then "LOGGED_IN" SideNav Menu Items Should Be Visible
