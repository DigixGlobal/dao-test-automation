*** Settings ***
Resource  refactored_locators.robot

*** Variables ***
#constants
${SALT_FILE_EXT}  _salt.json
${SALT_JSON_UPLOAD_BTN}  css=#json-upload

#generic
${SNACK_BAR_DIV}  jquery=[data-digix="Snackbar-Container"]
${ROUND_BTN}  button[class*="RoundBtn"]
${GOVERNANCE_SIDENAR_DIV}  jquery=div[class*="IntroContainer"]
${GOVERNANCE_SIDE_PANEL}  ${GOVERNANCE_SIDENAR_DIV}
${NOTE_CONTAINER}  css=div[class*="Notifications"]

#------------------------------------#
# sidebar
${OVERLAY_CLOSE_ICON}  css=[class*="CloseButtonWithHeader"] [kind="close"]
${CLOSE_ICON}  jquery=[class*="CloseButton"] svg
${LOAD_WALLET_SIDEBAR_BUTTON}  ${GOVERNANCE_SIDENAR_DIV} ${ROUND_BTN}
${ADDRESS_INFO_SIDEBAR}  css=[class*="AddressInfo"]
${LOCK_DGD_BTN}  jquery=[class*="style__InnerContainer"] button:eq(1)

#connect wallet Overlay
${CONNECTED_WALLET_OVERLAY}  css=[data-digix="ConnectedWalletComponent"]
${CONNECTED_WALLET_ADDRESS}  css=[data-digix="User-Address"]
${CONNECT_WALLET_LOCKED_DGD_BTN}  css=[data-digx="Connect-Wallet-Locked-DGD"]
${CONNECTED_WALLET_ETH_BALANCE}  css=[data-digix="Wallet-ETH-Balance"]
${CONNECTED_WALLET_ETHUSD}  css=[data-digix="Wallet-EthUsd-Balance"]
${CONNECTED_WALLET_DGD_BALANCE}  css=[data-digix="Wallet-DGD-Balance"]
${CONNECTED_WALLET_DGDUSD}  css=[data-digix="Wallet-DgdUsd-Balance"]

#Locked DGD Overlay
${LOCK_DGD_AMOUNT_FIELD}  css=[data-digix="LockDgdOverlay-DgdAmount"]
${LOCK_DGD_STATUS}  css=[class*="FormNote"] > p
${LOCK_DGD_STAKE_LABEL}  ${LOCK_DGD_STATUS} > strong
${LOCK_WITH_AMOUNT_BTN}  css=[data-digix="LockDgdOverlay-LockDgd"]

# congratulation overlay
${CONGRATULATION_BANNER}  css=div[class*="ConfirmationBox"]
${GET_STARTED_BTN}  ${CONGRATULATION_BANNER} + button

# proposal card Module
${PROPOSAL_CARD}  jquery=[data-digix="Proposal-Card"]
${VIEW_PROJECT_LINK}  a[class*="ProposalLink"]
${PROPOSAL_STATUS_BTN}  [data-digix="Proposal-Status"]
${PROPOSAL_AUTHOR}  [data-digix="Proposal-Author"]
${PROPOSAL_LIKE_BTN}  css=[data-digix="Proposal-Author"]
${PROPOSAL_TITLE}  css=[data-digix="Proposal-Title"]
${PROPOSAL_SHORT_DESC}  css=[data-digix="Proposal-Short-Desc"]
${PROPOSAL_TOTAL_FUNDING}  css=[data-digix="Total-Funding"]
${PROPOSAL_APPROVAL_RATING}  css=[data-digix="Approval-Rating"]
${PROPOSAL_PARTICIPANT_COUNT}  css=[data-digix="Participant-Count"]
${PROPOSAL_MILESTONE_COUNT}  css=[data-digix="Milestone-Count"]
${PROPOSAL_DEADLINE}  css=[data-digix="Proposal-Deadline"]
${PARTICIPATE_BTN}  [data-digix="Participate-Btn"]

# sign proof of control modal
${PROOF_OF_CONTROL_PASSWORD_FIELD}  css=[class*="MessageSigningOverlay"] input[id="name-simple"]