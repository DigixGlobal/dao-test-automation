*** Settings ***
Documentation  This suite will test approving and rejecting KYC using KYC Admin Account
...  NOTE: Run `bundle exec rake dao:seed_pending_kycs` if test data is less than 2
Force Tags  regression  smoke
Default Tags    DaoKYCAdminTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot
Resource  ../../resources/keywords/kyc_admin_page.robot

*** Test Cases ***
KYCOfficer Has Successfully Approved KYC Account
  [Setup]  "kycOfficer" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  And KycOfficer Is Logged In
  When User Goes To "KYC_DASHBOARD" View Page
  And User "Approves" "ANY" Account
  Then Account Status Should Be "APPROVED"

KYCOfficer Has Successfully Rejected KYC Account
  Given User Is In "KYC_ADMIN" Page
  When User "Rejects" "ANY" Account
  Then Account Status Should Be "REJECTED"

NonOfficer Has Successfully Visited KycAdmin Via Force URL
  [Setup]  "moderator" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  When User Forcely Goes To KYC Dashboard Page
  Then User Should Be Able To Visit KYC Dashboard
