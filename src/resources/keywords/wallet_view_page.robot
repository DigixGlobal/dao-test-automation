*** Settings ***
Resource  ../variables/wallet_view_contants.robot

*** Keywords ***
#========#
#  WHEN  #
#========#
"${e_USER}" Claims Reward
  Wait Until Element Should Be Visible  ${WALLET_ADDRESS_DIV}
  ${t_address}=  Get Text  ${WALLET_ADDRESS_DIV}
  ${t_claimValue}=  LookUp Value On Info Server  ${t_address}  /result/claimableDgx
  ${t_zero}=  Evaluate  ${t_claimValue} == 0
  Run Keyword If  ${t_zero}  Run Keywords
  ...  Log To Console  ${\n}Please run `npm run teleport:main_phase` on `dao-contracts`
  ...  AND  Log To Console  ${\n}then Restart info-server
  ...  AND  Fail  msg=Please run command on dao-contracts and restart info-server
  ...  ELSE  Run Keywords
  ...  Wait And Click Element  ${WALLET_CLAIM_REWARD_BTN}
  ...  AND  User Submits Keystore Password  #transaction modal

"${e_USER}" Locks "${e_AMOUNT}" DGD on Wallet Page
  Wait Until Element Should Be Visible  ${WALLET_ADDRESS_DIV}
  Wait And Click Element  ${WALLET_LOCKED_DGD_BTN}
  Wait Until Element Should Be Visible  ${LOCK_WITH_AMOUNT_BTN}  #on governance_contants file
  User Submits Locked Stake  ${e_AMOUNT}
  Set Suite Variable  ${s_LOCKED_DGD_AMOUNT}  ${e_AMOUNT}
  # Wait Until Element Should Be Visible  ${CONGRATULATION_BANNER}
  # Wait And Click Element  ${OVERLAY_CLOSE_BTN}
  # Wait Until Element Should Be Visible  ${WALLET_ADDRESS_DIV}

"${e_USER}" Unlocks "${e_AMOUNT}" Stake On "${e_PHASE}"
  Pulled Wallet Stats
  Hide SnackBar
  Wait And Click Element  ${WALLET_UNLOCKED_DGD_BTN}
  Wait Until Element Should Be Visible  ${WALLET_UNLOCK_AMOUNT_FIELD}
  Wait Until Element Should Contain  ${WALLET_DGD_AMOUNT_LABEL}  ${s_STAKE_AMOUNT}
  ${t_value}=  Run Keyword If  '${e_AMOUNT}'!='MAX'
  ...  Evaluate  ${s_STAKE_AMOUNT} - ${e_AMOUNT}
  ...  ELSE  Set Variable  0
  ${t_strValue}=  Convert To String  ${t_value}
  Run Keyword If  '${e_AMOUNT}'!='MAX'
  ...  Press Key  ${WALLET_UNLOCK_AMOUNT_FIELD}  ${e_AMOUNT}
  ...  ELSE
  ...  Click Element  ${WALLET_FILL_AMOUNT_LINK}
  Wait Until Element Should Contain
  ...  ${WALLET_REMAINING_UNLOCK_AMOUNT_LABEL}  ${t_strValue}
  Wait And Click Element  ${WALLET_UNLOCKED_BTN}
  User Submits Keystore Password
  Set Suite Variable  ${s_LOCKED_DGD_AMOUNT}  ${e_AMOUNT}

#========#
#  THEN  #
#========#
User Should Be Successfully Claimed Reward
  Wait Until Element Should Be Visible  ${WALLET_REWARD_AMOUNT}
  ${t_value}=  Get Text  ${WALLET_REWARD_AMOUNT}
  ${t_true}=  Evaluate  ${t_value}!=0
  Run Keyword If  ${t_true}
  ...  Wait Until Element Is Disabled  ${WALLET_CLAIM_REWARD_BTN}
  ...  ELSE  Fail  msg=claim dgx valus is ${t_value}

Claim Reward Value Should Be Zero
  Wait Until Element Should Be Visible  ${WALLET_REWARD_AMOUNT}
  ${t_value}=  Get Text  ${WALLET_REWARD_AMOUNT}
  ${t_true}=  Evaluate  ${t_value}==0
  Run Keyword If  ${t_true}
  ...  Wait Until Element Is Disabled  ${WALLET_CLAIM_REWARD_BTN}
  ...  ELSE  Fail  msg=unable to claim dgx reward

User Should Already Claimed Reward
  Claim Reward Value Should Be Zero

User Should Successfully "${e_ACTION}" DGD
  Wait Until Element Should Be Visible  ${WALLET_ADDRESS_DIV}
  # Wait Until Element Is Disabled  ${WALLET_${e_ACTION}_DGD_BTN}

"${e_ACTION}" DGD Computation Should Be Correct
  ${t_operand}=  Set Variable If  '${e_ACTION}'=='LOCKED'
  ...  +  -
  ${t_amount}=  Set Variable If  '${e_ACTION}'=='LOCKED'
  ...  ${s_LOCK_STAKE}  ${s_LOCKED_DGD_AMOUNT}
  Log  ${s_STAKE_AMOUNT}, ${s_LOCKED_DGD_AMOUNT}, ${s_LOCK_STAKE}
  Wait Until Element Should Be Visible  ${WALLET_ADDRESS_DIV}
  ${t_value}=  Run Keyword If  '${s_LOCKED_DGD_AMOUNT}'!='MAX'
  ...  Evaluate  ${s_STAKE_AMOUNT} ${t_operand} ${t_amount}
  ...  ELSE  Set Variable  0
  ${t_strValue}=  Convert To String  ${t_value}
  Wait Until Element Should Contain  ${WALLET_STAKE_AMOUNT}  ${t_strValue}
  Run Keyword If  '${t_value}'=='0'
  ...  Wait Until Element Is Disabled  ${WALLET_UNLOCKED_DGD_BTN}

User Should Not Be Able To Unlocked DGD
  Wait Until Element Should Be Visible  ${WALLET_ADDRESS_DIV}
  Wait Until Element Is Disabled  ${WALLET_UNLOCKED_DGD_BTN}

#====================#
#  INTERNAL KEYWORD  #
#====================#
Pulled Wallet Stats
  Wait Until Element Should Be Visible  ${WALLET_ADDRESS_DIV}
  ${t_stake}=  Get Text  ${WALLET_STAKE_AMOUNT}
  Set Suite Variable  ${s_STAKE_AMOUNT}  ${t_stake}

Move System To "${e_PHASE}" Phase
  ${t_phase}=  Set Variable If  '${e_PHASE}'=='LOCKING'
  ...  locking_phase  main_phase
  ${t_status}=  Run And Return Rc And Output  cd ${EXECDIR}/../dao-contracts && npm run teleport:${t_phase} && cd ${EXECDIR}
  Log To Console  ${t_status}
