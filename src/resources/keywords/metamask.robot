*** Variables ***
${PHRASE}  harbor oak enter vessel morning adult stick proof stock bus work goat
${METAMASK_PW}  digixtest
${KEYSTORE_PW}  digixdao
${METAMASK_HASH}  nkbihfbeogaeaoehlefnkodbefgpgknn/home.html#initialize
${CHROME_CALL}  chrome-extension://
${LOCAL_METAMASK_LABEL}  private network

*** Keywords ***
Setup Metamask Details
  Select Window  main
  Go To  ${CHROME_CALL}${METAMASK_HASH}
  Wait And Click Element  css=.welcome-screen__button
  Wait And Click Element  css=[class*="import-link"]
  Wait Until Element Should Be Visible  css=.import-account__secret-phrase
  Input Text  css=.import-account__secret-phrase  ${PHRASE}
  Input Text  css=[id="password"]  ${METAMASK_PW}
  Input Text  css=[id="confirm-password"]  ${METAMASK_PW}
  Click Element  css=.first-time-flow__button
  Wait Until Element Should Be Visible  css=.tou__body
  Execute Javascript    var test=document.querySelector('.tou__body'); test.scrollTop +=test.scrollHeight
  Wait And Click Element  css=.first-time-flow__button
  Wait And Click Element  css=.first-time-flow__button
  Wait And Click Element  css=.first-time-flow__button
  Wait Until Element Should Be Visible  css=.ethereum-network

Import "${e_USER}" Wallet To Metamask
  ${t_link}=  Get Location
  Go to  ${t_link}new-account/import
  Wait And Click Element  css=.new-account-import-form__select .Select-arrow
  Wait Until Element Should Be Visible  css=.new-account-import-form__select .Select-menu-outer
  Wait And Click Element  css=.new-account-import-form__select .Select-menu-outer [aria-label="JSON File"]
  ${t_path}=  Normalize Path  ${CURDIR}/${KEYSTORE_PATH}/${ENVIRONMENT}/${e_USER}.json
  Choose File  css=input[type="file"]  ${t_path}
  Input Text  css=#json-password-box  ${KEYSTORE_PW}
  Click Element  css=.new-account-create-form__button:nth-of-type(2)
  Wait Until Element Should Be Visible  css=.wallet-view__address

User Has Successfully Imported Wallet To Metamask
  Wait Until Element Should Be Visible  css=.wallet-view__address

Select "${e_NETWORK}" Network
  Wait And Click Element  css=.network-name
  Wait Until Element Should Be Visible  css=.network-droppo
  Click Element  css=.network-droppo li:nth-of-type(5)
  Wait UNtil Element Should Contain  css=.network-name  Private Network

Remove New Tab If Exist
  ${t_tabs}=  Get Window Handles
  ${t_count}=  Get Length  ${t_tabs}
  ${t_isTrue}=  Evaluate  ${t_count}>1
  Run Keyword If  ${t_isTrue}  Run Keywords
  ...  Select Window  new
  ...  AND  Close Window
  ...  AND  Select Window  main

#=========#
#  SETUP  #
#=========#
"${e_USER}" Launches Browser With Plugins
  Launch Browser With Metamask Extension  ${e_USER}
  Setup Metamask Details
  Import "${e_USER}" Wallet To Metamask
  Select "${ENVIRONMENT}" Network
  User Has Successfully Imported Wallet To Metamask
  Remove New Tab If Exist
