[
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "bool",
				"name": "_pause",
				"type": "bool"
			},
			{
				"internalType": "bytes4",
				"name": "_by",
				"type": "bytes4"
			}
		],
		"name": "addEmergencyPause",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "bytes2",
				"name": "_contractName",
				"type": "bytes2"
			},
			{
				"internalType": "address payable",
				"name": "_contractAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_type",
				"type": "uint256"
			}
		],
		"name": "addNewInternalContract",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address payable[]",
				"name": "_contractAddresses",
				"type": "address[]"
			}
		],
		"name": "addNewVersion",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint8",
				"name": "start",
				"type": "uint8"
			},
			{
				"internalType": "uint8",
				"name": "end",
				"type": "uint8"
			}
		],
		"name": "changeAllAddress",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
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
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_claimId",
				"type": "uint256"
			}
		],
		"name": "closeClaim",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "contractsActive",
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
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "emergencyPaused",
		"outputs": [
			{
				"internalType": "bool",
				"name": "pause",
				"type": "bool"
			},
			{
				"internalType": "uint256",
				"name": "time",
				"type": "uint256"
			},
			{
				"internalType": "bytes4",
				"name": "by",
				"type": "bytes4"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getEmergencyPausedLength",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "len",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getLastEmergencyPause",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_pause",
				"type": "bool"
			},
			{
				"internalType": "uint256",
				"name": "_time",
				"type": "uint256"
			},
			{
				"internalType": "bytes4",
				"name": "_by",
				"type": "bytes4"
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
				"internalType": "bytes8",
				"name": "code",
				"type": "bytes8"
			}
		],
		"name": "getOwnerParameters",
		"outputs": [
			{
				"internalType": "bytes8",
				"name": "codeVal",
				"type": "bytes8"
			},
			{
				"internalType": "address",
				"name": "val",
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
		"name": "getVersionData",
		"outputs": [
			{
				"internalType": "bytes2[]",
				"name": "contractsName",
				"type": "bytes2[]"
			},
			{
				"internalType": "address[]",
				"name": "contractsAddress",
				"type": "address[]"
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
				"internalType": "address",
				"name": "_tokenAdd",
				"type": "address"
			},
			{
				"internalType": "address payable",
				"name": "_govAdd",
				"type": "address"
			}
		],
		"name": "initiateMaster",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "address",
				"name": "_toCheck",
				"type": "address"
			}
		],
		"name": "isAuthorizedToGovern",
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
				"name": "_contractAddress",
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
				"name": "_address",
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
				"internalType": "bytes2",
				"name": "",
				"type": "bytes2"
			}
		],
		"name": "isProxy",
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
				"internalType": "bytes2",
				"name": "",
				"type": "bytes2"
			}
		],
		"name": "isUpgradable",
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
		"name": "masterAddress",
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
		"name": "owner",
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
		"constant": true,
		"inputs": [],
		"name": "pauseTime",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "startEmergencyPause",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
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
				"internalType": "bytes8",
				"name": "code",
				"type": "bytes8"
			},
			{
				"internalType": "address payable",
				"name": "val",
				"type": "address"
			}
		],
		"name": "updateOwnerParameters",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
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
	},
	{
		"constant": false,
		"inputs": [],
		"name": "upgradeAllAddress",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "bytes2",
				"name": "_contractsName",
				"type": "bytes2"
			},
			{
				"internalType": "address payable",
				"name": "_contractsAddress",
				"type": "address"
			}
		],
		"name": "upgradeContract",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "bytes2[]",
				"name": "_contractsName",
				"type": "bytes2[]"
			},
			{
				"internalType": "address payable[]",
				"name": "_contractsAddress",
				"type": "address[]"
			}
		],
		"name": "upgradeMultipleContracts",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "bytes2[]",
				"name": "_contractNames",
				"type": "bytes2[]"
			},
			{
				"internalType": "address[]",
				"name": "_contractAddresses",
				"type": "address[]"
			}
		],
		"name": "upgradeMultipleImplementations",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	}
]
import BaseContract from './BaseContract'

const NXMaster_KEY = "NXMaster";

class NXMasterContract extends BaseContract {
  constructor(vue) {
    super(NXMaster_KEY, NXMaster, vue);
  }
}
NXMasterContract.key = NXMaster_KEY;
export default NXMasterContract
