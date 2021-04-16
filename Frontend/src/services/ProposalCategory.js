const ProposalCategory = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "categoryId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "categoryName",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "actionHash",
				"type": "string"
			}
		],
		"name": "Category",
		"type": "event"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "string",
				"name": "_name",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_memberRoleToVote",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_majorityVotePerc",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_quorumPerc",
				"type": "uint256"
			},
			{
				"internalType": "uint256[]",
				"name": "_allowedToCreateProposal",
				"type": "uint256[]"
			},
			{
				"internalType": "uint256",
				"name": "_closingTime",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_actionHash",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "_contractAddress",
				"type": "address"
			},
			{
				"internalType": "bytes2",
				"name": "_contractName",
				"type": "bytes2"
			},
			{
				"internalType": "uint256[]",
				"name": "_incentives",
				"type": "uint256[]"
			}
		],
		"name": "addCategory",
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
				"name": "_categoryId",
				"type": "uint256"
			}
		],
		"name": "category",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "uint256[]",
				"name": "",
				"type": "uint256[]"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
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
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "categoryABReq",
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
				"internalType": "uint256",
				"name": "_categoryId",
				"type": "uint256"
			}
		],
		"name": "categoryAction",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "bytes2",
				"name": "",
				"type": "bytes2"
			},
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
				"internalType": "uint256",
				"name": "_categoryId",
				"type": "uint256"
			}
		],
		"name": "categoryActionDetails",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "bytes2",
				"name": "",
				"type": "bytes2"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "bytes",
				"name": "",
				"type": "bytes"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "categoryActionHashUpdated",
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
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "categoryActionHashes",
		"outputs": [
			{
				"internalType": "bytes",
				"name": "",
				"type": "bytes"
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
				"internalType": "uint256",
				"name": "_categoryId",
				"type": "uint256"
			}
		],
		"name": "categoryExtendedData",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
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
		"inputs": [],
		"name": "constructorCheck",
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
				"name": "_categoryId",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_name",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_memberRoleToVote",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_majorityVotePerc",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_quorumPerc",
				"type": "uint256"
			},
			{
				"internalType": "uint256[]",
				"name": "_allowedToCreateProposal",
				"type": "uint256[]"
			},
			{
				"internalType": "uint256",
				"name": "_closingTime",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_actionHash",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "_contractAddress",
				"type": "address"
			},
			{
				"internalType": "bytes2",
				"name": "_contractName",
				"type": "bytes2"
			},
			{
				"internalType": "uint256[]",
				"name": "_incentives",
				"type": "uint256[]"
			},
			{
				"internalType": "string",
				"name": "_functionHash",
				"type": "string"
			}
		],
		"name": "editCategory",
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
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "isSpecialResolution",
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
				"internalType": "string",
				"name": "_name",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_memberRoleToVote",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_majorityVotePerc",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_quorumPerc",
				"type": "uint256"
			},
			{
				"internalType": "uint256[]",
				"name": "_allowedToCreateProposal",
				"type": "uint256[]"
			},
			{
				"internalType": "uint256",
				"name": "_closingTime",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_actionHash",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "_contractAddress",
				"type": "address"
			},
			{
				"internalType": "bytes2",
				"name": "_contractName",
				"type": "bytes2"
			},
			{
				"internalType": "uint256[]",
				"name": "_incentives",
				"type": "uint256[]"
			},
			{
				"internalType": "string",
				"name": "_functionHash",
				"type": "string"
			}
		],
		"name": "newCategory",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "proposalCategoryInitiate",
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
		"name": "totalCategories",
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
		"name": "updateCategoryActionHashes",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	}
]
import BaseContract from './BaseContract'

const ProposalCategory_KEY = "ProposalCategory";

class ProposalCategoryContract extends BaseContract {
  constructor(vue) {
    super(ProposalCategory_KEY, ProposalCategory, vue);
  }
}
ProposalCategoryContract.key = ProposalCategory_KEY;
export default ProposalCategoryContract
