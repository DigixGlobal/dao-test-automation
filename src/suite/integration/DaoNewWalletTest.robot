*** Settings ***
Documentation  This suite will test enabling new user to
...  interact to DigixDao
Force Tags  regression  smoke
Default Tags    DaoNewWalletTest
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot

*** Test Cases ***
Test
  ${t_abi}=  Pull Data From Contract  MockDgd.json  abi
  Log  ${t_abi}
  ${t_networks}=  Pull Data From Contract  MockDgd.json  networks
  Log  ${t_networks}
  ${t_contract_addres}=  Latest Network Address  ${t_networks}
  Log  ${t_contract_addres}

  ${t_wallet_json}=  Create New Wallet  local
  Log  ${t_wallet_json}
  Create Json Wallet  ${t_wallet_json}
  ${cADD}=  Set Variable  0x36376d6e66f20a2f5377a91a5e6ce37b53dda0d8

  ${t_wallet_address}=  Get Value From Json  ${t_wallet_json}  /address
  ${t_asd}=  Remove String  ${t_wallet_address}  "
  ${t_setAddress}=  Set Variable  0x${t_asd}
  ${t_erc20}=  Load ERC20 Token  ${cADD}  ${t_abi}
  ${trax}=  Transfer Funds To Account  ${t_erc20}  ${t_setAddress}
