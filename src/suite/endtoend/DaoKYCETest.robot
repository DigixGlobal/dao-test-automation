*** Settings ***
Documentation  This suite will test end to end process from submitting user's KYC Details
...  up to rejecting and approving it using KYC Officer account
Force Tags    smoke    regression    endtoend
Default Tags    DaoKYCETest  notForKovan
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot
Resource  ../../resources/keywords/create_edit_proposal_page.robot
Resource  ../../resources/keywords/profile_view_page.robot
Resource  ../../resources/keywords/kyc_submission_module.robot
Resource  ../../resources/keywords/kyc_admin_page.robot

*** Variables ***
${address_name}  proposer

*** Test Cases ***
NonKycUser Has Sucessfully Viewed Error Overlay When Creating Proposal
  [Setup]  Run keywords  "${address_name}" Account Has Successfully Logged In To DigixDao Using "${WALLET}"
  ...  Generate Suite Unique Value
  Given User Is In "GOVERNANCE" Page
  When "${address_name}" Ticks Create Button On Dashboard Page
  Then Error Overlay Should "BE" Visible
  When User Closes Error Overlay
  Then Error Overlay Should "NOT BE" Visible

NonKycUser Has Successfully Submitted KYC Details On Profile Page
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Profile" View Page
  And User Submits KYC Details For Approval  ${s_UNIQUE}
  Then Kyc Status Should Be "Pending"

NonKycUser Has Successfully Viewed Error Overlay When KYC Status Is Pending
  [Setup]  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When "${address_name}" Ticks Create Button On Dashboard Page
  Then Error Overlay Should "BE" Visible
  When User Closes Error Overlay
  Then Error Overlay Should "NOT BE" Visible
  When User Goes To "Profile" View Page
  Then Kyc Status Should Be "Pending"

KYCOfficer Has Successfully Rejected KYC Account
  [Setup]  "kycOfficer" Account Has Successfully Logged In To DigixDao Using "${WALLET}"
  Given User Is In "GOVERNANCE" Page
  And KycOfficer Is Logged In
  When User Goes To "KYC_DASHBOARD" View Page
  And User "Rejects" "${s_UNIQUE}" Account
  Then Account Status Should Be "REJECTED"

NonKycUser Has Successfully Viewed Error Overlay When KYC Status Is Rejected
  [Setup]  Run Keywords  Switch Browser  ${address_name}
  ...  AND  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When "${address_name}" Ticks Create Button On Dashboard Page
  Then Error Overlay Should "BE" Visible
  When User Closes Error Overlay
  Then Error Overlay Should "NOT BE" Visible

NonKycUser Has Successfully Resubmitted KYC Details On Profile Page
  [Setup]  Generate Suite Unique Value
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
  And Sleep  30 seconds
  Then Account Status Should Be "APPROVED"

NonKycUser Has Successfully Set KYC Status To Approved
  [Setup]  Switch Browser  ${address_name}
  Given User Is In "PROFILE" Page
  Then Kyc Status Should Be "Approved"

NonKycUser Has Successfully Created A Proposal
  [Setup]  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When "${address_name}" Creates A Governance Propsosal
  Then User Should Be Redirected To "GOVERNANCE" Page
  And Newly Created Proposal Should Be Visible On "Idea" Tab
  And Proposal Status Should Be "IDEA"
