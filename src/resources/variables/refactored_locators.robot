*** Variables ***
# Side Navigation Component
${HAMBURGER_MENU}  css=.bm-burger-button
${HAMBURGER_CLOSE_ICON}  css=.bm-cross-button
${SIDE_MENU_DIV}  css=ul[class*="MenuList"]
${SIDE_NAV_USER_LABEL}  css=[data-digix="Sidebar-DisplayName"]
${SIDE_NAVE_USER_STATUS}  css=[data-digix="Sidebar-UserStatus"]
${HOME_SIDE_MENU_ICON}  css=div[kind="home"]
${WALLET_SIDE_MENU_ICON}  css=div[kind="wallet"]
${PROFILE_SIDE_MENU_ICON}  css=div[kind="profile"]
${HISTORY_SIDE_MENU_ICON}  css=div[kind="history"]
${DAO_TOUR_SIDE_MENU_ICON}  css=div[kind="product"]
${KYC_DASHBOARD_SIDE_MENU_ICON}  css=div[kind="dashboard"]
${ADMIN_SIDE_MENU_ICON}  css=div[kind="user"]
@{LOGGED_OUT_SIDENAV_LIST}
...  ${HOME_SIDE_MENU_ICON}  ${DAO_TOUR_SIDE_MENU_ICON}
@{LOGGED_IN_SIDENAV_LIST}
...  ${WALLET_SIDE_MENU_ICON}  ${PROFILE_SIDE_MENU_ICON}
...  ${HISTORY_SIDE_MENU_ICON}  @{LOGGED_OUT_SIDENAV_LIST}

#Header Component
${GOVERNANCE_MENU}  css=[id="nav-wrap"]
${HEADER_LOCK_DGD_BTN}  css=[data-digix="Header-LockDgd"]
${ADDRESS_LABEL}  css=[data-digix="Header-Address"]
${LOAD_WALLET_BTN}  css=[data-digix="Header-LoadWallet"]

#User Statistics Component (dashboard & profile)
${USER_STATISTIC_DIV}    css=[class*="UserStats"]
${STAT_QUARTER_POINT}     css=[data-digix="Dashboard-Stats-QuarterPoints"]
${STAT_REPUTATION_POINT}  css=[data-digix="Dashboard-Stats-ReputationPoints"]
${STAT_MYSTAKE_POINT}     css=[data-digix="Dashboard-Locked-Stake"]
${STAT_LOCKED_DGD_POINT}  css=[data-digix="Dashboard-Locked-DGD"]
${STAT_MODERATOR_POINT}   css=[data-digix="Dashboard-Mod-QtrPts"]

#Dashboard Filter Component
${GOVERNANCE_FILTER_SECTION}  css=div[class*="FilterWrapper"]
${ALL_TAB}  css=[data-digix="Filter-All-Tab"]
${IDEA_TAB}  css=[data-digix="Filter-Idea-Tab"]
${DRAFT_TAB}  css=[data-digix="Filter-Draft-Tab"]
${PROPOSAL_TAB}  css=[data-digix="Filter-Proposal-Tab"]
${ONGOING_TAB}  css=[data-digix="Filter-OnGoing-Tab"]
${REVIEW_TAB}  css=[data-digix="Filter-Review-Tab"]
${ARCHIVED_TAB}  css=[data-digix="Filter-Archived-Tab"]

# transaction and sign control modal components
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
${METAMASK_NICKNAME}  css=[placeholder="Address Nickname"]

#types of wallet overlay
${WALLET_METAMASK_BTN}  div[kind="metamask"]
${WALLET_LEDGER_BTN}  div[kind="ledger"]
${WALLET_TREZOR_BTN}  div[kind="trezor"]
${WALLET_IMTOKEN_BTN}  div[kind="imtoken"]
${WALLET_JSON_BTN}  div[kind="json"]