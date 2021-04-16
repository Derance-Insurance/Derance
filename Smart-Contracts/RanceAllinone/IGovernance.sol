pragma solidity ^0.5.17;

contract IGovernance { 

    event Proposal(
        address indexed proposalOwner,
        uint256 indexed proposalId,
        uint256 dateAdd,
        string proposalTitle,
        string proposalSD,
        string proposalDescHash
    );

    event Solution(
        uint256 indexed proposalId,
        address indexed solutionOwner,
        uint256 indexed solutionId,
        string solutionDescHash,
        uint256 dateAdd
    );

    event Vote(
        address indexed from,
        uint256 indexed proposalId,
        uint256 indexed voteId,
        uint256 dateAdd,
        uint256 solutionChosen
    );

    event RewardClaimed(
        address indexed member,
        uint gbtReward
    );

    /// @dev VoteCast event is called whenever a vote is cast that can potentially close the proposal. 
    event VoteCast (uint256 proposalId);

    /// @dev ProposalAccepted event is called when a proposal is accepted so that a server can listen that can 
    ///      call any offchain actions
    event ProposalAccepted (uint256 proposalId);

    /// @dev CloseProposalOnTime event is called whenever a proposal is created or updated to close it on time.
    event CloseProposalOnTime (
        uint256 indexed proposalId,
        uint256 time
    );

    /// @dev ActionSuccess event is called whenever an onchain action is executed.
    event ActionSuccess (
        uint256 proposalId
    );

}