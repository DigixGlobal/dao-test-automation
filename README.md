# Digix Automation Guideline

*Installation guide is located at https://github.com/DigixGlobal/digix-automation*

### Pre-requisite before running the script on local machine

#### Update `development.config.js` file on `info-server` directory
- set `BLOCK_CONFIRMATIONS` to `0`


#### Update `.env` file on `dao-contracts` directory

```
FIRST_TEST=true
QUARTER_DURATION=6000000000
LOCKING_PHASE=30
DRAFT_VOTING_PHASE=20
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

|       Test Suite       |   Tags                           |                                                          Description                                                                  |
| ---------------------- | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| DAOGovernanceETest     | smoke, regression, endtoend      | This suite will test end to end process of creating proposals until marking proposal to complete                                      |
| DaoCommentModuleTest   | smoke, regression                | This suite will test end to end process of posting comments on newly created proposal                                                 |
| DaoLikeModuleTest      | smoke, regression                | This suite will test like/unlike module for proposal and comments                                                                     |
| DaoProfileOverviewTest | smoke, regression                | This suite will test asserting values on Profile Overview are correct and validate components are showing correcly based on user role | 
| DaoSideNavMenuTest     | smoke, regression                | This suite will test assert side nav menu list when a user is in logged in and logged out state. (DGDG-284)                           | 
| DaoEditProposalTest    | sanity, regression               | This suite will test editing of proposal and validate the edited details on Proposal View Page                                        |
| DaoClaimRewardTest     | sanity, regression, NotForKOVAN  | This suite will test claiming rewards on Wallet Page                                                                                  |
| DaoRedeemBadgeTest     | sanity, regression, NotForKOVAN  | This suite will test redeeming badge on Profile View Page                                                                             |  

### Local Environmenet Keystore Reference

| Default FileName  | Replaced Into Username On Automation |                   Address                  |
| ----------------- | ------------------------------------ | ------------------------------------------ |
| account4          | rewardee                             | 0x9f244f9316426030bca51baf35a4541422ab4f76 |
| account7          | moderator                            | 0x508221f68118d1eaa631d261aca3f2fccc6ecf91 |
| account8          | proposer                             | 0x519774b813dd6de58554219f16c6aa8350b8ec99 |
| account9          | nonBadgeHolder                       | 0xca731a9a354be04b8ebfcd9e429f85f48113d403 |
| account10         | badgeHolder                          | 0x1a4d420bff04e68fb76096ec3cbe981f509c3341 |
| account12         | participant                          | 0xad127e217086779bc0a03b75adee5f5d729aa4eb |

