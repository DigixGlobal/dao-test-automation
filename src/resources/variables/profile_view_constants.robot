*** Variables ***
${PROFILE_ROLE_DIV}           css=[data-digix="Profile-Status"]
${PROFILE_REWARD_DIV}         css=[class*="UserStats"]
${PROFILE_QUARTER_AMOUNT}     css=[data-digix="Profile-QuarterPoints"]
${PROFILE_REPUTATION_AMOUNT}  css=[data-digix="Profile-ReputationPoints"]
${PROFILE_STAKE_AMOUNT}       css=[data-digix="Profile-Stake"]
${PROFILE_MODERATOR_CARD}     css=[data-digix="Profile-ModerationRequirements"]
${PROFILE_REMAINING_REPUTATION}  css=[data-digix="Profile-ModerationRequirements-Reputation"]
${PROFILE_REMAINING_STAKE}    css=[data-digix="Profile-ModerationRequirements-Stake"]
${PROFILE_REDEEM_BADGE_BTN}  css=[data-digix="redeemBadgeButton"]
${PROFILE_SET_EMAIL_KYC_BTN}  css=[data-digix="Profile-KycStatus-SetEmail"]
${PROFILE_SUBMIT_KYC_BTN}  css=[data-digix="Profile-KycStatus-Submit"]

#overlay
${BADGE_APPROVE_INTERACTION_BTN}  css=[data-digix="Approve-Interaction"]

${PROFILE_USERNAME_DIV}  css=[data-digix="Profile-UserName"]
${PROFILE_SET_USERNAME_BTN}  css=[data-digix="Profile-UserName-Cta"]
${PROFILE_SET_USERNAME_FIELD}  css=[data-digix="SetUsername-TexBox"]
${PROFILE_CHANGE_USERNAME_BTN}  css=[data-digix="UsernameOverlay-SetUsername"]

${PROFILE_EMAIL_DIV}  css=[data-digix="Profile-Email"]
${PROFILE_SET_EMAIL_BTN}  css=[data-digix="Profile-Email-Cta"]
${PROFILE_SET_EMAIL_FIELD}   css=[data-digix="SetEmail-Textbox"]
${PROFILE_CHANGE_EMAIL_BTN}  css=[data-digix="EmailOverlay-SetEmail"]

${PROFILE_ERROR_DIV}  jquery=[class*="Hint"]
#constants
${LOCAL_MIN_STAKE_PTS}    100
${KOVAN_MIN_STAKE_PTS}    1000
${LOCAL_MIN_REPUTATION_PTS}  1
${KOVAN_MIN_REPUTATION_PTS}  ${EMPTY}

#error messages
${INVALID_USERNAME}  Username must be between 2-20 characters
${INVALID_EMAIL}  Please enter a valid email address.
${INVALID_USERNAME_EXIST}  Username has already been taken
${INVALID_EMAIL_EXIST}  Email has already been taken

#snackbar messages
${APPROVE_INTERACTION}  Badge Redemption Approved
