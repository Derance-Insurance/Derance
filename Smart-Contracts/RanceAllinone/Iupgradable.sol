pragma solidity ^0.5.17;


contract IRANCEMaster {

    address public tokenAddress;

    address public owner;

    uint public pauseTime;

    function delegateCallBack(bytes32 myid) external;

    function masterInitialized() public view returns(bool);
    
    function isInternal(address _add) public view returns(bool);

    function isPause() public view returns(bool check);

    function isOwner(address _add) public view returns(bool);

    function isMember(address _add) public view returns(bool);
    
    function checkIsAuthToGoverned(address _add) public view returns(bool);

    function updatePauseTime(uint _time) public;

    function dAppLocker() public view returns(address _add);

    function dAppToken() public view returns(address _add);

    function getLatestAddress(bytes2 _contractName) public view returns(address payable contractAddress);
}

contract Iupgradable {

    IRANCEMaster public ms;
    address public ranceMasterAddress;

    modifier onlyInternal {
        require(ms.isInternal(msg.sender));
        _;
    }

    modifier isMemberAndcheckPause {
        require(ms.isPause() == false && ms.isMember(msg.sender) == true);
        _;
    }

    modifier onlyOwner {
        require(ms.isOwner(msg.sender));
        _;
    }

    modifier checkPause {
        require(ms.isPause() == false);
        _;
    }

    modifier isMember {
        require(ms.isMember(msg.sender), "Not member");
        _;
    }

    /**
     * @dev Iupgradable Interface to update dependent contract address
     */
    function  changeDependentContractAddress() public;

    /**
     * @dev change master address
     * @param _masterAddress is the new address
     */
    function changeMasterAddress(address _masterAddress) public {
        if (address(ms) != address(0)) {
            require(address(ms) == msg.sender, "Not master");
        }
        ms = IRANCEMaster(_masterAddress);
        ranceMasterAddress = _masterAddress;
    }

}