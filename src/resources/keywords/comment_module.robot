*** Settings ***
Resource    ../variables/comment_constants.robot

*** Keywords ***
#========#
#  WHEN  #
#========#
"${e_USER}" Posts Multiple Thread On Created Proposal
  Switch Browser  ${e_USER}
  Go To Newly Created Proposal View Page
  Wait Until Element Should Be Visible  ${THREAD_SECTION}
  Set Selenium Speed  ${REMOTE_SPEED}
  ${t_list}=  Create List
  :FOR  ${index}  IN RANGE  0  ${NUMBER_OF_THREADS}
  \  ${t_time}=  Get Time  epoch
  \  ${t_value}=  Convert To String  ${t_time} - ${index} - thread
  \  Input Text  ${THREAD_FIELD}  ${t_value}
  \  Wait Until Element Is Enabled  ${THREAD_BUTTON}
  \  Click Element  ${THREAD_BUTTON}
  \  ${t_commentDiv}=  Set Variable  ${COMMMENT_DIV}:eq(${index})
  \  Wait Until Element Should Be Visible  ${t_commentDiv}
  \  Append To List  ${t_list}  ${t_value}
  Set Global Variable  ${g_THREAD_VALUES}  ${t_list}
  Set Selenium Speed  0

"${e_USER}" Posts Multiple "${e_COMMENT_TYPE}" To Thread "${e_THREAD_NUMBER}"
  Switch Browser  ${e_USER}
  ${t_icon}=  Set Variable If  '${e_COMMENT_TYPE}'=='NESTED_REPLIES'
  ...  ${REPLY_ICON}:last  ${REPLY_ICON}
  Wait Until Element Should Be Visible  ${THREAD_SECTION}
  Modify Element Attribute Via jQuery  ${GOVERNANCE_MENU}  display  none
  ${t_list}=  Create List
  Set Selenium Speed  ${REMOTE_SPEED}
  :FOR  ${index}  IN RANGE  0  ${NUMBER_OF_NESTED}
  \  ${t_time}=  Get Time  epoch
  \  ${t_value}=  Convert To String  ${t_time} - ${index} - ${e_COMMENT_TYPE}
  \  ${t_thread_div}=  Set Variable  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER})
  \  Set Focus To Element  ${t_thread_div} ${t_icon}
  \  Wait And Click Element  ${t_thread_div} ${t_icon}
  \  ${t_comment_field}=  Set Variable  ${t_thread_div} textarea
  \  Wait Until Element Should Be Visible  ${t_comment_field}
  \  Input Text  ${t_comment_field}  ${t_value}
  \  Wait Until Element Is Enabled  ${t_thread_div} ${POST_COMMENT_BTN}
  \  Click Element  ${t_thread_div} ${POST_COMMENT_BTN}
  \  Append To List  ${t_list}  ${t_value}
  Set Test Variable  ${tc_${e_COMMENT_TYPE}_VALUES}  ${t_list}
  Set Test Variable  ${tc_THREAD_DIV}  ${e_THREAD_NUMBER}
  Set Suite Variable  ${s_${e_COMMENT_TYPE}_VALUES}  ${t_list}
  Set Suite Variable  ${s_${e_COMMENT_TYPE}_NUMBER}  ${e_THREAD_NUMBER}
  Set Suite Variable  ${s_TYPE}  ${e_COMMENT_TYPE}
  Set Selenium Speed  0

User Shows All Main Thread Comments
  Wait And Click Element  ${THREAD_SECTION} button

User Shows All "${e_COMMENT_TYPE}" Comments
  Set Focus To Element  ${COMMMENT_DIV}:eq(${s_${e_COMMENT_TYPE}_NUMBER})
# User Shows All Reply Comments

# User Shows All Nested Comments

#========#
#  THEN  #
#========#
All Thread Comments Should Be Visible
  :FOR  ${index}  ${value}  IN ENUMERATE  @{g_THREAD_VALUES}
  \  ${t_div}=  Set Variable  ${COMMMENT_DIV}:eq(${index}) ${COMMENT_POST}
  \  Wait Until Element Should Be Visible  ${t_div}
  \  Element Should Contain  ${t_div}  ${value}

All Comments Should Be Visible
  ${t_thread_div}=  Set Variable  ${COMMMENT_DIV}:eq(${s_${s_TYPE}_NUMBER})
  :FOR  ${index}  ${value}  IN ENUMERATE  @{s_${s_TYPE}_VALUES}
  \  ${t_div}=  Set Variable  ${t_thread_div} ${COMMENT_REPLY} ${COMMENT_POST}:eq(${index})
  \  Wait Until Element Should Be Visible  ${t_div}
  \  Element Should Contain  ${t_div}  ${value}

#====================#
#  SETUP / TEARDOWN  #
#====================#
User Goes Back To Goverance Dashboard
  Wait And Click Element  ${MENU_HOME_ICON}
  Go To Newly Created Proposal View Page
