const MemberRoles = {
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
						"name": "roleId",
						"type": "uint256"
					},
					{
						"indexed": false,
						"internalType": "bytes32",
						"name": "roleName",
						"type": "bytes32"
					},
					{
						"indexed": false,
						"internalType": "string",
						"name": "roleDescription",
						"type": "string"
					}
				],
				"name": "MemberRole",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "address",
						"name": "previousMember",
						"type": "address"
					},
					{
						"indexed": true,
						"internalType": "address",
						"name": "newMember",
						"type": "address"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "timeStamp",
						"type": "uint256"
					}
				],
				"name": "switchedMembership",
				"type": "event"
			},
			{
				"constant": false,
				"inputs": [
					{
						"internalType": "address[]",
						"name": "abArray",
						"type": "address[]"
					}
				],
				"name": "addInitialABMembers",
				"outputs": [],
				"payable": false,
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"constant": false,
				"inputs": [
					{
						"internalType": "address[]",
						"name": "userArray",
						"type": "address[]"
					},
					{
						"internalType": "uint256[]",
						"name": "tokens",
						"type": "uint256[]"
					}
				],
				"name": "addMembersBeforeLaunch",
				"outputs": [],
				"payable": false,
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"constant": false,
				"inputs": [
					{
						"internalType": "bytes32",
						"name": "_roleName",
						"type": "bytes32"
					},
					{
						"internalType": "string",
						"name": "_roleDescription",
						"type": "string"
					},
					{
						"internalType": "address",
						"name": "_authorized",
						"type": "address"
					}
				],
				"name": "addRole",
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
						"name": "_val",
						"type": "uint256"
					}
				],
				"name": "changeMaxABCount",
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
						"name": "_memberAddress",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "_roleId",
						"type": "uint256"
					}
				],
				"name": "checkRole",
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
				"name": "dAppToken",
				"outputs": [
					{
						"internalType": "contract TokenController",
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
				"name": "getMemberLengthForAllRoles",
				"outputs": [
					{
						"internalType": "uint256[]",
						"name": "totalMembers",
						"type": "uint256[]"
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
				"constant": false,
				"inputs": [
					{
						"internalType": "address payable",
						"name": "_userAddress",
						"type": "address"
					},
					{
						"internalType": "bool",
						"name": "verdict",
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
				"constant": true,
				"inputs": [],
				"name": "launched",
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
				"name": "launchedOn",
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
				"name": "maxABCount",
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
						"name": "_memberRoleId",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "index",
						"type": "uint256"
					}
				],
				"name": "memberAtIndex",
				"outputs": [
					{
						"internalType": "address",
						"name": "",
						"type": "address"
					},
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
						"name": "_firstAB",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "memberAuthority",
						"type": "address"
					}
				],
				"name": "memberRolesInitiate",
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
						"name": "_memberRoleId",
						"type": "uint256"
					}
				],
				"name": "membersLength",
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
				"inputs": [
					{
						"internalType": "uint256",
						"name": "_memberRoleId",
						"type": "uint256"
					}
				],
				"name": "numberOfMembers",
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
						"name": "_userAddress",
						"type": "address"
					}
				],
				"name": "payJoiningFee",
				"outputs": [],
				"payable": true,
				"stateMutability": "payable",
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
						"name": "_newABAddress",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "_removeAB",
						"type": "address"
					}
				],
				"name": "swapABMember",
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
						"name": "_newOwnerAddress",
						"type": "address"
					}
				],
				"name": "swapOwner",
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
						"name": "_add",
						"type": "address"
					}
				],
				"name": "switchMembership",
				"outputs": [],
				"payable": false,
				"stateMutability": "nonpayable",
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
				"constant": true,
				"inputs": [],
				"name": "totalRoles",
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
				"name": "withdrawMembership",
				"outputs": [],
				"payable": false,
				"stateMutability": "nonpayable",
				"type": "function"
			}
		],
		"devdoc": {
			"methods": {
				"addInitialABMembers(address[])": {
					"details": "is used to add initital advisory board members",
					"params": {
						"abArray": "is the list of initial advisory board members"
					}
				},
				"addMembersBeforeLaunch(address[],uint256[])": {
					"details": "to add members before launch",
					"params": {
						"tokens": "is list of tokens minted for each array element",
						"userArray": "is list of addresses of members"
					}
				},
				"addRole(bytes32,string,address)": {
					"details": "Adds new member role",
					"params": {
						"_authorized": "Authorized member against every role id",
						"_roleDescription": "New description hash",
						"_roleName": "New role name"
					}
				},
				"changeDependentContractAddress()": {
					"details": "Iupgradable Interface to update dependent contract address"
				},
				"changeMasterAddress(address)": {
					"details": "to change the master address",
					"params": {
						"_masterAddress": "is the new master address"
					}
				},
				"changeMaxABCount(uint256)": {
					"details": "to change max number of AB members allowed",
					"params": {
						"_val": "is the new value to be set"
					}
				},
				"checkRole(address,uint256)": {
					"details": "Returns true if the given role id is assigned to a member.",
					"params": {
						"_memberAddress": "Address of member",
						"_roleId": "Checks member's authenticity with the roleId. i.e. Returns true if this roleId is assigned to member"
					}
				},
				"getMemberLengthForAllRoles()": {
					"details": "Return total number of members assigned against each role id.",
					"return": "totalMembers Total members in particular role id"
				},
				"isAuthorizedToGovern(address)": {
					"details": "checks if an address is authorized to govern"
				},
				"kycVerdict(address,bool)": {
					"details": "to perform kyc verdict",
					"params": {
						"_userAddress": "whose kyc is being performed",
						"verdict": "of kyc process"
					}
				},
				"memberRolesInitiate(address,address)": {
					"details": "to initiate the member roles",
					"params": {
						"_firstAB": "is the address of the first AB member",
						"memberAuthority": "is the authority (role) of the member"
					}
				},
				"numberOfMembers(uint256)": {
					"details": "Gets all members' length",
					"params": {
						"_memberRoleId": "Member role id"
					},
					"return": "memberRoleData[_memberRoleId].memberCounter Member length"
				},
				"payJoiningFee(address)": {
					"details": "Called by user to pay joining membership fee"
				},
				"swapABMember(address,address)": {
					"details": "to swap advisory board member",
					"params": {
						"_newABAddress": "is address of new AB member",
						"_removeAB": "is advisory board member to be removed"
					}
				},
				"swapOwner(address)": {
					"details": "to swap the owner address",
					"params": {
						"_newOwnerAddress": "is the new owner address"
					}
				},
				"switchMembership(address)": {
					"details": "Called by existed member if wish to switch membership to other address.",
					"params": {
						"_add": "address of user to forward membership."
					}
				},
				"totalRoles()": {
					"details": "Return number of member roles"
				},
				"withdrawMembership()": {
					"details": "Called by existed member if wish to Withdraw membership."
				}
			}
		},
		"userdoc": {
			"methods": {}
		}
	},
	"settings": {
		"compilationTarget": {
			"smart-contracts/RanceAllinone/RANCEALLINONE.sol": "MemberRoles"
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

const MemberRoles_KEY = "MemberRoles";

class MemberRolesContract extends BaseContract {
  constructor(vue) {
    super(MemberRoles_KEY, MemberRoles, vue);
  }
}
MemberRolesContract.key = MemberRoles_KEY;
export default MemberRolesContract