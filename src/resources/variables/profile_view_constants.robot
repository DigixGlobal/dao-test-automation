*** Variables ***
${PROFILE_ROLE_DIV}           css=[data-digix="Profile-Status"]
${PROFILE_REWARD_DIV}         jquery=[class*="RewardSummary"]
${PROFILE_QUARTER_AMOUNT}     css=[data-digix="Profile-QuarterPoints"]
${PROFILE_REPUTATION_AMOUNT}  css=[data-digix="Profile-ReputationPoints"]
${PROFILE_STAKE_AMOUNT}       css=[data-digix="Profile-Stake"]
${PROFILE_MODERATOR_CARD}     css=[data-digix="Profile-ModerationRequirements"]
${PROFILE_REMAINING_REPUTATION}  css=[data-digix="Profile-ModerationRequirements-Reputation"]
${PROFILE_REMAINING_STAKE}    css=[data-digix="Profile-ModerationRequirements-Stake"]
${PROFILE_REDEEM_BADGE_BTN}  css=[data-digix="redeemBadgeButton"]

#constants
${LOCAL_MIN_STAKE_PTS}    100
${KOVAN_MIN_STAKE_PTS}    1000
${LOCAL_MIN_REPUTATION_PTS}  1
${KOVAN_MIN_REPUTATION_PTS}  ${EMPTY}
