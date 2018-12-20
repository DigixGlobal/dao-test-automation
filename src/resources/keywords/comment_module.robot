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
  Set Selenium Speed  0.5 s
  :FOR  ${index}  IN RANGE  0  ${NUMBER_OF_THREADS}
  \  ${t_time}=  Get Time  epoch
  \  ${t_comment_value}=  Convert To String  ${t_time} - ${index} - thread
  \  Input Text  ${THREAD_FIELD}  ${t_comment_value}
  \  Wait Until Element Is Enabled  ${THREAD_BUTTON}
  \  Click Element  ${THREAD_BUTTON}
  \  ${t_commentDiv}=  Set Variable  ${COMMMENT_DIV}:eq(${index})
  \  Wait Until Element Should Be Visible  ${t_commentDiv}
  \  Element Should Contain  ${t_commentDiv} ${COMMENT_POST}  ${t_comment_value}
  Set Selenium Speed  0

"${e_USER}" Posts Multiple Replies To Thread "${e_THREAD_NUMBER}"
  Switch Browser  ${e_USER}
  Wait Until Element Should Be Visible  ${THREAD_SECTION}
  Modify Element Attribute Via jQuery  ${GOVERNANCE_MENU}  display  none
  Set Selenium Speed  0.5 s
  :FOR  ${index}  IN RANGE  0  ${NUMBER_OF_CHILD}
  \  ${t_time}=  Get Time  epoch
  \  ${t_comment_value}=  Convert To String  ${t_time} - ${index} - reply
  \  ${t_first_thread}=  Set Variable  ${COMMMENT_DIV}:eq(${e_THREAD_NUMBER})
  \  Set Focus To Element  ${t_first_thread} ${REPLY_ICON}
  \  Wait And Click Element  ${t_first_thread} ${REPLY_ICON}
  \  ${t_comment_field}=  Set Variable  ${t_first_thread} textarea
  \  Wait Until Element Should Be Visible  ${t_comment_field}
  \  Input Text  ${t_comment_field}  ${t_comment_value}
  \  Wait Until Element Is Enabled  ${t_first_thread} ${ROUND_BTN}
  \  Click Element  ${t_first_thread} ${ROUND_BTN}
  # \  ${t_reply_div}=  Set Variable  ${t_first_thread} ${COMMENT_REPLY}:eq(${index}) ${COMMENT_POST}
  Set Selenium Speed  0

#========#
#  THEN  #
#========#
# All Thread Comments Should Be Visible

