*** Settings ***
Resource    ../variables/like_unlike_constants.robot

*** Keywords ***
#========#
#  WHEN  #
#========#
User "${e_ACTION}" Newly Created Proposal In "${e_PAGE}" Page
  Hide SnackBar
  ${t_locator}=  Set Variable If  "${e_PAGE}"=="DASHBOARD"
  ...  ${PROPOSAL_CARD}:eq(0) ${DASHBOARD_${e_ACTION}_LINK}
  ...  css=[class*="Upvote"] button
  ${t_actionType}=  Set Variable If  "${e_ACTION}"=="LIKES"
  ...  LIKE  LIKES
  ${t_text}=  Get Text  ${t_locator}
  ${t_likeCount}=  Remove String  ${t_text}  ${t_actionType}
  ${t_value}=  Convert To Integer  ${t_likeCount}
  Set Suite Variable  ${s_ACTION}  ${e_ACTION}
  Set Suite Variable  ${s_COUNT}   ${t_value}
  Wait And Click Element  ${t_locator}

User "${e_ACTION}" A Comment
  ${t_locator}=  Set Variable  ${COMMMENT_DIV}:first
  ${t_actionType}=  Set Variable If  "${e_ACTION}"=="LIKES"
  ...  LIKES  LIKES
  Wait Until Element Should Be Visible  ${t_locator} ${COMMENT_ACTION_CONTAINER}:eq(1)
  ${t_text}=  Get Text  ${t_locator} ${COMMENT_ACTION_CONTAINER}:eq(1)
  ${t_likeCount}=  Remove String  ${t_text}  ${t_actionType}
  ${t_value}=  Convert To Integer  ${t_likeCount}
  Set Suite Variable  ${s_ACTION}  ${e_ACTION}
  Set Suite Variable  ${s_COUNT}   ${t_value}
  Modify Element Attribute Via jQuery  ${GOVERNANCE_MENU}  display  none
  Set Focus To Element  ${t_locator} ${LIKE_ICON}
  Wait And Click Element  ${t_locator} ${LIKE_ICON}
  Set Suite Variable  ${s_COMMENT_THREAD}  ${t_locator}

#========#
#  THEN  #
#========#
Proposoal Like Counter Should Be Correct In "${e_PAGE}" Page
  ${t_counter}=  Compute Like Counter
  ${t_locator}=  Set Variable If  "${e_PAGE}"=="DASHBOARD"
  ...  ${PROPOSAL_CARD}:eq(0) ${DASHBOARD_${s_ACTION}_LINK}
  ...  css=[class*="Upvote"] button
  Wait Until ELement Should Contain  ${t_locator}  ${t_counter}

Comment Like Counter Should Be Correct
  [Arguments]  ${p_action}=${TRUE}
  ${t_value}=  Run Keyword if  '${p_action}'=='${TRUE}'
  ...  Compute Like Counter
  ...  ELSE  Set Variable  ${s_LATEST_COUNTER}
  ${t_strValue}=  Convert To String  ${t_value}
  Wait Until Element Should Be Visible  ${s_COMMENT_THREAD} ${COMMENT_ACTION_CONTAINER}:eq(1)
  Wait Until Element Should Contain  ${s_COMMENT_THREAD} ${COMMENT_ACTION_CONTAINER}:eq(1)  ${t_strValue}

#====================#
#  INTERNAL KEYWORD  #
#====================#
Compute Like Counter
  ${t_int}=  Convert To Integer  ${s_COUNT}
  ${t_value}=  Run Keyword If  "${s_ACTION}"=="LIKES"
  ...  Evaluate  ${t_int} + 1
  ...  ELSE
  ...  Evaluate  ${t_int} - 1
  ${t_str}=  Convert To String  ${t_value}
  Set Suite Variable  ${s_LATEST_COUNTER}  ${t_str}
  [Return]  ${t_str}
