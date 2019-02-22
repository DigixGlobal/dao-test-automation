from eth_account import Account
from web3.auto.infura import w3
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

def create_new_wallet(environment):
    web3 = Web3(HTTPProvider(HTTP_PROVIDER_ADDRESS))
    acct = web3.eth.account.create(PASSWORD)
    json = web3.eth.account.encrypt(acct.privateKey,PASSWORD)
    return json

def create_json_wallet(content):
    file = open("newWallet.json", "a")
    file.write(json.dumps(content))

def transfer_funds_to_account(erc20 , address):
    web3 = Web3(HTTPProvider(HTTP_PROVIDER_ADDRESS)) 
    address_convert = web3.toChecksumAddress(address)
    erc20.functions.transfer(address_convert,int(10e9)).transact({'from': web3.eth.coinbase})
    trans = {'from':web3.eth.coinbase, 'to':address_convert, 'value': web3.toWei(10, 'ether')}
    trx= web3.eth.sendTransaction(trans)
    return (address_convert,int(10e9),trx)
