*** Settings ***
Documentation  This suite will test enabling new user to
...  interact to DigixDao with funds until redeeming of bage on profile page
Force Tags  regression  smoke
Default Tags  DaoCreateWalletRedeemBageTest
Suite Teardown    Run Keywords  Removed Created Json Wallet  AND  Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/common/eth_helper.robot
Resource  ../../resources/keywords/governance_page.robot
Resource  ../../resources/keywords/wallet_view_page.robot
Resource  ../../resources/keywords/profile_view_page.robot

*** Variable ***
${WALLET_NAME}  newWallet

*** Test Cases ***
User Has Successfully Created A New Wallet With Transferred Funds
  Create New Wallet File  ${WALLET_NAME}
  ${t_wallet_address}=  Get Wallet Address From Json  ${s_${WALLET_NAME}_JSON}
  Transfer Tokens To Account  ${t_wallet_address}  1000  MockDgd
  Transfer Tokens To Account  ${t_wallet_address}  1  MockBadge  badge

User Has Successfully Participated To DigixDao EcoSystem
  [Setup]  Launch Governance Website  Guest
  Given User Is In "GOVERNANCE" Page
  When "${WALLET_NAME}" Uploads "json" Wallet Account
  And User Approves DigixDao Interaction To Wallet
  Then Connect Wallet Overlay Should Be Visible
  When User Locks DGD Via Connect Wallet
  And Sleep  10 seconds
  And Go Back To Dashboard Page
  And User Signs Proof Of Control
  Then "LOGGED_IN" SideNav Menu Items Should Be Visible
  And User Should Successfully Be A Participant

User Has Successfully Redeemed Badge
  Given User Is In "GOVERNANCE" Page
  And Pull "${WALLET_NAME}" Data From Info Server
  When User Goes To "Profile" View Page
  And "${WALLET_NAME}" Approves Interaction To Contract
  Then User Should Successfully Interacted To Badge Contract
  When User Goes To "Profile" View Page
  And "${WALLET_NAME}" Redeems Badge
  Then Badge Should Be Successfully Redeemed
  When Go Back To Dashboard Page
  And User Goes To "Profile" View Page
  Then Redeem Badge Should Be Disabled

User Has Successfully Locked DGD on Wallet Page
  [Setup]  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Wallet" View Page
  And Pull "${WALLET_NAME}" Data From Info Server
  And User Locks DGD on "Wallet"
  And Go Back To Dashboard Page
  Then Locked DGD Value Should Increase

User Has Successfully Locked DGD on Header
  [Setup]  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When User Locks DGD on "Header"
  Then Locked DGD Value Should Increase

User Has Successfully Locked DGD on Moderator Card On Profile Page
  [Setup]  Go Back To Dashboard Page
  Given User Is In "GOVERNANCE" Page
  When User Goes To "Profile" View Page
  And User Locks DGD on "Profile"
  And Go Back To Dashboard Page
  Then Locked DGD Value Should Increase
