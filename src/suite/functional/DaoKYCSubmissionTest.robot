*** Settings ***
Documentation  This suite will submitting of KYC Details for nonKYC user.
Force Tags  smoke  regression
Default Tags   DaoKYCSubmissionTest
Suite Setup  Generate Suite Unique Value
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot
Resource  ../../resources/keywords/profile_view_page.robot
Resource  ../../resources/keywords/kyc_submission_module.robot

*** Test Cases ***
NonKycUser Has Successfully Assigned Email Address On Profile Page
  [Setup]  "nonKYCUser" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Profile" View Page
  And User Sets Account Details By Component
  ...  email  ${s_UNIQUE}@a.co  valid

NonKycUser Has Successfully Submitted KYC Details On Profile Page
  [Setup]  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Profile" View Page
  And User Submits KYC Details For Approval  ${s_UNIQUE}
  Then Kyc Status Should Be "Pending"
