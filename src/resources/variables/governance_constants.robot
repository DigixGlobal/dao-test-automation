*** Variables ***
#constants
${SALT_FILE_EXT}  _salt.json
#side-menu
${SIDE_MENU_DIV}  css=ul[class*="MenuList"]
${HOME_SIDE_MENU_ICON}  css=div[kind="home"]
${WALLET_SIDE_MENU_ICON}  css=div[kind="wallet"]
${PROFILE_SIDE_MENU_ICON}  css=div[kind="profile"]
${HISTORY_SIDE_MENU_ICON}  css=div[kind="history"]
${DAO_TOUR_SIDE_MENU_ICON}  css=div[kind="product"]
@{LOGGED_OUT_SIDENAV_LIST}
...  ${HOME_SIDE_MENU_ICON}  ${DAO_TOUR_SIDE_MENU_ICON}
@{LOGGED_IN_SIDENAV_LIST}
...  ${WALLET_SIDE_MENU_ICON}  ${PROFILE_SIDE_MENU_ICON}
...  ${HISTORY_SIDE_MENU_ICON}  @{LOGGED_OUT_SIDENAV_LIST}

# user profile stats
${DASHBOARD_STATS_DIV}    jquery=[class*="timeline"] + [class*="Container"]
${STAT_QUARTER_POINT}     css=[data-digix="Dashboard-Stats-QuarterPoints"]
${STAT_REPUTATION_POINT}  css=[data-digix="Dashboard-Stats-ReputationPoints"]
${STAT_MYSTAKE_POINT}     css=[data-digix="Dashboard-Stats-Stake"]

#generic
${SNACK_BAR_DIV}  jquery=div[class*="SnackbarContainer"]
${ROUND_BTN}  button[class*="RoundBtn"]
${GOVERNANCE_SIDENAR_DIV}  jquery=div[class*="IntroContainer"]
${GOVERNANCE_SIDE_PANEL}  ${GOVERNANCE_SIDENAR_DIV}
#header
${GOVERNANCE_MENU}  css=section[class*="HeaderWrapper"]
${HEADER_LOCK_DGD_BTN}  css=[data-digix="Header-LockDgd"]
${ADDRESS_LABEL}  ${GOVERNANCE_MENU} div[class*="AddressLabel"]
${LOAD_WALLET_BTN}  css=[data-digix="Header-LoadWallet"]

#------------------------------------#
#modal
${GOVERNANCE_MODAL}  jquery=div[role="document"]
${MODAL_ACTIONS}  ${GOVERNANCE_MODAL} > div:last
# import wallet modal
${IMPORT_KEYSTORE_ICON}  css=#alert-dialog-title
${IMPORT_KEYSTORE_UPLOAD_BTN}  ${IMPORT_KEYSTORE_ICON} + div input[type="file"]
${IMPORT_PASSWORD_FIELD}  css=input[id="name-simple"][type="password"]
${UNLOCK_WALLET_BTN}  ${MODAL_ACTIONS} button:eq(1)
# sign message modal
${MESSAGE_SIGNER_FORM}  ${GOVERNANCE_MODAL} form
${SIGN_MESSAGE_BTN}  ${UNLOCK_WALLET_BTN}

#------------------------------------#
# sidebar
${CLOSE_ICON}  jquery=[class*="CloseButton"] svg
${LOAD_WALLET_SIDEBAR_BUTTON}  ${GOVERNANCE_SIDENAR_DIV} ${ROUND_BTN}
${ADDRESS_INFO_SIDEBAR}  css=[class*="AddressInfo"]
${LOCK_DGD_BTN}  jquery=[class*="style__InnerContainer"] button:eq(1)
${LOCK_DGD_AMOUNT_FIELD}  css=[data-digix="LockDgdOverlay-DgdAmount"]
${LOCK_DGD_STATUS}  css=p[class*="StakeCaption"]
${LOCK_DGD_STAKE_LABEL}  css=p[class*="StakeCaption"] strong
${LOCK_WITH_AMOUNT_BTN}  css=[data-digix="LockDgdOverlay-LockDgd"]
${CONGRATULATION_BANNER}  css=div[class*="ConfirmationBox"]
${GET_STARTED_BTN}  ${CONGRATULATION_BANNER} + button
${SALT_JSON_UPLOAD_BTN}  css=#json-upload
${NOTE_CONTAINER}  css=div[class*="NoteContainer"]

#------------------------------------#
# wallet type
${WALLET_METAMASK_BTN}  div[kind="metamask"]
${WALLET_LEDGER_BTN}  div[kind="ledger"]
${WALLET_TREZOR_BTN}  div[kind="trezor"]
${WALLET_IMTOKEN_BTN}  div[kind="imtoken"]
${WALLET_JSON_BTN}  div[kind="json"]

#------------------------------------#
# dashboard filter tabs
${GOVERNANCE_FILTER_SECTION}  jquery=div[class*="FilterWrapper"]
${ALL_TAB}  ${GOVERNANCE_FILTER_SECTION} a:eq(1)
${IDEA_TAB}  ${GOVERNANCE_FILTER_SECTION} a:eq(2)
${DRAFT_TAB}  ${GOVERNANCE_FILTER_SECTION} a:eq(3)
${PROPOSAL_TAB}  ${GOVERNANCE_FILTER_SECTION} a:eq(4)
${ONGOING_TAB}  ${GOVERNANCE_FILTER_SECTION} a:eq(5)
${REVIEW_TAB}  ${GOVERNANCE_FILTER_SECTION} a:eq(6)
${ARCHIVED_TAB}  ${GOVERNANCE_FILTER_SECTION} a:eq(7)

# proposal card container
${PROPOSAL_CARD}  jquery=div[class*="ProposalWrapper"]
${VIEW_PROJECT_LINK}  a[class*="ProposalLink"]
${PROPOSAL_STATUS_BTN}  button[class*="FlatBtn"]
