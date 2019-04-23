*** Settings ***
Resource    ../variables/profile_view_constants.robot

*** Keywords ***
#=========#
#  GIVEN  #
#=========#
Pull "${e_USER}" Data From Info Server
  Wait Until Element Should Be Visible  ${ADDRESS_LABEL}
  ${t_address}=  Get Text  ${ADDRESS_LABEL}
  ${t_redeemStatus}=  LookUp Value On Info Server  ${t_address}  /result/redeemedBadge
  Set Suite Variable  ${s_ADDRESS}  ${t_address}
  Set Suite Variable  ${s_REDEEM_STATUS}  ${t_redeemStatus}

#========#
#  WHEN  #
#========#
"${e_USER}" Marks Himself As Participant
  Wait Until Element Should Be Visible  ${PROFILE_ROLE_DIV}
  ${t_role}=  Get Text  ${PROFILE_ROLE_DIV}
  Run Keyword If  '${t_role}'=='Past Participant'  Run Keywords
  ...  Click Element  ${HEADER_LOCK_DGD_BTN}
  ...  AND  User Submits Locked Stake
  ...  AND  Wait Until Element Should Be Visible  ${CONGRATULATION_BANNER}
  ...  AND  Click Element  ${CLOSE_ICON}
  ...  AND  Wait And Click Element  ${HOME_SIDE_MENU_ICON}
  ...  AND  Wait Until Element Should Be Visible  ${DASHBOARD_STATS_DIV}
  ...  AND  User Goes To "Profile" View Page
  Wait Until Element Should Contain  ${PROFILE_ROLE_DIV}  Participant

"${e_USER}" Redeems Badge
  Wait Until Element Should Be Visible  ${PROFILE_MODERATOR_CARD}
  Run Keyword If  ${s_REDEEM_STATUS}  Run Keywords
  ...  Log To Console  ${\n}"${s_ADDRESS}" already redeemed badge. Please reset servers on ${ENVIRONMENT}
  ...  AND  FAIL  msg=Please run `bash script/restart.sh` on `dao-server` repo
  ...  ELSE  Run Keywords
  ...  Click Element  ${PROFILE_REDEEM_BADGE_BTN}
  ...  AND  User Submits Keystore Password

"${e_USER}" Approves Interaction To Contract
  Wait And Click Element  ${PROFILE_REDEEM_BADGE_BTN}
  Wait And Click ELement  ${BADGE_APPROVE_INTERACTION_BTN}
  User Submits Keystore Password

User Acknowledges Can Change Once
  Wait And Click Element  ${PROFILE_USERNAME_PROCEED_BTN}

#========#
#  THEN  #
#========#
Assert User Profile Values Are Correct
  Wait Until Element Should be Visible  ${PROFILE_REWARD_DIV}
  Wait Until ELement Should Contain  ${PROFILE_QUARTER_AMOUNT}  ${s_QUARTER_PTS}
  Wait Until ELement Should Contain  ${PROFILE_REPUTATION_AMOUNT}  ${s_REPUTATION_PTS}
  Wait Until ELement Should Contain  ${PROFILE_STAKE_AMOUNT}  ${s_STAKE_PTS}

Gain Moderator Status Card Should Be Visible Based On Role
  Wait Until Element Should Be Visible  ${PROFILE_ROLE_DIV}
  ${t_role}=  Get Text  ${PROFILE_ROLE_DIV}
  Run Keyword If  "${t_role}"=="Moderator"
  ...  Wait Until Element Should Not Be Visible  ${PROFILE_MODERATOR_CARD}
  ...  ELSE  Moderator Status Card Is Visible And Values Are Correct

Moderator Status Card Is Visible And Values Are Correct
  Wait Until Element Should Be Visible  ${PROFILE_MODERATOR_CARD}
  ${t_strRep}=  Compute Remaining Value  REPUTATION
  ${t_strStake}=  Compute Remaining Value  STAKE
  ${t_eval}=  Evaluate  ${t_strRep} > 0 or ${t_strStake} > 0
  Run Keyword If  ${t_eval}==${TRUE}  Run Keywords
  ...  Wait Until ELement Should Contain  ${PROFILE_REMAINING_REPUTATION}  ${t_strRep}
  ...  AND  Wait Until ELement Should Contain  ${PROFILE_REMAINING_STAKE}  ${t_strStake}

Badge Should Be Successfully Redeemed
  Wait Until Element Should Be Visible  ${PROFILE_ROLE_DIV}
  Run Keyword If  ${s_REDEEM_STATUS}  Run Keywords
  ...  Log To Console  ${\n}"${s_ADDRESS}" already redeemed badge
  ...  AND  Wait Until Element Is Disabled  ${PROFILE_REDEEM_BADGE_BTN}
  ...  ELSE
  ...  Wait Until Element Is Disabled  ${PROFILE_REDEEM_BADGE_BTN}

Badge Has Already Been Redeemed
  Wait Until Element Should Be Visible  ${PROFILE_ROLE_DIV}
  Wait Until Element Is Disabled  ${PROFILE_REDEEM_BADGE_BTN}

Redeem Badge Should Be Disabled
  Badge Has Already Been Redeemed

User Should Successfully Interacted To Badge Contract
  Wait Until Element Should Be Visible  ${GOVERNANCE_FILTER_SECTION}
  Sleep  5 seconds

Gain Moderator Card Should Not Be Visible
  Wait Until Element Should Be Visible  ${PROFILE_ROLE_DIV}
  Wait Until Element Should Not Be Visible  ${PROFILE_MODERATOR_CARD}

KYC Status Should Be "${e_STATUS}"
  Wait Until Element Should Be Visible  ${PROFILE_KYC_STATUS_LABEL}
  Wait Until ELement Should Contain  ${PROFILE_KYC_STATUS_LABEL}  ${e_STATUS}
  Run Keyword If  "${e_STATUS.lower()}"=="pending"
  ...  Wait Until Element Should Not Be Visible  ${PROFILE_SUBMIT_KYC_BTN}
  ...  ELSE IF  "${e_STATUS.lower()}"=="approved"
  ...  Wait Until Element Should Be Enabled  ${PROFILE_SUBMIT_KYC_BTN}
  ...  ELSE
  ...  Wait Until Element Should Be Enabled  ${PROFILE_SUBMIT_KYC_BTN}

#=====================#
#  INTERNAL KEYWORDS  #
#=====================#
Compute Remaining Value
  [Arguments]  ${p_type}
  ${t_result}=  Run Keyword And Return Status
  ...  Should Contain  ${s_${p_type}_PTS}  .
  ${t_function}=  Set Variable If   ${t_result}
  ...  Convert To Number  Convert To Integer
  ${t_test}=  Run Keyword  ${t_function}  ${s_${p_type}_PTS}
  ${t_remaining}=  Evaluate  ${${ENVIRONMENT}_MIN_${p_type}_PTS} - ${t_test}
  ${t_value}=  Set Variable If  ${t_remaining} >= 0
  ...  ${t_remaining}  0
  ${t_strValue}=  Convert To String  ${t_value}
  [Return]  ${t_strValue}

Force Fail Test If Username Is Already Set
  Wait Until Element Should Be Visible  ${PROFILE_USERNAME_DIV}
  ${t_modified}=  Run Keyword And Return Status
  ...  Element Should Contain  ${PROFILE_USERNAME_DIV}  test
  Run Keyword If  ${t_modified}  Run Keywords
  ...  Wait Until Element Should Not Be Visible  ${PROFILE_SET_USERNAME_BTN}
  ...  AND  FAIL  msg=${\n}username is already been set. Please reset servers on ${ENVIRONMENT}

#============#
#  TEMPLATE  #
#============#
User Sets Account Details By Component
  [Arguments]  ${p_component}  ${p_value}  ${p_expected_result}  ${p_message}=${EMPTY}
  Wait And Click Element  ${PROFILE_SET_${p_component}_BTN}
  Run Keyword If  '${p_component.lower()}'=='username'
  ...  User Acknowledges Can Change Once
  Wait Until Element Should Be Visible  ${PROFILE_SET_${p_component}_FIELD}
  Clear Element Text  ${PROFILE_SET_${p_component}_FIELD}
  Input Text  ${PROFILE_SET_${p_component}_FIELD}  ${p_value}
  Run Keyword If  '${p_expected_result}'=='invalid'  Run Keywords
  ...  Wait Until Element Should Contain  ${PROFILE_ERROR_DIV}  ${p_message}
  ...  AND  Wait Until Element Is Disabled  ${PROFILE_CHANGE_${p_component}_BTN}
  ...  AND  Click Element  ${CLOSE_ICON}
  ...  ELSE IF  '${p_expected_result}'=='exist'  Run Keywords
  ...  Wait And Click Element  ${PROFILE_CHANGE_${p_component}_BTN}
  ...  AND  Wait Until Element Should Contain  ${PROFILE_ERROR_DIV}  ${p_message}
  ...  AND  Click Element  ${CLOSE_ICON}
  ...  ELSE IF  '${p_expected_result}'=='valid'  Run Keywords
  ...  Wait And Click Element  ${PROFILE_CHANGE_${p_component}_BTN}
  ...  AND  Wait Until Element Should Be Visible  ${PROFILE_${p_component}_DIV}
  ...  AND  Wait Until Element Should Contain  ${PROFILE_${p_component}_DIV}  ${p_value}
  Run Keyword If  '${p_component}'=='username' and '${p_expected_result}'=='valid'
  ...  Wait Until Element Should Not Be Visible  ${PROFILE_SET_USERNAME_BTN}
