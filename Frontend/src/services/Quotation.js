const Quotation = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "user",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "bool",
				"name": "status",
				"type": "bool"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "holdedCoverID",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "bytes32",
				"name": "reason",
				"type": "bytes32"
			}
		],
		"name": "RefundEvent",
		"type": "event"
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
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_cid",
				"type": "uint256"
			}
		],
		"name": "checkCoverExpired",
		"outputs": [
			{
				"internalType": "bool",
				"name": "expire",
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
				"name": "_cid",
				"type": "uint256"
			}
		],
		"name": "expireCover",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256[]",
				"name": "coverDetails",
				"type": "uint256[]"
			},
			{
				"internalType": "uint16",
				"name": "coverPeriod",
				"type": "uint16"
			},
			{
				"internalType": "bytes4",
				"name": "curr",
				"type": "bytes4"
			},
			{
				"internalType": "address",
				"name": "smaratCA",
				"type": "address"
			}
		],
		"name": "getOrderHash",
		"outputs": [
			{
				"internalType": "bytes32",
				"name": "",
				"type": "bytes32"
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
				"name": "userAdd",
				"type": "address"
			}
		],
		"name": "getRecentHoldedCoverIdStatus",
		"outputs": [
			{
				"internalType": "int256",
				"name": "",
				"type": "int256"
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
				"name": "smartCAdd",
				"type": "address"
			},
			{
				"internalType": "bytes4",
				"name": "coverCurr",
				"type": "bytes4"
			},
			{
				"internalType": "uint256[]",
				"name": "coverDetails",
				"type": "uint256[]"
			},
			{
				"internalType": "uint16",
				"name": "coverPeriod",
				"type": "uint16"
			},
			{
				"internalType": "uint8",
				"name": "_v",
				"type": "uint8"
			},
			{
				"internalType": "bytes32",
				"name": "_r",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "_s",
				"type": "bytes32"
			}
		],
		"name": "initiateMembershipAndCover",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "hash",
				"type": "bytes32"
			},
			{
				"internalType": "uint8",
				"name": "v",
				"type": "uint8"
			},
			{
				"internalType": "bytes32",
				"name": "r",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "s",
				"type": "bytes32"
			}
		],
		"name": "isValidSignature",
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
				"internalType": "address",
				"name": "_add",
				"type": "address"
			},
			{
				"internalType": "bool",
				"name": "status",
				"type": "bool"
			}
		],
		"name": "kycVerdict",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256[]",
				"name": "coverDetails",
				"type": "uint256[]"
			},
			{
				"internalType": "uint16",
				"name": "coverPeriod",
				"type": "uint16"
			},
			{
				"internalType": "bytes4",
				"name": "coverCurr",
				"type": "bytes4"
			},
			{
				"internalType": "address",
				"name": "smartCAdd",
				"type": "address"
			},
			{
				"internalType": "uint8",
				"name": "_v",
				"type": "uint8"
			},
			{
				"internalType": "bytes32",
				"name": "_r",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "_s",
				"type": "bytes32"
			}
		],
		"name": "makeCoverUsingSOTETokens",
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
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_cid",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "removeSAFromCSA",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "sendEther",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "newAdd",
				"type": "address"
			}
		],
		"name": "transferAssetsToNewContract",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address payable",
				"name": "from",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "scAddress",
				"type": "address"
			},
			{
				"internalType": "bytes4",
				"name": "coverCurr",
				"type": "bytes4"
			},
			{
				"internalType": "uint256[]",
				"name": "coverDetails",
				"type": "uint256[]"
			},
			{
				"internalType": "uint16",
				"name": "coverPeriod",
				"type": "uint16"
			},
			{
				"internalType": "uint8",
				"name": "_v",
				"type": "uint8"
			},
			{
				"internalType": "bytes32",
				"name": "_r",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "_s",
				"type": "bytes32"
			}
		],
		"name": "verifyCoverDetails",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256[]",
				"name": "coverDetails",
				"type": "uint256[]"
			},
			{
				"internalType": "uint16",
				"name": "coverPeriod",
				"type": "uint16"
			},
			{
				"internalType": "bytes4",
				"name": "curr",
				"type": "bytes4"
			},
			{
				"internalType": "address",
				"name": "smaratCA",
				"type": "address"
			},
			{
				"internalType": "uint8",
				"name": "_v",
				"type": "uint8"
			},
			{
				"internalType": "bytes32",
				"name": "_r",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "_s",
				"type": "bytes32"
			}
		],
		"name": "verifySign",
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
	}
]
import BaseContract from './BaseContract'

const Quotation_KEY = "Quotation";

class QuotationContract extends BaseContract {
  constructor(vue) {
    super(Quotation_KEY, Quotation, vue);
  }
}
QuotationContract.key = Quotation_KEY;
export default QuotationContract
