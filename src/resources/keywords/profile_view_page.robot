*** Settings ***
Resource    ../variables/profile_view_constants.robot

*** Keywords ***
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
