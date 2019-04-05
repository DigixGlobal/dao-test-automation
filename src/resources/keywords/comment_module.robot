*** Settings ***
Resource    forum_admin_module.robot
Resource    ../variables/comment_constants.robot

*** Keywords ***
#========#
#  WHEN  #
#========#
"${e_USER}" Posts "${e_COUNT}" Thread On Created Proposal
  Switch Browser  ${e_USER}
  Go To Newly Created Proposal View Page
  Set Selenium Speed  ${REMOTE_SPEED}
  ${t_list}=  Create List
  :FOR  ${index}  IN RANGE  0  ${e_COUNT}
  \  ${t_time}=  Get Time  epoch
  \  ${t_value}=  Convert To String  ${t_time} - ${index} - thread
  \  Input Text  ${THREAD_FIELD}  ${t_value}
  \  Wait And Click Element  ${THREAD_BUTTON}
  \  ${t_commentDiv}=  Set Variable  ${COMMMENT_DIV}:eq(${index})
  \  Wait Until Element Should Be Visible  ${t_commentDiv}
  \  Append To List  ${t_list}  ${t_value}
  Set Global Variable  ${g_THREAD_VALUES}  ${t_list}
  Set Selenium Speed  0

"${e_USER}" Posts Multiple "${e_COMMENT_TYPE}" To Thread "${e_THREAD_NUMBER}"
  Switch Browser  ${e_USER}
  ${t_icon}=  Set Variable If  '${e_COMMENT_TYPE}'=='NESTED_REPLIES'
  ...  ${REPLY_ICON}:last  ${REPLY_ICON}
  # Wait Until Element Should Be Visible  ${THREAD_SECTION}
  Modify Element Attribute Via jQuery  ${GOVERNANCE_MENU}  display  none
  ${t_list}=  Create List
  Set Selenium Speed  ${REMOTE_SPEED}
  :FOR  ${index}  IN RANGE  0  ${NUMBER_OF_${e_COMMENT_TYPE}}
  \  ${t_time}=  Get Time  epoch
  \  ${t_value}=  Convert To String  ${t_time} - ${index} - ${e_COMMENT_TYPE}
  \  ${t_thread_div}=  Set Variable  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER})
  \  Set Focus To Element  ${t_thread_div} ${t_icon}
  \  Wait And Click Element  ${t_thread_div} ${t_icon}
  \  ${t_comment_field}=  Set Variable  ${t_thread_div} textarea
  \  Wait Until Element Should Be Visible  ${t_comment_field}
  \  Input Text  ${t_comment_field}  ${t_value}
  \  Wait And Click Element  ${t_thread_div} ${POST_COMMENT_BTN}
  \  Append To List  ${t_list}  ${t_value}
  Set Test Variable  ${tc_${e_COMMENT_TYPE}_VALUES}  ${t_list}
  Set Test Variable  ${tc_THREAD_DIV}  ${e_THREAD_NUMBER}
  Set Suite Variable  ${s_${e_COMMENT_TYPE}_VALUES}  ${t_list}
  Set Suite Variable  ${s_${e_COMMENT_TYPE}_NUMBER}  ${e_THREAD_NUMBER}
  Set Suite Variable  ${s_TYPE}  ${e_COMMENT_TYPE}
  Set Selenium Speed  0

"${e_USER}" Sorts Main Thread From "${e_SORTING}"
  Wait Until Element Should Be Visible  ${SORTING_DD}
  Set Focus To Element  ${SORTING_DD}
  ${t_text}=  Get Text  ${COMMMENT_DIV}:eq(0) ${COMMENT_POST}
  Set Suite Variable  ${s_THREAD_ONE_VALUE}  ${t_text}
  Select From List By Label  ${SORTING_DD}  ${e_SORTING}
  Sleep  3 seconds
  Wait Until Element Should Be Visible  ${COMMMENT_DIV}:eq(0)

User Shows All Main Thread Comments
  Wait Until Element Should Be Visible  ${THREAD_SECTION}
  Wait And Click Element  ${THREAD_SECTION} ${LOAD_MORE_COMMENT_LINK}

User Shows All "${e_COMMENT_TYPE}" Comments
  ${t_BUTTON}=  Set Variable  ${COMMMENT_DIV}:eq(${s_${e_COMMENT_TYPE}_NUMBER}) ${LOAD_MORE_REPLIES_LINK}
  Wait Until ELement Should Be Visible  ${t_BUTTON}
  Set Focus To Element  ${t_BUTTON}
  Click Element  ${t_BUTTON}
  Set Suite Variable  ${s_TYPE}  ${e_COMMENT_TYPE}

"${e_USER}" Deletes Main Thread "${e_THREAD_NUMBER}"
  Wait Until Element Should Be Visible  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER})
  Modify Element Attribute Via jQuery  ${GOVERNANCE_MENU}  display  none
  Click Element  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER}) [kind="trash"]

"${e_USER}" Likes Main Thread "${e_THREAD_NUMBER}"
  Wait Until Element Should Be Visible  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER})
  Modify Element Attribute Via jQuery  ${GOVERNANCE_MENU}  display  none
  Click Element  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER}) [kind="like"]

Admin "${e_ACTION}" "${e_NAME}" From Commenting
  Wait Until Element Should Be Visible  ${SEARCH_BAN_FIELD}
  Input Text  ${SEARCH_BAN_FIELD}  ${e_NAME}
  Wait And Click Element  ${SERACH_ICON}
  Wait And Click Element  ${BANNED_BTN}

#========#
#  THEN  #
#========#
User Should "${e_VISIBILITY}" Able To Post A Comment
  ${t_value}=   Set Variable If  '${e_VISIBILITY.lower()}'=='not be'
  ...  be  not be
  Run Keyword  Wait Until Element Should ${t_value} Visible  ${BANNED_CONTAINER}

Ban Button Label Should Be "${e_BUTTON_LABEL}"
  Wait Until Element Should Contain  ${BANNED_BTN}  ${e_BUTTON_LABEL}

All Thread Comments Should Be Visible
  Wait Until Element Should Be Visible  ${COMMMENT_DIV}
  :FOR  ${index}  ${value}  IN ENUMERATE  @{g_THREAD_VALUES}
  \  ${t_div}=  Set Variable  ${COMMMENT_DIV}:eq(${index}) ${COMMENT_POST}
  \  ${t_text}=  Get Text  ${t_div}
  \  Wait Until ELement Should Contain  ${t_div}  ${value}

Main Thread Should Be Sorted
  Wait Until Element Should Be Visible  ${COMMMENT_DIV}:eq(0)
  Wait Until ELement Should Not Contain  ${COMMMENT_DIV}:eq(0)  ${s_THREAD_ONE_VALUE}

All Comments Should Be Visible
  ${t_thread_div}=  Set Variable  ${COMMMENT_DIV}:eq(${s_${s_TYPE}_NUMBER})
  :FOR  ${index}  ${value}  IN ENUMERATE  @{s_${s_TYPE}_VALUES}
  \  ${t_div}=  Set Variable  ${t_thread_div} ${COMMENT_REPLY} ${COMMENT_POST}:eq(${index})
  \  Wait Until Element Should Be Visible  ${t_div}
  \  Wait Until ELement Should Contain  ${t_div}  ${value}

Main Thread "${e_THREAD_NUMBER}" Messages Should Be Empty
  Wait Until Element Should Be Visible  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER})
  Wait Until ELement Should Contain  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER})  ${REMOVE_MESSAGE}
  Element Should Not Be Visible  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER}) [kind="trash"]

Main Thread "${e_THREAD_NUMBER}" Should Have Like
  Wait Until Element Should Be Visible  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER})
  Set Focus To Element  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER})
  Wait Until ELement Should Contain  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER}) [class*="ActionCommentButton"]:eq(1)  1

#====================#
#  SETUP / TEARDOWN  #
#====================#
User Revisits Newly Created Proposal
  User Goes To "Home" View Page
  Go To Newly Created Proposal View Page
