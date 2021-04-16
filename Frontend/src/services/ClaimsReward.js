const ClaimsReward = {
	"compiler": {
		"version": "0.5.17+commit.d19bba13"
	},
	"language": "Solidity",
	"output": {
		"abi": [
			{
				"constant": false,
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_records",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "_user",
						"type": "address"
					}
				],
				"name": "_claimStakeCommission",
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
						"name": "claimid",
						"type": "uint256"
					}
				],
				"name": "changeClaimStatus",
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
						"name": "records",
						"type": "uint256"
					}
				],
				"name": "claimAllPendingReward",
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
						"name": "records",
						"type": "uint256"
					}
				],
				"name": "claimPendingReward",
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
				"name": "getAllPendingRewardOfUser",
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
						"name": "_add",
						"type": "address"
					}
				],
				"name": "getPendingRewardOfUser",
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
						"name": "check",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "claimId",
						"type": "uint256"
					}
				],
				"name": "getRewardAndClaimedStatus",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "reward",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "claimed",
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
				"name": "getRewardToBeDistributedByUser",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "total",
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
						"name": "check",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "voteid",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "flag",
						"type": "uint256"
					}
				],
				"name": "getRewardToBeGiven",
				"outputs": [
					{
						"internalType": "uint256",
						"name": "tokenCalculated",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "lastClaimedCheck",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "tokens",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "perc",
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
						"internalType": "address",
						"name": "_newAdd",
						"type": "address"
					}
				],
				"name": "upgrade",
				"outputs": [],
				"payable": false,
				"stateMutability": "nonpayable",
				"type": "function"
			}
		],
		"devdoc": {
			"methods": {
				"_claimStakeCommission(uint256,address)": {
					"details": "Function used to claim the commission earned by the staker."
				},
				"changeClaimStatus(uint256)": {
					"details": "Decides the next course of action for a given claim."
				},
				"changeMasterAddress(address)": {
					"details": "change master address",
					"params": {
						"_masterAddress": "is the new address"
					}
				},
				"claimAllPendingReward(uint256)": {
					"details": "Function used to claim all pending rewards : Claims Assessment + Risk Assessment + Governance Claim assesment, Risk assesment, Governance rewards"
				},
				"claimPendingReward(uint256)": {
					"details": "Function used to claim all pending rewards : Claims Assessment + Risk Assessment Claim assesment, Risk assesment"
				},
				"getAllPendingRewardOfUser(address)": {
					"details": "Function used to get pending rewards of a particular user address.",
					"params": {
						"_add": "user address."
					},
					"return": "total reward amount of the user"
				},
				"getPendingRewardOfUser(address)": {
					"details": "Function used to get pending rewards of a particular user address.",
					"params": {
						"_add": "user address."
					},
					"return": "total reward amount of the user"
				},
				"getRewardAndClaimedStatus(uint256,uint256)": {
					"details": "Gets reward amount and claiming status for a given claim id.",
					"return": "reward amount of tokens to user.claimed true if already claimed false if yet to be claimed."
				},
				"getRewardToBeDistributedByUser(address)": {
					"details": "Total reward in token due for claim by a user.",
					"return": "total total number of tokens"
				},
				"getRewardToBeGiven(uint256,uint256,uint256)": {
					"details": "Amount of tokens to be rewarded to a user for a particular vote id.",
					"params": {
						"check": "1 -> CA vote, else member vote",
						"flag": "if 1 calculate even if claimed,else don't calculate if already claimed",
						"voteid": "vote id for which reward has to be Calculated"
					},
					"return": "tokenCalculated reward to be given for vote idlastClaimedCheck true if final verdict is still pending for that voteidtokens number of tokens locked under that voteidperc percentage of reward to be given."
				},
				"upgrade(address)": {
					"details": "Transfers all tokens held by contract to a new contract in case of upgrade."
				}
			}
		},
		"userdoc": {
			"methods": {}
		}
	},
	"settings": {
		"compilationTarget": {
			"smart-contracts/RanceAllinone/RANCEALLINONE.sol": "ClaimsReward"
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

const ClaimsReward_KEY = "ClaimsReward";

class ClaimsRewardContract extends BaseContract {
  constructor(vue) {
    super(ClaimsReward_KEY, ClaimsReward, vue);
  }
}
ClaimsRewardContract.key = ClaimsReward_KEY;
export default ClaimsRewardContract
