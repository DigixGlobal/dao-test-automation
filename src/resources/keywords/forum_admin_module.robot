*** Variables ***
${REMOVED_MSG}  This comment has been removed.
${REMOVE_ICON}  [kind="delete"]
${RESTORE_ICON}  [kind="restore"]

*** Keywords ***
ForumAdmin "${e_ACTION}" Thread "${e_THREAD_NUMBER}"
  ${t_action}=  Set Variable If  '${e_ACTION.lower()}'=='removes'
  ...  ${REMOVE_ICON}  ${RESTORE_ICON}
  Wait And Click Element  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER}) ${t_action}

Thread "${e_THREAD_NUMBER}" Should Be "${e_ACTION_RESULT}"
  ${t_div}=  Set Variable  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER})
  Run Keyword If  '${e_ACTION_RESULT.lower()}'=='remove'
  ...  Wait Until ELement Should Contain  ${t_div}  ${REMOVED_MSG}
  ...  ELSE
  ...  Wait Until ELement Should Not Contain  ${t_div}  ${REMOVED_MSG}

Thread "${e_THREAD_NUMBER}" Button Should Be "${e_ACTION}"
  ${t_action}=  Set Variable If  '${e_ACTION.lower()}'=='remove'
  ...  ${REMOVE_ICON}  ${RESTORE_ICON}
  ${t_div}=  Set Variable  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER})
  Wait Until Element Should Be Visible  ${t_div} ${t_action}
