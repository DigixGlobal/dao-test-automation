*** Variables ***
@{WALLET_PAGE_ELEMENT_LIST}
...  ${WALLET_ADDRESS_DIV}  ${WALLET_STAKE_AMOUNT}
...  ${WALLET_REWARD_AMOUNT}  ${WALLET_ETH_AMOUNT}
${WALLET_ADDRESS_DIV}  css=[data-digix="Wallet-Address"]
${WALLET_STAKE_AMOUNT}  css=[data-digix="Wallet-Stake"]
${WALLET_LOCKED_DGD_BTN}  css=[data-digix="Wallet-LockDgd"]
${WALLET_UNLOCKED_DGD_BTN}  css=[data-digix="Wallet-UnlockDgd"]
${WALLET_CLAIM_REWARD_BTN}  css=[data-digix="Wallet-ClaimReward"]
${WALLET_REWARD_AMOUNT}  css=[data-digix="Wallet-DGXReward"]
${WALLET_ETH_AMOUNT}  css=[data-digix="Wallet-EthFund"]

#unlock overlay
${OVERLAY_CLOSE_BTN}  jquery=[class*="DrawerContainer"] [kind="close"]
${WALLET_DGD_AMOUNT_LABEL}  css=[data-digix="UnlockDgd-MaxAmount"]
${WALLET_UNLOCK_AMOUNT_FIELD}  css=[data-digix="UnlockDgd-Amount"]
${WALLET_FILL_AMOUNT_LINK}  css=[data-digix="UnlockDgd-FillAmount"]
${WALLET_INLINE_MSG_DIV}  css=[class*="DrawerContainer"] [class*="Hint"]
${WALLET_REMAINING_UNLOCK_AMOUNT_LABEL}  css=[data-digix="UnlockDgd-RemainingDgd"]
${WALLET_MAX_ERROR_AMOUNT}  css=[data-digx="UnlockDgd-Error-MaxAmount"]
${WALLET_UNLOCKED_BTN}  css=[data-digix="UnlockDgd-Cta"]
