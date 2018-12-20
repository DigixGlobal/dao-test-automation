*** Variables ***
#generic
${SNACK_BAR_DIV}  css=div[class*="SnackbarContainer"]
${ROUND_BTN}  button[class*="RoundBtn"]
${TIMER_DIV}  css=div[class*="style__QuorumInfoCol"]
${GOVERNANCE_MENU}  css=section[class*="style__HeaderWrapper"]
${GOVERNANCE_SIDENAR_DIV}  jquery=div[class*="style__WalletContainer"]
${GOVERNANCE_BTN}  button[class*="style__RoundBtn"]
${GOVERNANCE_MODAL}  jquery=div[class*="MuiPaper-root"]
${GOVERNANCE_SIDE_PANEL}  jquery=div[class*="style__PanelContainer"]
#header
${ADDRESS_LABEL}  ${GOVERNANCE_MENU} div[class*="style__AddressLabel"]
#modal
${MODAL_ACTIONS}  jquery=div[class*="MuiDialogActions-root"]
# sidebar
${LOAD_WALLET_BTN}  ${GOVERNANCE_MENU} ${GOVERNANCE_BTN}
${LOAD_WALLET_SIDEBAR_BUTTON}  ${GOVERNANCE_SIDENAR_DIV} ${GOVERNANCE_BTN}
${ADDRESS_INFO_SIDEBAR}  css=h5[class*="style__AddressInfo"]
${LOCK_DGD_BTN}  ${LOAD_WALLET_SIDEBAR_BUTTON}:eq(1)
${LOCK_DGD_AMOUNT_FIELD}  css=div[class*="style__InputDgxBox"] input[type="number"]
${LOCK_WITH_AMOUNT_BTN}  css=div[class*="style__InputDgxBox"] ~ button
${CONGRATULATION_BANNER}  css=div[class*="style__ConfirmationBox"]
${GET_STARTED_BTN}  ${CONGRATULATION_BANNER} + button
${SALT_JSON_UPLOAD_BTN}  css=#json-upload
${NOTE_CONTAINER}  css=div[class*="NoteContainer"]
# wallet type
${WALLET_METAMASK_BTN}  div[kind="metamask"]
${WALLET_LEDGER_BTN}  div[kind="ledger"]
${WALLET_TREZOR_BTN}  div[kind="trezor"]
${WALLET_IMTOKEN_BTN}  div[kind="imtoken"]
${WALLET_JSON_BTN}  div[kind="json"]
# import wallet modal
${IMPORT_KEYSTORE_ICON}  svg[class*="ImportKeystore-walletIcon"]
${IMPORT_KEYSTORE_FORM}  div[class*="ImportKeystoreForm"]
${IMPORT_KEYSTORE_UPLOAD_BTN}  ${IMPORT_KEYSTORE_FORM} input[type="file"]
${IMPORT_PASSWORD_FIELD}  css=input[id="name-simple"][type="password"]
${UNLOCK_WALLET_BTN}  ${MODAL_ACTIONS} button:eq(1)
# sign message modal
${MESSAGE_SIGNER_FORM}  ${GOVERNANCE_MODAL} form[class*="V3KestoreMessageSigner"]
${SIGN_MESSAGE_BTN}  ${UNLOCK_WALLET_BTN}
#---------------------------#
#governance body
${GOVERNANCE_BODY}  jquery=div[class*="style__ContentWrapper"]
${GOVERNANCE_FILTER_SECTION}  jquery=div[class*="style__FilterWrapper"]
${GOVERNANCE_CREATE_BTN}  css=a[href="#/proposals/create"] button
${CREATE_NOW_BTN}  ${PROPOSAL_MENU_NEXT_BTN}
${PROPOSAL_SUBMIT_BTN}  ${GOVERNANCE_BODY} button:eq(1)
# filter tabs
${ALL_TAB}  ${GOVERNANCE_FILTER_SECTION} a:eq(1)
${IDEA_TAB}  ${GOVERNANCE_FILTER_SECTION} a:eq(2)
${DRAFT_TAB}  ${GOVERNANCE_FILTER_SECTION} a:eq(3)
${PROPOSAL_TAB}  ${GOVERNANCE_FILTER_SECTION} a:eq(4)
${ONGOING_TAB}  ${GOVERNANCE_FILTER_SECTION} a:eq(5)
${REVIEW_TAB}  ${GOVERNANCE_FILTER_SECTION} a:eq(6)
${ARCHIVED_TAB}  ${GOVERNANCE_FILTER_SECTION} a:eq(7)
# proposal container
${PROPOSAL_CARD}  jquery=div[class*="ProposalWrapper"]
${VIEW_PROJECT_LINK}  a[class*="style__ProposalLink"]
${PROPOSAL_STATUS_BTN}  button[class*="FlatBtn"]
${PARTICIPATE_BTN}  button[class*="RoundBtn"]
# create proposal fields
${PROPOSAL_TAB_PANEL}  jquery=div[class*="TabPanel"]
${PROPOSAL_MENU}  ${PROPOSAL_TAB_PANEL} +  [class*="Header"] > div:eq(1)
${PROPOSAL_MENU_PREVIEW_BTN}  ${PROPOSAL_MENU} button:eq(0)
${PROPOSAL_MENU_PREVIOUS_BTN}  ${PROPOSAL_MENU} button:eq(1)
${PROPOSAL_MENU_NEXT_BTN}  ${PROPOSAL_MENU} button:eq(2)
${PROJECT_TITLE_FIELD}  css=input[id="title"]
${PROJECT_DESC_FIELD}  css=textarea[id="description"]
${PROJECT_INFO_FIELD}  css=#details .ql-editor
${UPLOAD_IMAGE_BTN}  css=[class*="style__UploadButton"]
${IMAGE_UPLOAD_BTN}  css=input[id="image-upload"][type="file"]
${REWARD_FIELD}  css=input[id="finalReward"]
${NUM_OF_MILESTONE_FIELD}  css=select[id="noOfMilestones"]
${MILESTONE_FORM}  jquery=div[class*="CreateMilestone"]
${MILESTONE_FIELD}  ${MILESTONE_FORM} input
${MILESTONE_DESC_FIELD}  ${MILESTONE_FORM} textarea
# proposal
${PROJECT_SUMMARY}  jquery=div[class*="style__ProjectSummary"]
