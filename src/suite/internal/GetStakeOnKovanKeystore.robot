*** Settings ***
Documentation  This suite will get all keystore
Default Tags  GetStakeOnKovanKeystore
Resource  ../../resources/common/web_helper.robot

*** Variables ***
${KEYSTORE_PATH}  ~/Downloads/digixdao-kovan/
${INFO_URL}  https://info.digixdev.com/address
${FILE_NAME}  kovanStake.csv
*** Test Cases ***
Get Address On File
  @{t_keys}=  List Directory  ${KEYSTORE_PATH}
  ${t_path}=  Normalize Path  ${KEYSTORE_PATH}
  Delete File If Exist
  Create File  ${EXECDIR}/${FILE_NAME}  Filename,Address,lockedDgdStake
  :For  ${key}  IN   @{t_keys}
  \  ${t_content}=  Load json From File  ${t_path}/${key}
  \  ${t_value}=  Get Value From Json  ${t_content}  address
  \  ${t_address}=  Set Variable  0x${t_value}
  \  ${t_notFound}=  find_value_on_json_url  ${INFO_URL}/${t_address}  /result
  \  ${t_stake}=  Run Keyword If  "${t_notFound}"!="notFound"
  ...  find_value_on_json_url  ${INFO_URL}/${t_address}  /result/lockedDgdStake
  ...  ELSE  Set Variable  Record Not Found
  \  Append To File  ${EXECDIR}/${FILE_NAME}  ${\n}"${key}","${t_address}", "${t_stake}"

*** Keywords ***
Delete File If Exist
  ${t_exist}=  Run Keyword And Return Status
  ...  File Should Exist  ${CURDIR}/${FILE_NAME}
  Run Keyword If  ${t_exist}
  ...  Remove File  ${EXECDIR}/${FILE_NAME}
