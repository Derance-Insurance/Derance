pragma solidity ^0.5.17;


contract IProposalCategory {

    event Category(
        uint indexed categoryId,
        string categoryName,
        string actionHash
    );

    /// @dev Adds new category
    /// @param _name Category name
    /// @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
    /// @param _allowedToCreateProposal Member roles allowed to create the proposal
    /// @param _majorityVotePerc Majority Vote threshold for Each voting layer
    /// @param _quorumPerc minimum threshold percentage required in voting to calculate result
    /// @param _closingTime Vote closing time for Each voting layer
    /// @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
    /// @param _contractAddress address of contract to call after proposal is accepted
    /// @param _contractName name of contract to be called after proposal is accepted
    /// @param _incentives rewards to distributed after proposal is accepted

    function addCategory(
        string calldata _name, 
        uint _memberRoleToVote,
        uint _majorityVotePerc, 
        uint _quorumPerc, 
        uint[] calldata _allowedToCreateProposal,
        uint _closingTime,
        string calldata _actionHash,
        address _contractAddress,
        bytes2 _contractName,
        uint[] calldata _incentives
    ) 
        external;

    /// @dev gets category details
    function category(uint _categoryId)
        external
        view
        returns(
            uint categoryId,
            uint memberRoleToVote,
            uint majorityVotePerc,
            uint quorumPerc,
            uint[] memory allowedToCreateProposal,
            uint closingTime,
            uint minStake
        );
    
    ///@dev gets category action details
    function categoryAction(uint _categoryId)
        external
        view
        returns(
            uint categoryId,
            address contractAddress,
            bytes2 contractName,
            uint defaultIncentive
        );
    
    /// @dev Gets Total number of categories added till now
    function totalCategories() external view returns(uint numberOfCategories);

    /// @dev Updates category details
    /// @param _categoryId Category id that needs to be updated
    /// @param _name Category name
    /// @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
    /// @param _allowedToCreateProposal Member roles allowed to create the proposal
    /// @param _majorityVotePerc Majority Vote threshold for Each voting layer
    /// @param _quorumPerc minimum threshold percentage required in voting to calculate result
    /// @param _closingTime Vote closing time for Each voting layer
    /// @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
    /// @param _contractAddress address of contract to call after proposal is accepted
    /// @param _contractName name of contract to be called after proposal is accepted
    /// @param _incentives rewards to distributed after proposal is accepted
    function updateCategory(
        uint _categoryId, 
        string memory _name, 
        uint _memberRoleToVote, 
        uint _majorityVotePerc, 
        uint _quorumPerc,
        uint[] memory _allowedToCreateProposal,
        uint _closingTime,
        string memory _actionHash,
        address _contractAddress,
        bytes2 _contractName,
        uint[] memory _incentives
    )
        internal;

}

/* Copyright (C) 2017 GovBlocks.io
  This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
  This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
  You should have received a copy of the GNU General Public License
    along with this program.  If not, see http://www.gnu.org/licenses/ */
    


interface IPooledStaking {

    function accumulateReward(address contractAddress, uint amount) external;
    function pushBurn(address contractAddress, uint amount) external;
    function hasPendingActions() external view returns (bool);

    function contractStake(address contractAddress) external view returns (uint);
    function stakerReward(address staker) external view returns (uint);
    function stakerDeposit(address staker) external view returns (uint);
    function stakerContractStake(address staker, address contractAddress) external view returns (uint);

    function withdraw(uint amount) external;
    function stakerMaxWithdrawable(address stakerAddress) external view returns (uint);
    function withdrawReward(address stakerAddress) external;
}

contract IMemberRoles {

    event MemberRole(uint256 indexed roleId, bytes32 roleName, string roleDescription);
    
    /// @dev Adds new member role
    /// @param _roleName New role name
    /// @param _roleDescription New description hash
    /// @param _authorized Authorized member against every role id
    function addRole(bytes32 _roleName, string memory _roleDescription, address _authorized) public;

    /// @dev Assign or Delete a member from specific role.
    /// @param _memberAddress Address of Member
    /// @param _roleId RoleId to update
    /// @param _active active is set to be True if we want to assign this role to member, False otherwise!
    function updateRole(address _memberAddress, uint _roleId, bool _active) internal;

    /// @dev Change Member Address who holds the authority to Add/Delete any member from specific role.
    /// @param _roleId roleId to update its Authorized Address
    /// @param _authorized New authorized address against role id
    function changeAuthorized(uint _roleId, address _authorized) internal;

    /// @dev Return number of member roles
    function totalRoles() public view returns(uint256);

    /// @dev Gets the member addresses assigned by a specific role
    /// @param _memberRoleId Member role id
    /// @return roleId Role id
    /// @return allMemberAddress Member addresses of specified role id
    function members(uint _memberRoleId) internal view returns(uint, address[] memory allMemberAddress);

    /// @dev Gets all members' length
    /// @param _memberRoleId Member role id
    /// @return memberRoleData[_memberRoleId].memberAddress.length Member length
    function numberOfMembers(uint _memberRoleId) public view returns(uint);
    
    /// @dev Return member address who holds the right to add/remove any member from specific role.
    function authorized(uint _memberRoleId) internal view returns(address);

    /// @dev Get All role ids array that has been assigned to a member so far.
    function roles(address _memberAddress) internal view returns(uint[] memory assignedRoles);

    /// @dev Returns true if the given role id is assigned to a member.
    /// @param _memberAddress Address of member
    /// @param _roleId Checks member's authenticity with the roleId.
    /// i.e. Returns true if this roleId is assigned to member
    function checkRole(address _memberAddress, uint _roleId) public view returns(bool);   
}