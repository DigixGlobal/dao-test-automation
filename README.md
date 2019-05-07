# Digix Automation Guideline

*Installation guide is located at https://github.com/DigixGlobal/digix-automation*

### Pre-requisite before running the script on local machine

#### Update `development.config.js` file on `info-server` directory
- set `BLOCK_CONFIRMATIONS` to `0`
- set `CRON_PROCESS_KYC_FREQUENCY` to `1`

#### Update `.env` file on `dao-contracts` directory

```
FIRST_TEST=true
QUARTER_DURATION=6000000000
LOCKING_PHASE=30
FORCED_LOCKING_PHASE=10000
DRAFT_VOTING_PHASE=40
VOTING_ROUND=260
COMMIT_ROUND=130
VOTE_CLAIMING_DEADLINE=260
IPFS_ENDPOINT=http://localhost:5001
HTTP_ENDPOINT=http://localhost:9001/ipfs
```


#### How To Run Scripts
*Running against local environment*
- `pybot -i <tag> --variable ENVIRONMENT:LOCAL --exitonfailure .`

*Running against kovan environment*
- `pybot -i <tag> --variable ENVIRONMENT:KOVAN --exitonfailure .`


### Existing Test Coverage

|       Test Suite               |   Tags                           |                                                          Description                                                                    |
| ------------------------------ | -------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------  |
| DaoOneMilestoneETest           | smoke, regression, endtoend      | This suite will test end to end process of creating proposals until setting the proposal to archive via Json Wallet as Entry Point (1MS)|
| DaoTwoMilestonesETest          | smoke, regression, endtoend      | This suite will test end to end process of creating proposals until setting the proposal to archive via Json Wallet as Entry Point (2MS)|
| DaoMetamaskWalletETest         | smoke, regression, endtoend      | This suite will test end to end process of creating proposals until setting the proposal to archive via Metamask Wallet as Entry Point  |
| DaoKYCETest                    | smoke, regression, endtoend      | This suite will test end to end process from submitting user's KYC Details up to rejecting and approving it using KYC Officer account   |
| ForumAdminETest                | smoke, regression, endtoend      | This suite will test end to end process of posting comments, hide/unhide comment, and banning/unbanning users from commenting           |
| DaoSpecialProposalTest         | smoke, regression,               | This suite will test commiting and revealing votes for special proposals                                                                |
| DaoCreateProposalMetamaskTest  | smoke, regression                | This suite will test creating of proposal using metamask as Entry Point                                                                 |
| DaoCreateWalletRedeemBageTest  | smoke, regression                | This suite will test enabling new user to interact to DigixDao with funds until redeeming of badge on profile page                      |
| DaoAddDocsClaimFailedTest      | smoke, regression                | This suite will test adding of additional documents after project status is finalized and claiming it as failed project                 |
| DaoCreateEditPreviewAbortTest  | smoke, regression                | This suite will test creating,and editing proposals also included preview function                                                      |
| DaoLikeModuleTest              | smoke, regression                | This suite will test like/unlike module for proposal and comments                                                                       |
| DaoCommentModuleTest           | smoke, regression                | This suite will test end to end process of posting comments on newly created proposal                                                   |
| DaoProfileOverviewTest         | smoke, regression                | This suite will test asserting values on Profile Overview are correct and validate components are showing correcly based on user role   | 
| DaoSideNavMenuTest             | smoke, regression                | This suite will test assert side nav menu list when a user is in logged in and logged out state. (DGDG-284)                             | 
| DaoKYCSubmissionTest           | smoke, regression                | This suite will submitting of KYC Details for nonKYC user.                                                                              |
| DaoKYCAdminTest                | smoke, regression                | This suite will test approving and rejecting KYC using KYC Admin Account                                                                |
| DaoCreateNewWalletTest         | smoke, regression                | This suite will test enabling new user to interact to DigixDao with funds via web3 wallet creation                                      |
| DaoChangeFundingTest           | sanity, regression               | This suite will test changing of funding then go to the next phase after edit.                                                          |
| DaoSetUsernameEmailTest        | sanity, regression, NotForKOVAN  | This suite will test setting up username and email on Profile view page                                                                 |
| DaoClaimRewardTest             | sanity, regression, NotForKOVAN  | This suite will test claiming rewards on Wallet Page                                                                                    |
| DaoRedeemBadgeTest             | sanity, regression, NotForKOVAN  | This suite will test redeeming badge on Profile View Page                                                                               |
| DAOUnlockDGDTest               | sanity, regression, NotForKOVAN  | This suite will test locking and unlocking DGD at Wallet Page on locking phase.                                                         |


### Local Environmenet Keystore Reference

| Default FileName  | Replaced Into Username On Automation |                   Address                  |
| ----------------- | ------------------------------------ | ------------------------------------------ |
| account2          | kycOfficer                           | 0x97BE8FF9065cE5F3d562CB6b458cdE88c8307Edf |
| account3          | badgeHolder                          | 0xda89b1b5835290da6cf1085e1f02d8600074e35d |  
| account4          | rewardee                             | 0x9f244f9316426030bca51baf35a4541422ab4f76 |
| account7          | moderator                            | 0x508221f68118d1eaa631d261aca3f2fccc6ecf91 |
| account8          | proposer                             | 0x519774b813dd6de58554219f16c6aa8350b8ec99 |
| account9          | nonBadgeHolder                       | 0xca731a9a354be04b8ebfcd9e429f85f48113d403 |
| account10         | badgeHolderNotOnContract             | 0x1a4d420bff04e68fb76096ec3cbe981f509c3341 |  
| account11         | nonKYCUser                           | 0x11AD4D13BcCa312E83EEC8f961ADA76c41c0ef09 |
| account12         | participant                          | 0xad127e217086779bc0a03b75adee5f5d729aa4eb |

