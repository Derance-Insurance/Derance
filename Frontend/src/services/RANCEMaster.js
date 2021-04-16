
const  RANCEMaster  = {
	"deploy": {
		"VM:-": {
			"linkReferences": {},
			"autoDeployLib": true
		},
		"main:1": {
			"linkReferences": {},
			"autoDeployLib": true
		},
		"ropsten:3": {
			"linkReferences": {},
			"autoDeployLib": true
		},
		"rinkeby:4": {
			"linkReferences": {},
			"autoDeployLib": true
		},
		"kovan:42": {
			"linkReferences": {},
			"autoDeployLib": true
		},
		"görli:5": {
			"linkReferences": {},
			"autoDeployLib": true
		},
		"Custom": {
			"linkReferences": {},
			"autoDeployLib": true
		}
	},
	"data": {
		"bytecode": {
			"linkReferences": {},
			"object": "",
			"opcodes": "",
			"sourceMap": ""
		},
		"deployedBytecode": {
			"linkReferences": {},
			"object": "",
			"opcodes": "",
			"sourceMap": ""
		},
		"gasEstimates": null,
		"methodIdentifiers": {
			"checkIsAuthToGoverned(address)": "5834e67a",
			"dAppLocker()": "3a12507f",
			"dAppToken()": "eaf2c477",
			"delegateCallBack(bytes32)": "8dd7ff9a",
			"getLatestAddress(bytes2)": "01382858",
			"isInternal(address)": "8f16c41c",
			"isMember(address)": "a230c524",
			"isOwner(address)": "2f54bf6e",
			"isPause()": "ff0938a7",
			"masterInitialized()": "c15041d5",
			"tokenAddress()": "9d76ea58",
			"updatePauseTime(uint256)": "78ddbed4"
		}
	},
	"abi": [
		{
			"constant": true,
			"inputs": [
				{
					"internalType": "address",
					"name": "_add",
					"type": "address"
				}
			],
			"name": "checkIsAuthToGoverned",
			"outputs": [
				{
					"internalType": "bool",
					"name": "",
					"type": "bool"
				}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
		},
		{
			"constant": true,
			"inputs": [],
			"name": "dAppLocker",
			"outputs": [
				{
					"internalType": "address",
					"name": "_add",
					"type": "address"
				}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
		},
		{
			"constant": true,
			"inputs": [],
			"name": "dAppToken",
			"outputs": [
				{
					"internalType": "address",
					"name": "_add",
					"type": "address"
				}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
		},
		{
			"constant": false,
			"inputs": [
				{
					"internalType": "bytes32",
					"name": "myid",
					"type": "bytes32"
				}
			],
			"name": "delegateCallBack",
			"outputs": [],
			"payable": false,
			"stateMutability": "nonpayable",
			"type": "function"
		},
		{
			"constant": true,
			"inputs": [
				{
					"internalType": "bytes2",
					"name": "_contractName",
					"type": "bytes2"
				}
			],
			"name": "getLatestAddress",
			"outputs": [
				{
					"internalType": "address payable",
					"name": "contractAddress",
					"type": "address"
				}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
		},
		{
			"constant": true,
			"inputs": [
				{
					"internalType": "address",
					"name": "_add",
					"type": "address"
				}
			],
			"name": "isInternal",
			"outputs": [
				{
					"internalType": "bool",
					"name": "",
					"type": "bool"
				}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
		},
		{
			"constant": true,
			"inputs": [
				{
					"internalType": "address",
					"name": "_add",
					"type": "address"
				}
			],
			"name": "isMember",
			"outputs": [
				{
					"internalType": "bool",
					"name": "",
					"type": "bool"
				}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
		},
		{
			"constant": true,
			"inputs": [
				{
					"internalType": "address",
					"name": "_add",
					"type": "address"
				}
			],
			"name": "isOwner",
			"outputs": [
				{
					"internalType": "bool",
					"name": "",
					"type": "bool"
				}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
		},
		{
			"constant": true,
			"inputs": [],
			"name": "isPause",
			"outputs": [
				{
					"internalType": "bool",
					"name": "check",
					"type": "bool"
				}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
		},
		{
			"constant": true,
			"inputs": [],
			"name": "masterInitialized",
			"outputs": [
				{
					"internalType": "bool",
					"name": "",
					"type": "bool"
				}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
		},
		{
			"constant": true,
			"inputs": [],
			"name": "tokenAddress",
			"outputs": [
				{
					"internalType": "address",
					"name": "",
					"type": "address"
				}
			],
			"payable": false,
			"stateMutability": "view",
			"type": "function"
		},
		{
			"constant": false,
			"inputs": [
				{
					"internalType": "uint256",
					"name": "_time",
					"type": "uint256"
				}
			],
			"name": "updatePauseTime",
			"outputs": [],
			"payable": false,
			"stateMutability": "nonpayable",
			"type": "function"
		}
	]
}
import BaseContract from './BaseContract'

const RANCEMaster_KEY = "RANCEMaster";

class RANCEMasterContract extends BaseContract {
  constructor(vue) {
    super(RANCEMaster_KEY, RANCEMaster, vue);
  }
}
RANCEMasterContract.key = RANCEMaster_KEY;
export default RANCEMasterContract
