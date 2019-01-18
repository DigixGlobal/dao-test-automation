*** Settings ***
Resource  ../variables/wallet_view_contants.robot

*** Keywords ***
"${e_USER}" Claims Reward
  Wait Until Element Should Be Visible  ${WALLET_ADDRESS_DIV}
  ${t_address}=  Get Text  ${WALLET_ADDRESS_DIV}
  ${t_claimValue}=  LookUp Value On Info Server  ${t_address}  /result/claimableDgx
  ${t_zero}=  Evaluate  ${t_claimValue} == 0
  Run Keyword If  ${t_zero}  Run Keywords
  ...  Log To Console  ${\n}Please run `npm run teleport:next_quarter` on `dao-contracts`
  ...  AND  Log To Console  ${\n}then Restart info-server
  ...  AND  Fail  msg=Please run command on dao-contracts and restart info-server
  ...  ELSE  Run Keywords
  ...  Wait And Click Element  ${WALLET_CLAIM_REWARD_BTN}
  ...  AND  User Submits Keystore Password  #transaction modal

User Should Be Successfully Claimed Reward
  Wait Until Element Should Be Visible  ${WALLET_REWARD_AMOUNT}
  Wait Until Element Should Contain  ${WALLET_REWARD_AMOUNT}  0
  Wait Until Element Is Disabled  ${WALLET_CLAIM_REWARD_BTN}

User Should Already Claimed Reward
  User Should Be Successfully Claimed Reward
