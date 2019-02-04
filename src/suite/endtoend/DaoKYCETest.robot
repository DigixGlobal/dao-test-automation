*** Settings ***
Documentation  This suite will test end to end process from submitting user's KYC Details
...  up to rejecting and approving it using KYC Officer account
Force Tags    smoke    regression    endtoend
Default Tags    DaoKYCETest  notForKovan
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot
Resource  ../../resources/keywords/profile_view_page.robot
Resource  ../../resources/keywords/kyc_submission_module.robot
Resource  ../../resources/keywords/kyc_admin_page.robot

*** Test Cases ***
NonKycUser Has Successfully Submitted KYC Details On Profile Page
  [Setup]  Run keywords  "nonKYCUser" Account Has Successfully Logged In To DigixDao Using "json"
  ...  Generate Suite Unique Value
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Profile" View Page
  And User Submits KYC Details For Approval  ${s_UNIQUE}
  Then Kyc Status Should Be "Pending"

KYCOfficer Has Successfully Rejected KYC Account
  [Setup]  "kycOfficer" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  And KycOfficer Is Logged In
  When User Goes To "KYC_DASHBOARD" View Page
  And User "Rejects" "${s_UNIQUE}" Account
  Then Account Status Should Be "REJECTED"

NonKycUser Has Successfully Resubmitted KYC Details On Profile Page
  [Setup]  Run Keywords  Switch Browser  nonKYCUser
  ...  AND  Go Back To Dashboard Page
  ...  AND  Generate Suite Unique Value
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Profile" View Page
  Then Kyc Status Should Be "Rejected"
  When User Submits KYC Details For Approval  ${s_UNIQUE}
  Then Kyc Status Should Be "Pending"

KYCOfficer Has Successfully Approved KYC Account
  [Setup]  Run Keywords  Switch Browser  kycOfficer
  ...  AND  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When User Goes To "KYC_DASHBOARD" View Page
  And User "Approves" "${s_UNIQUE}" Account
  Then Account Status Should Be "APPROVED"

NonKycUser Has Successfully Set KYC Status To Approved
  [Setup]  Run Keywords  Switch Browser  nonKYCUser
  ...  AND  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Profile" View Page
  Then Kyc Status Should Be "Approved"
