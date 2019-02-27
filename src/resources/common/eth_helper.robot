*** Settings ***
Library     ../custom/internal_json.py
Library     ../custom/internal_eth.py

*** Variables ***
${CONTRACT_PATH}  ${CURDIR}../../../../../dao-contracts/build/contracts/
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
  ${t_path}=  Normalize Path  ${CURDIR}/../testdata/keystores/${p_environment}/${p_user_type}.json
  ${t_content}=  Convert Json To String  ${t_wallet_json}
  Create File  ${t_path}  ${t_content}
  [Return]  ${t_wallet_json}

Get Wallet Address From Json
  [Arguments]  ${p_json_content}
  ${t_wallet_address}=  Get Value From Json  ${p_json_content}  /address
  ${t_asd}=  Remove String  ${t_wallet_address}  "
  ${t_setAddress}=  Set Variable  0x${t_asd}
  [Return]  ${t_setAddress}
