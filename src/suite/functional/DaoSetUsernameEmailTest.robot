*** Settings ***
Documentation  This suite will test setting up username and
...  email on Profile view page
Force Tags  regression  smoke  notForKovan
Default Tags    DaoSetUsernameEmailTest
Suite Setup  Generate Suite Unique Value
Suite Teardown    Close All Browsers
Resource  ../../resources/common/web_helper.robot
Resource  ../../resources/keywords/governance_page.robot
Resource  ../../resources/keywords/profile_view_page.robot

*** Test Cases ***
Participant Has Successfully Validated Stats On Profile View Page
  [Setup]  "participant" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  And Pull Profile Stats Data
  When User Goes To "Profile" View Page
  Then Assert User Profile Values Are Correct

Participant Has Successfully Sets Username
  [Setup]  Force Fail Test If Username Is Already Set
  [Template]  User Sets Account Details By Component
  # component      input                expected result     mesage
    username       ${SPACE}               invalid            ${INVALID_USERNAME}
    username       a                      invalid            ${INVALID_USERNAME}
    username       user                   invalid            ${INVALID_USERNAME}
    username       user123                invalid            ${INVALID_USERNAME}
    username       abcde12345abcde12345a  invalid            ${INVALID_USERNAME}
    username       test<>                 invalid            ${INVALID_USERNAME}
    username       test${s_UNIQUE}        valid

Participant Has Successfully Sets Email
  [Template]  User Sets Account Details By Component
  # component         input             expected result     mesage
    email             ${SPACE}            invalid             ${INVALID_EMAIL}
    email             ${s_UNIQUE}         invalid             ${INVALID_EMAIL}
    email             ${s_UNIQUE}@        invalid             ${INVALID_EMAIL}
    email             ${s_UNIQUE}@a       invalid             ${INVALID_EMAIL}
    email             ${s_UNIQUE}@a.c     invalid             ${INVALID_EMAIL}
    email             ${s_UNIQUE}@a.co    valid

Moderator Has Successfully Validated Stats On Profile View Page
  [Setup]  "moderator" Account Has Successfully Logged In To DigixDao Using "json"
  Given User Is In "GOVERNANCE" Page
  And Pull Profile Stats Data
  When User Goes To "Profile" View Page
  Then Assert User Profile Values Are Correct

Moderator Has Not Sucecssfullly Set Username Due to Username Already Exist
  Given User Is In "Profile" Page
  When User Sets Account Details By Component  username
  ...  test${s_UNIQUE}  exist  ${INVALID_USERNAME_EXIST}

Moderator Has Not Sucecssfullly Set Email Due to Username Already Exist
  Given User Is In "Profile" Page
  When User Sets Account Details By Component  email
  ...  ${s_UNIQUE}@a.co  exist  ${INVALID_EMAIL_EXIST}
