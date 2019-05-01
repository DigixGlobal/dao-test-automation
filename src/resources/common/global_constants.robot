*** Variables ***
${PASSWORD}    digixtest
${WALLET_PASSWORD}  ${PASSWORD}
${LOCAL_DAO_WALLET_PW}  digixdao
${KOVAN_DAO_WALLET_PW}  digixdao-kovan
${SHORT_TIMEOUT}    5x
${SHORT_INTERVAL}    5s
${LONG_TIMEOUT}  6x
${LONG_INTERVAL}  10s
${TIMEOUT_SEC}  20 seconds
${LONG_TIMEOUT_SEC}  60 seconds
${WALLET}  json
${proposer}  proposer
${moderator}  moderator
${participant}  participant

#test values
${KEYSTORE_PATH}  ../testdata/keystores
${LOCKED_DGD_AMOUNT}  1
${MILESTONE_REWARD_AMOUNT}  2
${NUMBER_OF_MILESTONE}  1
${MILESTONE_AMOUNT}  5