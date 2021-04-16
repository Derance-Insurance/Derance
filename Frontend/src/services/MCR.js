const MCR = {
	"compiler": {
		"version": "0.5.17+commit.d19bba13"
	},
	"language": "Solidity",
	"output": {
		"abi": [
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "blockNumber",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "bytes4[]",
						"name": "allCurr",
						"type": "bytes4[]"
					},
					{
						"indexed": false,
						"internalType": "uint256[]",
						"name": "allCurrRates",
						"type": "uint256[]"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "mcrEtherx100",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "mcrPercx100",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "vFull",
						"type": "uint256"
					}
				],
				"name": "MCREvent",
				"type": "event"
			},
			{
				"constant": true,
				"inputs": [
					{
						"internalType": "uint256",
						"name": "poolBalance",
						"type": "uint256"
					}
				],
				"name": "_calVtpAndMCRtp",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "vtp",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "mcrtp",
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
						"internalType": "uint64",
						"name": "date",
						"type": "uint64"
					}
				],
				"name": "addLastMCRData",
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
						"name": "mcrP",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "mcrE",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "vF",
						"type": "uint256"
					},
					{
						"internalType": "bytes4[]",
						"name": "curr",
						"type": "bytes4[]"
					},
					{
						"internalType": "uint256[]",
						"name": "_threeDayAvg",
						"type": "uint256[]"
					},
					{
						"internalType": "uint64",
						"name": "onlyDate",
						"type": "uint64"
					}
				],
				"name": "addMCRData",
				"outputs": [],
				"payable": false,
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"constant": true,
				"inputs": [],
				"name": "calVtpAndMCRtp",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "vtp",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "mcrtp",
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
					},
					{
						"internalType": "uint256",
						"name": "mcrtp",
						"type": "uint256"
					}
				],
				"name": "calculateStepTokenPrice",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "tokenPrice",
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
				"name": "calculateTokenPrice",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "tokenPrice",
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
						"name": "poolBalance",
						"type": "uint256"
					}
				],
				"name": "calculateVtpAndMCRtp",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "vtp",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "mcrtp",
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
				"name": "dynamicMincapIncrementx100",
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
				"name": "dynamicMincapThresholdx100",
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
				"name": "getAllSumAssurance",
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
				"inputs": [],
				"name": "getMaxSellTokens",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "maxTokens",
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
						"name": "vtp",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "vF",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "totalSA",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "minCap",
						"type": "uint256"
					}
				],
				"name": "getThresholdValues",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "lowerThreshold",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "upperThreshold",
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
						"internalType": "bytes8",
						"name": "code",
						"type": "bytes8"
					}
				],
				"name": "getUintParameters",
				"outputs": [
					{
						"internalType": "bytes8",
						"name": "codeVal",
						"type": "bytes8"
					},
					{
						"internalType": "uint256",
						"name": "val",
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
						"internalType": "bytes8",
						"name": "code",
						"type": "bytes8"
					},
					{
						"internalType": "uint256",
						"name": "val",
						"type": "uint256"
					}
				],
				"name": "updateUintParameters",
				"outputs": [],
				"payable": false,
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"constant": true,
				"inputs": [],
				"name": "variableMincap",
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
			}
		],
		"devdoc": {
			"methods": {
				"_calVtpAndMCRtp(uint256)": {
					"details": "Calculates V(Tp) and MCR%(Tp), i.e, Pool Fund Value in Ether  and MCR% used in the Token Price Calculation.",
					"return": "vtp  Pool Fund Value in Ether used for the Token Price Modelmcrtp MCR% used in the Token Price Model. "
				},
				"addLastMCRData(uint64)": {
					"details": "Adds MCR Data for last failed attempt."
				},
				"addMCRData(uint256,uint256,uint256,bytes4[],uint256[],uint64)": {
					"details": "Adds new MCR data.",
					"params": {
						"mcrP": "Minimum Capital Requirement in percentage.",
						"onlyDate": "Date(yyyymmdd) at which MCR details are getting added.",
						"vF": "Pool1 fund value in Ether used in the last full daily calculation of the Capital model."
					}
				},
				"calculateStepTokenPrice(bytes4,uint256)": {
					"details": "Calculates the Token Price of RANCE in a given currency.",
					"params": {
						"curr": "Currency name."
					}
				},
				"calculateTokenPrice(bytes4)": {
					"details": "Calculates the Token Price of RANCE in a given currency with provided token supply for dynamic token price calculation",
					"params": {
						"curr": "Currency name."
					}
				},
				"changeDependentContractAddress()": {
					"details": "Iupgradable Interface to update dependent contract address"
				},
				"changeMasterAddress(address)": {
					"details": "change master address",
					"params": {
						"_masterAddress": "is the new address"
					}
				},
				"getAllSumAssurance()": {
					"details": "Gets total sum assured(in BNB).",
					"return": "amount of sum assured"
				},
				"getMaxSellTokens()": {
					"details": "Gets max numbers of tokens that can be sold at the moment."
				},
				"getUintParameters(bytes8)": {
					"details": "Gets Uint Parameters of a code",
					"params": {
						"code": "whose details we want"
					},
					"return": "string value of the codeassociated amount (time or perc or value) to the code"
				},
				"updateUintParameters(bytes8,uint256)": {
					"details": "Updates Uint Parameters of a code",
					"params": {
						"code": "whose details we want to update",
						"val": "value to set"
					}
				}
			}
		},
		"userdoc": {
			"methods": {}
		}
	},
	"settings": {
		"compilationTarget": {
			"smart-contracts/RanceAllinone/RANCEALLINONE.sol": "MCR"
		},
		"evmVersion": "istanbul",
		"libraries": {},
		"optimizer": {
			"enabled": false,
			"runs": 200
		},
		"remappings": []
	},
	"sources": {
		"smart-contracts/RanceAllinone/ClaimsData.sol": {
			"keccak256": "0xdba552e23a41088c4eda1a03d655fca0ebf39c1edaec048ce5e9010da8e15645",
			"urls": [
				"bzz-raw://3fb5b3ea4f796065137f87cb9a8dd5e9f26398e6116bd35f7233fd8c86dc9bfc",
				"dweb:/ipfs/Qmf8Qtjr4CvVJbtU9kXYjRWXqTEPSFs86ntxUewwsLyU2s"
			]
		},
		"smart-contracts/RanceAllinone/Exchange.sol": {
			"keccak256": "0xeba162c55c6230f6fb74979a325071ec8d5dcbb09f527de800404fc67891c900",
			"urls": [
				"bzz-raw://759adae385364eae22eb8ad98c6949b20f64c400fb4ad8bd5362befa77d2730a",
				"dweb:/ipfs/QmTAmXzuzNJnAuLzp934o3t69a9ezfjkc2Mjrp5zfy8JKR"
			]
		},
		"smart-contracts/RanceAllinone/Governed.sol": {
			"keccak256": "0xa20d86513de99ac557606605a37f916dc28a3cf460d1e67efe83a47f7503e217",
			"urls": [
				"bzz-raw://e124a5bfcce8b52fa2e6edf244f4a94f474979fc785bd6edc76d132776e3b397",
				"dweb:/ipfs/QmWJsaNqu8yTj14ThMAdBvgiQHGjMYQiJtX8ZvYdiL1a7m"
			]
		},
		"smart-contracts/RanceAllinone/IGovernance.sol": {
			"keccak256": "0xa4ec7afe288f35d462f1d2e4847d6b5936ca1f4d56ef07e8e5b9f8783d1a37b5",
			"urls": [
				"bzz-raw://f45b19df4da05c6c4007fb8e17c937805ffc92c510804775e70482bf21e16a54",
				"dweb:/ipfs/QmabW91qCewgBCZtVqkXu2DszYV7tbUcHti9TSVy1gHcjL"
			]
		},
		"smart-contracts/RanceAllinone/IPooledStaking.sol": {
			"keccak256": "0x22606cab2261a33ab394c7e5bd5f7d08bf66ac0dccc31f5edec5a55ade38ee01",
			"urls": [
				"bzz-raw://4afa1ba2385a9b141248ce96f33688881402c5a462030fe56d5c3a6f15bfc8c2",
				"dweb:/ipfs/QmdqEzXMTGoFi6WnpKH9oc3tjrz3nycFE4WaJRbvxHfYzB"
			]
		},
		"smart-contracts/RanceAllinone/Iupgradable.sol": {
			"keccak256": "0x93007ec6323f2e0fd2efcb45271f62c06aae18717c25a6fb90c7536710afb4f5",
			"urls": [
				"bzz-raw://574c473dc14b743f82ea231edb17a0ccfa14462f1ecbc8a37375fd6b9190ccf6",
				"dweb:/ipfs/QmUVdxakgrWqYZ9cL47xDuro9RSWx3yPwFpHVsi97mWyLx"
			]
		},
		"smart-contracts/RanceAllinone/PoolData.sol": {
			"keccak256": "0xed01461537ccd0e648710d6d9beab1c8dde5b0d932612f0fb69ea36c8a8f5cd4",
			"urls": [
				"bzz-raw://c3f9735422485d2ea83963e5477da90175830e4ee349049cb233b90b90a47165",
				"dweb:/ipfs/QmQudyf4qWhcKB39pgrxZPxvT6ium8mgAN6EkL2uZcC3f9"
			]
		},
		"smart-contracts/RanceAllinone/QuotationData.sol": {
			"keccak256": "0x1016e5074f5f273c99e90fb7107e62f660c9756f74e30637cbe707796f6f5903",
			"urls": [
				"bzz-raw://497eae87c45fd13b942de773a9754b2801b84f7c0b95ed2525a9916ff1f12276",
				"dweb:/ipfs/QmU8gc5azygFT427JaRbXaqNg9cksFZbT7FZLd8doUEGQo"
			]
		},
		"smart-contracts/RanceAllinone/RANCEALLINONE.sol": {
			"keccak256": "0x3a78cd63ba23b671a27091083f7e47c5227e2db8d3790454e8a6a35e9d4188f4",
			"urls": [
				"bzz-raw://c8e3e24316cf08c63a3e594dc99313959b626788e51cb080e6bc88b8ad520358",
				"dweb:/ipfs/Qmf2DiDTrFiU6RF6bJoKRpeqz859MrFgN7A8WZ4tjYbwCC"
			]
		},
		"smart-contracts/RanceAllinone/RANCEToken.sol": {
			"keccak256": "0x85818bc4d7bb3b10ef8b030afe7d4b0360695fc1eac23627f5031c365f66bb57",
			"urls": [
				"bzz-raw://7cd8958d119e4a240f08e6048a86b012a96343d35e8d01541041b87a45fb62f1",
				"dweb:/ipfs/QmZEtEUzR38UsyjRasmyLv3PCKhkGXcaJeSTxJxfE3MeYi"
			]
		},
		"smart-contracts/RanceAllinone/SafeMath.sol": {
			"keccak256": "0xee44674f2070d498a290ecc25ae266650aad8e340c3c6f8be4e38d3c1bd61077",
			"urls": [
				"bzz-raw://e66d846117e2341c77d31d1dc83af5cd2995d2ca0cbc904bf1fe9044cb660d83",
				"dweb:/ipfs/QmZh5YMyaHYF9gzKGURqG8gQLjZaj4o2XdpYwfHVyDg1Ym"
			]
		},
		"smart-contracts/RanceAllinone/TokenController.sol": {
			"keccak256": "0x8b55a1a8f1108a5b504553d9da6560f16c801ba7c30250342adaf594945fd4e2",
			"urls": [
				"bzz-raw://8056451dc2773f480268669bfa09f24ce102deff94749242f5f357557f4c8fce",
				"dweb:/ipfs/QmdHkaaNdwZy9Aj2SpgANLXr5XaASH96XhBiMVuU6b9gnJ"
			]
		},
		"smart-contracts/RanceAllinone/TokenData.sol": {
			"keccak256": "0xb9fed21e1be269acbf622355859d486acb352801e680bbead1f9f4ec1083115d",
			"urls": [
				"bzz-raw://343f297642f35aa8cc345a6e9fcd6096b4b377ede618d43725a6bffa8850c404",
				"dweb:/ipfs/QmW4Qa6AUWY64B2GJ6kTvNPLUFe6LFJ6v89pcH4h2pGdE4"
			]
		}
	},
	"version": 1
}
import BaseContract from './BaseContract'

const MCR_KEY = "MCR";

class MCRContract extends BaseContract {
  constructor(vue) {
    super(MCR_KEY, MCR, vue);
  }
}
MCRContract.key = MCR_KEY;
export default MCRContract

