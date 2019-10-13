# DigixDao Test Automation Guideline

### UBUNTU SETUP

*How to install robotframework on UBUNTU*
1. Download Python 3.6.x (on termainal: execute this: `sudo apt install python3.6`)
2. Install pip (see instruction on https://pip.pypa.io/en/stable/installing/)
3. Install robotframework dependencies:

|      Library       |                         Command                                             |
| ------------------ | --------------------------------------------------------------------------- |
| robotframework     | pip install robotframework                                                  |
| selenium2library   | pip install robotframework-selenium2library                                 |
| seleniumlibrary    | pip install robotframework-seleniumlibrary==3.3.1                           |
| jsonpointer        | pip install jsonpointer                                                     |
| jsonpatch          | pip install jsonpatch                                                       |
| web3               | pip install web3                                                            |
| custom imaplibrary | pip install git+git://github.com/mikegeorgejimenez/imaplibrary-python36.git |


*Install ChromeDriver on UBUNTU*
1. Download latest chromedriver (http://chromedriver.chromium.org/downloads)
2. Open Terminal
3. Execute this commands:
```sh
$ cd ~/Downloads
$ unzip ~/Downloads/<chromdriver_filename>
$ chmod +x ~/Downloads/chromedriver
$ sudo mv -f ~/Downloads/chromedriver /usr/local/share/chromedriver
$ sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
$ export PATH="${PATH}:~/usr/local/bin/chromedriver"
```


### REQUIRED ENVIRONMENT VARIABLES 
1. Locate your core2 contracts  `(e.g. /Users/userAccount/core2/build/contracts)`
```sh 
$ cd <repoPath>/core2/build/contracts/
$ pwd  
$ echo "export BUILD_CONTRACT_PATH='$(pwd)'" >> ~/.bashrc
$ source ~/.bashrc
```


### PRE-REQUISITE BEFORE RUNNING THE SCRIPTS ON LOCAL MACHINE
* Update `development.config.js` file on `info-server` directory*
```sh
- set `BLOCK_CONFIRMATIONS` to `0`
- set `CRON_PROCESS_KYC_FREQUENCY` to `1`
```

* Update `.env` file on `dao-contracts` directory*
```sh
FIRST_TEST=true
QUARTER_DURATION=600000
LOCKING_PHASE=60
FORCED_LOCKING_PHASE=90
DRAFT_VOTING_PHASE=40
VOTING_ROUND=260
COMMIT_ROUND=130
VOTE_CLAIMING_DEADLINE=260
IPFS_ENDPOINT=http://localhost:5001
HTTP_ENDPOINT=http://localhost:9001/ipfs
```


#### How To Run Scripts
* Running against local environment *
- pybot -i <tag/test_suite> --variable ENVIRONMENT:LOCAL --exitonfailure .
```sh
pybot -i DaoOneMilestoneETest --variable ENVIRONMENT:LOCAL --exitonfailure .
```

* Running against kovan environment *
- pybot -i <tag/test_suite> --variable ENVIRONMENT:KOVAN --exitonfailure .
```sh
pybot -i DaoOneMilestoneETest --variable ENVIRONMENT:KOVAN --exitonfailure .
```


### Existing Test Coverage

|       Test Suite               |   Tags                           |                                                          Description                                                                    |
| ------------------------------ | -------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------  |
| DaoOneMilestoneETest           | smoke, regression, endtoend      | This suite will test end to end process of creating proposals until setting the proposal to archive via Json Wallet as Entry Point (1MS)|
| DaoTwoMilestonesETest          | smoke, regression, endtoend      | This suite will test end to end process of creating proposals until setting the proposal to archive via Json Wallet as Entry Point (2MS)|
| DaoMetamaskWalletETest         | smoke, regression, endtoend      | This suite will test end to end process of creating proposals until setting the proposal to archive via Metamask Wallet as Entry Point  |
| DaoKYCETest                    | smoke, regression, endtoend      | This suite will test end to end process from submitting user's KYC Details up to rejecting and approving it using KYC Officer account   |
| ForumAdminETest                | smoke, regression, endtoend      | This suite will test end to end process of posting comments, hide/unhide comment, and banning/unbanning users from commenting           |
| DaoSpecialProposalTest         | smoke, regression,               | This suite will test commiting and revealing votes for special proposals                                                                |
| DaoNoLimitFundingTest          | smoke, regression,               | This suite will test posting a project using founder/account3 wallet without funding limit                                              |
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
| account3          | badgeHolder / founder                | 0xda89b1b5835290da6cf1085e1f02d8600074e35d |  
| account4          | rewardee                             | 0x9f244f9316426030bca51baf35a4541422ab4f76 |
| account7          | moderator                            | 0x508221f68118d1eaa631d261aca3f2fccc6ecf91 |
| account8          | proposer                             | 0x519774b813dd6de58554219f16c6aa8350b8ec99 |
| account9          | nonBadgeHolder                       | 0xca731a9a354be04b8ebfcd9e429f85f48113d403 |
| account10         | badgeHolderNotOnContract             | 0x1a4d420bff04e68fb76096ec3cbe981f509c3341 |  
| account11         | nonKYCUser                           | 0x11AD4D13BcCa312E83EEC8f961ADA76c41c0ef09 |
| account12         | participant                          | 0xad127e217086779bc0a03b75adee5f5d729aa4eb |
| account15         | forumAdmin                           | 0x52a9d38687a0c2d5e1645f91733ffab3bbd29b06 |

### Contributing
Refer [CONTRIBUTING.md](./CONTRIBUTING.md) for the process for submitting pull requests to us.

### [License](./LICENSE.md)
Copyright DIGIXGLOBAL PRIVATE LIMITED.

The code in this repository is licensed under the [BSD-3 Clause](https://opensource.org/licenses/BSD-3-Clause) BSD-3-clause, 2017.
