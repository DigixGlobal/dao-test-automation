*** Settings ***
Documentation  This suite will test locking of dgd for new json wallet users
...  and validating usd conversion are correct
Force Tags  regression  sanity  NotForKOVAN
Default Tags    DaoLockedDgdTest
# Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/common/eth_helper.robot
Resource  ../../resources/keywords/governance_page.robot

*** Test Cases ***
New User Has Successfully Approved Interaction to DigixDao
  [Setup]  Run Keywords  Create New Wallet With Funds
  ...  "newWallet" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  When User Approves Interaction TO DigixDao
  Then User Should Be Able To See Connected Wallet Overlay

New User Has Successfully Locked DGD Via Connected Wallet Overlay
  Given User Is In "GOVERNANCE" Page
  When User Locks DGD on "Connected_Wallet"


