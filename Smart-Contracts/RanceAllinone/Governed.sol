pragma solidity ^0.5.17;

contract IMaster {
    function getLatestAddress(bytes2 _module) public view returns(address);
}

contract Governed {

    address public masterAddress; // Name of the dApp, needs to be set by contracts inheriting this contract

    /// @dev modifier that allows only the authorized addresses to execute the function
    modifier onlyAuthorizedToGovern() {
        IMaster ms = IMaster(masterAddress);
        require(ms.getLatestAddress("GV") == msg.sender, "Not authorized");
        _;
    }

    /// @dev checks if an address is authorized to govern
    function isAuthorizedToGovern(address _toCheck) public view returns(bool) {
        IMaster ms = IMaster(masterAddress);
        return (ms.getLatestAddress("GV") == _toCheck);
    } 

}