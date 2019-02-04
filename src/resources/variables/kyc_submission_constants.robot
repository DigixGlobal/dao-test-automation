*** Variables ***
${KYC_BASIC_WIZARD_DIV}  css=[data-digix="KycOverlay-WizardMenu-BasicInformation"]
${KYC_PROCEED_BTN}  css=[data-digix="KycOverlay-ProceedToKyc"]
${KYC_OVERLAY_NEXT_BTN}  css=[data-digix="KycOverlay-Next"]

${KYC_FIRST_NAME_FIELD}  css=[data-digix="KycForm-firstName"]
${KYC_LAST_NAME_FIELD}  css=[data-digix="KycForm-lastName"]
${KYC_DOB_FIELD}  css=[data-digix="KycForm-birthdate"]
${KYC_GENDER_DD}  css=[data-digix="KycForm-gender"]
${KYC_COB_DD}  css=[data-digix="KycForm-birthCountry"]
${KYC_NATONALITY_DD}  css=[data-digix="KycForm-nationality"]
${KYC_PHONE_NUMBER_FIELD}  css=[data-digix="KycForm-phoneNumber"]
${KYC_EMPLOYMENT_STATUS_DD}  css=[data-digix="KycForm-employmentStatus"]
${KYC_JOB_INDUSTRY_DD}  css=[data-digix="KycForm-employmentIndustry"]
${KYC_INCOME_RANGE_DD}  css=[data-digix="KycForm-incomeRange"]
${KYC_ID_PROOF_DD}  css=[data-digix="KycForm-identificationProofType"]
${KYC_ID_UPLOAD_BTN}  css=[data-digix="KycForm-identificationProofDataUrl"]
${KYC_ID_EXPIRATION_FIELD}  css=[data-digix="KycForm-identificationProofExpirationDate"]
${KYC_ID_NUMBER_FIELD}  css=[data-digix="KycForm-identificationProofNumber"]

${KYC_RESIDENCE_DD}  css=[data-digix="KycForm-country"]
${KYC_ADDRESS_ONE_FIELD}  css=[data-digix="KycForm-address"]
${KYC_ADDRESS_TWO_FIELD}  css=[data-digix="KycForm-addressDetails"]
${KYC_CITY_FIELD}  css=[data-digix="KycForm-city"]
${KYC_STATE_FIELD}  css=[data-digix="KycForm-state"]
${KYC_ZIP_CODE_FIELD}  css=[data-digix="KycForm-postalCode"]
${KYC_RESIDENCE_PROOF_DD}  css=[data-digix="KycForm-residenceProofType"]
${KYC_RESIDENCE_ID_UPLOAD_BTN}  css=[data-digix="KycForm-residenceProofDataUrl"]

${KYC_PHOTO_PROOF_DD}  css=select[class*="StyledSelect"]
${KYC_PHOTO_PROOF_UPLOAD_BTN}  css=[data-digix="KycForm-identificationPoseDataUrl"]
${KYC_SUBMIT_BTN}  css=[data-digix="KycOverlay-Submit"]

${KYC_ERROR_DIV}  css=[class*="NoteContainer"]

${PROFILE_KYC_STATUS_LABEL}  css=[data-digix="Profile-KycStatus"]

# constants
${GENDER}  MALE
${LOCATION}  Philippines
${EMPLOYMENT}  EMPLOYED
${JOB_INDUSTRY}  Consultancy
${SALARY_RANGE}  > 1,000,000.00
${VALID_ID}  NATIONAL ID
${RESIDENCE_PROOF}  BANK STATEMENT
${METHOD_OF_PHOTO_PROOF}  Photo Upload
