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
VOTING_ROUND=200
COMMIT_ROUND=100
VOTE_CLAIMING_DEADLINE=60000
IPFS_ENDPOINT=http://localhost:5001
HTTP_ENDPOINT=http://localhost:9001/ipfs
```


#### How To Run Scripts
*Running against local environment*
- `pybot -i <tag> --variable ENVIRONMENT:LOCAL --exitonfailure .`

*Running against kovan environment*
- `pybot -i <tag> --variable ENVIRONMENT:KOVAN --exitonfailure .`


### Existing Test Coverage

|       Test Suite     |                                              Coverage                                              |
| -------------------- | -------------------------------------------------------------------------------------------------- |
| DAOGovernanceETest   | This suite will test end to end process of creating proposals until marking proposal to complete   |
| DaoCommentModuleTest | This suite will test end to end process of posting comments on newly created proposal              |