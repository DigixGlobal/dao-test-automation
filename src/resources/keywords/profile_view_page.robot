*** Settings ***
Resource    ../variables/profile_view_constants.robot

*** Keywords ***
#=========#
#  GIVEN  #
#=========#
Pull "${e_USER}" Data From Info Server
  Wait Until Element Should Be Visible  ${ADDRESS_LABEL}
  ${t_address}=  Get Text  ${ADDRESS_LABEL}
  ${t_url}=  Set Variable  ${${ENVIRONMENT}_INFO_URL}/address/${t_address}
  ${t_lookup}=  Set Variable  /result/redeemedBadge
  ${t_redeemStatus}=  Find Value On Json URL  ${t_url}  ${t_lookup}
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
  Run Keyword If  ${s_REDEEM_STATUS}
  ...  Log To Console  ${\n}"${s_ADDRESS}" already redeemed badge. Please reset servers on ${ENVIRONMENT}
  ...  ELSE  Run Keywords
  ...  Click Element  ${PROFILE_REDEEM_BADGE_BTN}
  ...  AND  User Submits Keystore Password

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
