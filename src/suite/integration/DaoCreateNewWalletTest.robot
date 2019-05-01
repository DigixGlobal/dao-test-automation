*** Settings ***
Documentation  This suite will test enabling new user to
...  interact to DigixDao with funds via web3 wallet creation
Force Tags  regression  smoke
Default Tags    DaoCreateNewWalletTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/common/eth_helper.robot
Resource  ../../resources/keywords/governance_page.robot

*** Variable ***
${WALLET_NAME}  newWallet

*** Test Cases ***
User Has Successfully Created A New Wallet With Transferred Funds
  Create New Wallet File  ${WALLET_NAME}
  ${t_wallet_address}=  Get Wallet Address From Json  ${s_${WALLET_NAME}_JSON}
  Transfer Tokens To Account  ${t_wallet_address}  1000  MockDgd
  Transfer Tokens To Account  ${t_wallet_address}  1  MockBadge  badge
  Removed Created Json Wallet
