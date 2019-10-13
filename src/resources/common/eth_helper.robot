*** Settings ***
Library     ../custom/internal_json.py
Library     ../custom/internal_eth.py

*** Variables ***
${CONTRACT_PATH}  ${CURDIR}../../../../../dao-contracts/build/contracts/
${TESTDATA_PATH}  /../testdata/keystores/
*** Keywords ***
Pull Data From Contract
  [Arguments]  ${p_contractName}  ${p_lookUp}
  ${t_content}=  Normalize Path  ${CONTRACT_PATH}/${p_contractName}
  ${t_value}=  Find Value On Json File  ${t_content}  /${p_lookUp}
  [Return]  ${t_value}

Pull Latest Contract Address
  [Arguments]  ${p_contractName}  ${p_lookUp}
  ${t_networks}=  Pull Data From Contract  ${p_contractName}  ${p_lookUp}
  ${t_contract_address}=  Latest Network Address  ${t_networks}
  [Return]  ${t_contract_address}

Create New Wallet File
  [Arguments]  ${p_user_type}  ${p_environment}=LOCAL
  ${t_wallet_json}=  Create New Wallet Via Web3  ${p_environment}
  ${t_path}=  Normalize Path  ${CURDIR}${TESTDATA_PATH}${p_environment}/${p_user_type}.json
  ${t_content}=  Convert Json To String  ${t_wallet_json}
  Create File  ${t_path}  ${t_content}
  Set Suite Variable  ${s_${p_user_type}_JSON}  ${t_wallet_json}
  Set Suite Variable  ${s_NEW_WALLET_FILENAME}  ${p_user_type}

Get Wallet Address From Json
  [Arguments]  ${p_json_content}
  ${t_wallet_address}=  Get Value From Json  ${p_json_content}  /address
  ${t_asd}=  Remove String  ${t_wallet_address}  "
  ${t_setAddress}=  Set Variable  0x${t_asd}
  [Return]  ${t_setAddress}

Transfer Tokens To Account
  [Arguments]  ${p_address}  ${t_value}  ${p_contract}  ${p_token_type}=funds
  ${t_contract_address}=  Pull Latest Contract Address  ${p_contract}.json  networks
  ${t_abi}=  Pull Data From Contract  ${p_contract}.json  abi
  ${t_erc20}=  Load ERC20 Token  ${t_contract_address}  ${t_abi}
  ${t_content}=  Transfer To Account  ${t_erc20}  ${p_address}  ${p_token_type}  ${t_value}

Removed Created Json Wallet
  [Arguments]  ${p_user_type}=${s_NEW_WALLET_FILENAME}  ${p_environment}=LOCAL
  ${t_path}=  Normalize Path  ${CURDIR}${TESTDATA_PATH}${p_environment}/${p_user_type}.json
  Remove File  ${t_path}
