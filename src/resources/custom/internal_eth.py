from web3 import Web3, HTTPProvider, IPCProvider
import json

HTTP_PROVIDER_ADDRESS = 'http://localhost:8545'
PASSWORD = 'digixdao'

def load_erc20_token(address, abi):
    web3 = Web3(HTTPProvider(HTTP_PROVIDER_ADDRESS))
    CHECKSUM_CONTRACT = web3.toChecksumAddress(address)
    ERC20_ABI = json.loads(abi)
    erc20 = web3.eth.contract(address=CHECKSUM_CONTRACT, abi=ERC20_ABI)
    return erc20

def create_new_wallet_via_web3(environment):
    web3 = Web3(HTTPProvider(HTTP_PROVIDER_ADDRESS))
    acct = web3.eth.account.create(PASSWORD)
    json = web3.eth.account.encrypt(acct.privateKey,PASSWORD)
    return json

def transfer_to_account(erc20,address_to,token_type,value):
    web3 = Web3(HTTPProvider(HTTP_PROVIDER_ADDRESS)) 
    _from = web3.eth.coinbase
    _to = web3.toChecksumAddress(address_to)
    if token_type == 'funds':
        amount = int(value) * 1e9
    elif token_type == 'badge':
        amount = value
    erc20.functions.transfer(_to, int(amount)).transact({'from': _from})
    trans = {'from':_from, 'to':_to, 'value': web3.toWei(value, 'ether')}
    tx_hash= web3.eth.sendTransaction(trans)
    return (_to,tx_hash)
