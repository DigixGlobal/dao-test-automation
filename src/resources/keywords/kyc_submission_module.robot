*** Settings ***
Resource    ../variables/profile_view_constants.robot
Resource  ../variables/kyc_submission_constants.robot

*** Keywords ***
#========#
#  WHEN  #
#========#
User Submits KYC Details For Approval
  [Arguments]  ${p_unique}=NONE
  Genearate Dates
  ${t_unique}=  Run Keyword If  '${p_unique}'=='NONE'
  ...  Get Time  epoch
  ...  ELSE  Set Variable  ${p_unique}
  Set Email If Set EMail KYC Button Is Visible  ${t_unique}
  Force Element Via jQuery  ${HELP_LAUNCHER}  hide
  Wait And Click Element  ${PROFILE_SUBMIT_KYC_BTN}
  Wait And Click Element  ${KYC_PROCEED_BTN}
  Wait Until Element Should Be Visible  ${KYC_BASIC_WIZARD_DIV}
  # basic
  Input Text  ${KYC_FIRST_NAME_FIELD}  ${t_unique}
  Input Text  ${KYC_LAST_NAME_FIELD}  ${t_unique}
  Input Text  ${KYC_DOB_FIELD}  ${s_DOB}
  Select From List By Label  ${KYC_GENDER_DD}  ${GENDER}
  Select From List By Label  ${KYC_COB_DD}  ${LOCATION}
  Select From List By Label  ${KYC_NATONALITY_DD}  ${LOCATION}
  Input Text  ${KYC_PHONE_NUMBER_FIELD}  ${t_unique}
  Select From List By Label  ${KYC_EMPLOYMENT_STATUS_DD}  ${EMPLOYMENT}
  Select From List By Label  ${KYC_JOB_INDUSTRY_DD}  ${JOB_INDUSTRY}
  Select From List By Label  ${KYC_INCOME_RANGE_DD}  ${SALARY_RANGE}
  Select From List By Label  ${KYC_ID_PROOF_DD}  ${VALID_ID}
  Upload TestData Image  KYC_ID
  Input Text  ${KYC_ID_EXPIRATION_FIELD}  ${s_VALID_ID_EXP}
  Input Text  ${KYC_ID_NUMBER_FIELD}  ${t_unique}
  Wait Until Element Should Be Enabled  ${KYC_OVERLAY_NEXT_BTN}
  Click Element  ${KYC_OVERLAY_NEXT_BTN}
  # residence proof
  Select From List By Label  ${KYC_RESIDENCE_DD}  ${LOCATION}
  Input Text  ${KYC_ADDRESS_ONE_FIELD}  ${t_unique}
  Input Text  ${KYC_ADDRESS_TWO_FIELD}  ${t_unique}
  Input Text  ${KYC_CITY_FIELD}  ${t_unique}
  Input Text  ${KYC_STATE_FIELD}  ${t_unique}
  Input Text  ${KYC_ZIP_CODE_FIELD}  ${t_unique}
  Select From List By Label  ${KYC_RESIDENCE_PROOF_DD}  ${RESIDENCE_PROOF}
  Upload TestData Image  KYC_RESIDENCE_ID
  Wait Until Element Should Be Enabled  ${KYC_OVERLAY_NEXT_BTN}
  Click Element  ${KYC_OVERLAY_NEXT_BTN}
  # photo proof
  Select From List By Label  ${KYC_PHOTO_PROOF_DD}  ${METHOD_OF_PHOTO_PROOF}
  Upload TestData Image  KYC_PHOTO_PROOF
  Wait Until Element Should Be Enabled  ${KYC_SUBMIT_BTN}
  Click Element  ${KYC_SUBMIT_BTN}

#=====================#
#  INTERNAL KEYWORDS  #
#=====================#
Genearate Dates
  ${yyyy}  ${mm}  ${dd}=  Get Time  year,month,day
  ${t_year_dob}=  Evaluate  ${yyyy} - 18
  ${t_year_id_valid}=  Evaluate  ${yyyy} + 1
  Set Suite Variable  ${s_DOB}  ${t_year_dob}-${mm}-${dd}
  Set Suite Variable  ${s_VALID_ID_EXP}  ${t_year_id_valid}-${mm}-${dd}

Set Email If Set EMail KYC Button Is Visible
  [Arguments]  ${p_email}=NONE
  Wait Until Element Should Be Visible  ${PROFILE_STAKE_AMOUNT}
  ${t_visible}=  Run Keyword And Return Status
  ...  Element Should Be Visible  ${PROFILE_SET_EMAIL_KYC_BTN}
  Force Element Via jQuery  ${HELP_LAUNCHER}  hide
  ${t_email}=  Set Variable  ${p_email}@a.co
  Run Keyword If  ${t_visible}  Run Keywords
  ...  Click Element  ${PROFILE_SET_EMAIL_KYC_BTN}
  ...  AND  Clear Element Text  ${PROFILE_SET_EMAIL_FIELD}
  ...  AND  Input Text  ${PROFILE_SET_EMAIL_FIELD}  ${t_email}
  ...  AND  Wait Until Element Should Be Enabled   ${PROFILE_CHANGE_EMAIL_BTN}
  ...  AND  Click Element  ${PROFILE_CHANGE_EMAIL_BTN}
