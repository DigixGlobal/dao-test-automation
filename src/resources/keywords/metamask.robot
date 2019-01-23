*** Variables ***
${PHRASE}  harbor oak enter vessel morning adult stick proof stock bus work goat
${METAMASK_PW}  digixtest
${KEYSTORE_PW}  digixdao

*** Keywords ***
Launch Browser With Metamask Extension
  [Arguments]  ${p_alias}=${ALIAS}  ${p_browser}=Chrome
  ${chrome_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()    sys
  Should Exist  ${CURDIR}/../../resources/testdata/etc/unload.crx
  Call Method  ${chrome_options}  add_extension  ${CURDIR}/../../resources/testdata/etc/unload.crx
  Create Webdriver    ${p_browser}    ${p_alias}    chrome_options=${chrome_options}
  Set Selenium Speed For "${ENVIRONMENT}" Environment
  Set Timeout Dependent On Environment
  Sleep  5 seconds

Setup Metamask Details
  Select Window  new
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

#=========#
#  SETUP  #
#=========#
"${e_USER}" Launches Browser With Plugins
  Launch Browser With Metamask Extension  ${e_USER}
  Setup Metamask Details
  Import "${e_USER}" Wallet To Metamask
  Select "${ENVIRONMENT}" Network
  User Has Successfully Imported Wallet To Metamask
  Close Window