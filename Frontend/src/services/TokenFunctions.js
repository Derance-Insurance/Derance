const TokenFunctions = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "claimId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "address",
				"name": "addr",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "BurnCATokens",
		"type": "event"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "address",
				"name": "_stakerAddress",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_stakedContractAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_stakedContractIndex",
				"type": "uint256"
			}
		],
		"name": "_deprecated_getStakerUnlockableTokensOnSmartContract",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
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
				"name": "stakerAdd",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "stakedAdd",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "stakerIndex",
				"type": "uint256"
			}
		],
		"name": "_deprecated_unlockableBeforeBurningAndCanBurn",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "canBurn",
				"type": "uint256"
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
				"name": "claimid",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_value",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_of",
				"type": "address"
			}
		],
		"name": "burnCAToken",
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
				"name": "coverId",
				"type": "uint256"
			}
		],
		"name": "burnDepositCN",
		"outputs": [
			{
				"internalType": "bool",
				"name": "success",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "coverId",
				"type": "uint256"
			},
			{
				"internalType": "bytes4",
				"name": "coverCurrency",
				"type": "bytes4"
			},
			{
				"internalType": "uint256",
				"name": "sumAssured",
				"type": "uint256"
			}
		],
		"name": "burnStakedTokens",
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
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "bytes4",
				"name": "",
				"type": "bytes4"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "burnStakerLockedToken",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "changeDependentContractAddress",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "_masterAddress",
				"type": "address"
			}
		],
		"name": "changeMasterAddress",
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
				"name": "coverId",
				"type": "uint256"
			}
		],
		"name": "depositCN",
		"outputs": [
			{
				"internalType": "bool",
				"name": "success",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "address",
				"name": "_stakerAddress",
				"type": "address"
			}
		],
		"name": "deprecated_getStakerAllLockedTokens",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
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
				"name": "_stakerAddress",
				"type": "address"
			}
		],
		"name": "deprecated_getStakerAllUnlockableStakedTokens",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
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
				"name": "stakerAddress",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "stakedContractAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "stakerIndex",
				"type": "uint256"
			}
		],
		"name": "deprecated_getStakerUnlockableTokensOnSmartContract",
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
		"constant": true,
		"inputs": [
			{
				"internalType": "address",
				"name": "_stakedContractAddress",
				"type": "address"
			}
		],
		"name": "deprecated_getTotalStakedTokensOnSmartContract",
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
		"inputs": [
			{
				"internalType": "address",
				"name": "_stakerAddress",
				"type": "address"
			}
		],
		"name": "deprecated_unlockStakerUnlockableTokens",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "_of",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_coverId",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_lockTime",
				"type": "uint256"
			}
		],
		"name": "extendCNEPOff",
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
				"name": "_coverId",
				"type": "uint256"
			}
		],
		"name": "getLockedCNAgainstCover",
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
		"constant": true,
		"inputs": [
			{
				"internalType": "bytes4",
				"name": "curr",
				"type": "bytes4"
			}
		],
		"name": "getTokenPrice",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "price",
				"type": "uint256"
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
				"name": "_of",
				"type": "address"
			}
		],
		"name": "getUserAllLockedCNTokens",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
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
				"name": "_of",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_coverId",
				"type": "uint256"
			}
		],
		"name": "getUserLockedCNTokens",
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
		"constant": true,
		"inputs": [
			{
				"internalType": "address",
				"name": "_of",
				"type": "address"
			}
		],
		"name": "isLockedForMemberVote",
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
				"name": "coverNoteAmount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "coverPeriod",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "coverId",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_of",
				"type": "address"
			}
		],
		"name": "lockCN",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "ms",
		"outputs": [
			{
				"internalType": "contract IRANCEMaster",
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
				"internalType": "address",
				"name": "_contractAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_coverPriceRANCE",
				"type": "uint256"
			}
		],
		"name": "pushStakerRewards",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "ranceMasterAddress",
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
		"name": "tk",
		"outputs": [
			{
				"internalType": "contract RANCEToken",
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
				"name": "coverId",
				"type": "uint256"
			}
		],
		"name": "unlockCN",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	}
]
import BaseContract from './BaseContract'

const TokenFunctions_KEY = "TokenFunctions";

class TokenFunctionsContract extends BaseContract {
  constructor(vue) {
    super(TokenFunctions_KEY, TokenFunctions, vue);
  }
}
TokenFunctionsContract.key = TokenFunctions_KEY;
export default TokenFunctionsContract
