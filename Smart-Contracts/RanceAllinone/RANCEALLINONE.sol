pragma solidity ^0.5.17;

import "./SafeMath.sol";
import "./RANCEToken.sol";
import "./Iupgradable.sol";
import "./ClaimsData.sol";
import "./Exchange.sol";
import "./Governed.sol";
import "./IGovernance.sol";
import "./IPooledStaking.sol";
import "./QuotationData.sol";
import "./TokenController.sol";
import "./TokenData.sol";
import "./PoolData.sol";



contract TokenFunctions is Iupgradable {
    using SafeMath for uint;

    MCR internal m1;
    MemberRoles internal mr;
    RANCEToken public tk;
    TokenController internal tc;
    TokenData internal td;
    QuotationData internal qd;
    ClaimsReward internal cr;
    Governance internal gv;
    PoolData internal pd;
    IPooledStaking pooledStaking;

    event BurnCATokens(uint claimId, address addr, uint amount);

    /**
     * @dev Rewards stakers on purchase of cover on smart contract.
     * @param _contractAddress smart contract address.
     * @param _coverPriceRANCE cover price in RANCE.
     */
    function pushStakerRewards(address _contractAddress, uint _coverPriceRANCE) external onlyInternal {
        uint rewardValue = _coverPriceRANCE.mul(td.stakerCommissionPer()).div(100);
        pooledStaking.accumulateReward(_contractAddress, rewardValue);
    }

    /**
    * @dev Deprecated in favor of burnStakedTokens
    */
    function burnStakerLockedToken(uint, bytes4, uint) external {
        // noop
    }

    /**
    * @dev Burns tokens staked on smart contract covered by coverId. Called when a payout is succesfully executed.
    * @param coverId cover id
    * @param coverCurrency cover currency
    * @param sumAssured amount of $curr to burn
    */
    function burnStakedTokens(uint coverId, bytes4 coverCurrency, uint sumAssured) external onlyInternal {
        (, address scAddress) = qd.getscAddressOfCover(coverId);
        uint tokenPrice = m1.calculateTokenPrice(coverCurrency);
        uint burnRANCEAmount = sumAssured.mul(1e18).div(tokenPrice);
        pooledStaking.pushBurn(scAddress, burnRANCEAmount);
    }

    /**
     * @dev Gets the total staked RANCE tokens against
     * Smart contract by all stakers
     * @param _stakedContractAddress smart contract address.
     * @return amount total staked RANCE tokens.
     */
    function deprecated_getTotalStakedTokensOnSmartContract(
        address _stakedContractAddress
    )
        external
        view
        returns(uint)
    {
        uint stakedAmount = 0;
        address stakerAddress;
        uint staketLen = td.getStakedContractStakersLength(_stakedContractAddress);

        for (uint i = 0; i < staketLen; i++) {
            stakerAddress = td.getStakedContractStakerByIndex(_stakedContractAddress, i);
            uint stakerIndex = td.getStakedContractStakerIndex(
                _stakedContractAddress, i);
            uint currentlyStaked;
            (, currentlyStaked) = _deprecated_unlockableBeforeBurningAndCanBurn(stakerAddress,
                _stakedContractAddress, stakerIndex);
            stakedAmount = stakedAmount.add(currentlyStaked);
        }

        return stakedAmount;
    }

    /**
     * @dev Returns amount of RANCE Tokens locked as Cover Note for given coverId.
     * @param _of address of the coverHolder.
     * @param _coverId coverId of the cover.
     */
    function getUserLockedCNTokens(address _of, uint _coverId) external view returns(uint) {
        return _getUserLockedCNTokens(_of, _coverId);
    }

    /**
     * @dev to get the all the cover locked tokens of a user
     * @param _of is the user address in concern
     * @return amount locked
     */
    function getUserAllLockedCNTokens(address _of) external view returns(uint amount) {
        for (uint i = 0; i < qd.getUserCoverLength(_of); i++) {
            amount = amount.add(_getUserLockedCNTokens(_of, qd.getAllCoversOfUser(_of)[i]));
        }
    }

    /**
     * @dev Returns amount of RANCE Tokens locked as Cover Note against given coverId.
     * @param _coverId coverId of the cover.
     */
    function getLockedCNAgainstCover(uint _coverId) external view returns(uint) {
        return _getLockedCNAgainstCover(_coverId);
    }

    /**
     * @dev Returns total amount of staked RANCE Tokens on all smart contracts.
     * @param _stakerAddress address of the Staker.
     */
    function deprecated_getStakerAllLockedTokens(address _stakerAddress) external view returns (uint amount) {
        uint stakedAmount = 0;
        address scAddress;
        uint scIndex;
        for (uint i = 0; i < td.getStakerStakedContractLength(_stakerAddress); i++) {
            scAddress = td.getStakerStakedContractByIndex(_stakerAddress, i);
            scIndex = td.getStakerStakedContractIndex(_stakerAddress, i);
            uint currentlyStaked;
            (, currentlyStaked) = _deprecated_unlockableBeforeBurningAndCanBurn(_stakerAddress, scAddress, i);
            stakedAmount = stakedAmount.add(currentlyStaked);
        }
        amount = stakedAmount;
    }

    /**
     * @dev Returns total unlockable amount of staked RANCE Tokens on all smart contract .
     * @param _stakerAddress address of the Staker.
     */
    function deprecated_getStakerAllUnlockableStakedTokens(
        address _stakerAddress
    )
    external
    view
    returns (uint amount)
    {
        uint unlockableAmount = 0;
        address scAddress;
        uint scIndex;
        for (uint i = 0; i < td.getStakerStakedContractLength(_stakerAddress); i++) {
            scAddress = td.getStakerStakedContractByIndex(_stakerAddress, i);
            scIndex = td.getStakerStakedContractIndex(_stakerAddress, i);
            unlockableAmount = unlockableAmount.add(
                _deprecated_getStakerUnlockableTokensOnSmartContract(_stakerAddress, scAddress,
                scIndex));
        }
        amount = unlockableAmount;
    }

    /**
     * @dev Change Dependent Contract Address
     */
    function changeDependentContractAddress() public {
        tk = RANCEToken(ms.tokenAddress());
        td = TokenData(ms.getLatestAddress("TD"));
        tc = TokenController(ms.getLatestAddress("TC"));
        cr = ClaimsReward(ms.getLatestAddress("CR"));
        qd = QuotationData(ms.getLatestAddress("QD"));
        m1 = MCR(ms.getLatestAddress("MC"));
        gv = Governance(ms.getLatestAddress("GV"));
        mr = MemberRoles(ms.getLatestAddress("MR"));
        pd = PoolData(ms.getLatestAddress("PD"));
        pooledStaking = IPooledStaking(ms.getLatestAddress("PS"));
    }

    /**
     * @dev Gets the Token price in a given currency
     * @param curr Currency name.
     * @return price Token Price.
     */
    function getTokenPrice(bytes4 curr) public view returns(uint price) {
        price = m1.calculateTokenPrice(curr);
    }

    /**
     * @dev Set the flag to check if cover note is deposited against the cover id
     * @param coverId Cover Id.
     */
    function depositCN(uint coverId) public onlyInternal returns (bool success) {
        require(_getLockedCNAgainstCover(coverId) > 0, "No cover note available");
        td.setDepositCN(coverId, true);
        success = true;
    }

    /**
     * @param _of address of Member
     * @param _coverId Cover Id
     * @param _lockTime Pending Time + Cover Period 7*1 days
     */
    function extendCNEPOff(address _of, uint _coverId, uint _lockTime) public onlyInternal {
        uint timeStamp = now.add(_lockTime);
        uint coverValidUntil = qd.getValidityOfCover(_coverId);
        if (timeStamp >= coverValidUntil) {
            bytes32 reason = keccak256(abi.encodePacked("CN", _of, _coverId));
            tc.extendLockOf(_of, reason, timeStamp);
        }
    }

    /**
     * @dev to burn the deposited cover tokens
     * @param coverId is id of cover whose tokens have to be burned
     * @return the status of the successful burning
     */
    function burnDepositCN(uint coverId) public onlyInternal returns (bool success) {
        address _of = qd.getCoverMemberAddress(coverId);
        uint amount;
        (amount, ) = td.depositedCN(coverId);
        amount = (amount.mul(50)).div(100);
        bytes32 reason = keccak256(abi.encodePacked("CN", _of, coverId));
        tc.burnLockedTokens(_of, reason, amount);
        success = true;
    }

    /**
     * @dev Unlocks covernote locked against a given cover
     * @param coverId id of cover
     */
    function unlockCN(uint coverId) public onlyInternal {
        (, bool isDeposited) = td.depositedCN(coverId);
        require(!isDeposited,"Cover note is deposited and can not be released");
        uint lockedCN = _getLockedCNAgainstCover(coverId);
        if (lockedCN != 0) {
            address coverHolder = qd.getCoverMemberAddress(coverId);
            bytes32 reason = keccak256(abi.encodePacked("CN", coverHolder, coverId));
            tc.releaseLockedTokens(coverHolder, reason, lockedCN);
        }
    }

    /**
     * @dev Burns tokens used for fraudulent voting against a claim
     * @param claimid Claim Id.
     * @param _value number of tokens to be burned
     * @param _of Claim Assessor's address.
     */
    function burnCAToken(uint claimid, uint _value, address _of) public {

        require(ms.checkIsAuthToGoverned(msg.sender));
        tc.burnLockedTokens(_of, "CLA", _value);
        emit BurnCATokens(claimid, _of, _value);
    }

    /**
     * @dev to lock cover note tokens
     * @param coverNoteAmount is number of tokens to be locked
     * @param coverPeriod is cover period in concern
     * @param coverId is the cover id of cover in concern
     * @param _of address whose tokens are to be locked
     */
    function lockCN(
        uint coverNoteAmount,
        uint coverPeriod,
        uint coverId,
        address _of
    )
        public
        onlyInternal
    {
        uint validity = (coverPeriod * 1 days).add(td.lockTokenTimeAfterCoverExp());
        bytes32 reason = keccak256(abi.encodePacked("CN", _of, coverId));
        td.setDepositCNAmount(coverId, coverNoteAmount);
        tc.lockOf(_of, reason, coverNoteAmount, validity);
    }

    /**
     * @dev to check if a  member is locked for member vote
     * @param _of is the member address in concern
     * @return the boolean status
     */
    function isLockedForMemberVote(address _of) public view returns(bool) {
        return now < tk.isLockedForMV(_of);
    }

    /**
     * @dev Internal function to gets amount of locked RANCE tokens,
     * staked against smartcontract by index
     * @param _stakerAddress address of user
     * @param _stakedContractAddress staked contract address
     * @param _stakedContractIndex index of staking
     */
    function deprecated_getStakerLockedTokensOnSmartContract (
        address _stakerAddress,
        address _stakedContractAddress,
        uint _stakedContractIndex
    )
        internal
        view
        returns
        (uint amount)
    {
        amount = _deprecated_getStakerLockedTokensOnSmartContract(_stakerAddress,
            _stakedContractAddress, _stakedContractIndex);
    }

    /**
     * @dev Function to gets unlockable amount of locked RANCE
     * tokens, staked against smartcontract by index
     * @param stakerAddress address of staker
     * @param stakedContractAddress staked contract address
     * @param stakerIndex index of staking
     */
    function deprecated_getStakerUnlockableTokensOnSmartContract (
        address stakerAddress,
        address stakedContractAddress,
        uint stakerIndex
    )
       public
        view
        returns (uint)
    {
        return _deprecated_getStakerUnlockableTokensOnSmartContract(stakerAddress, stakedContractAddress,
        td.getStakerStakedContractIndex(stakerAddress, stakerIndex));
    }

    /**
     * @dev releases unlockable staked tokens to staker
     */
    function deprecated_unlockStakerUnlockableTokens(address _stakerAddress) public checkPause {
        uint unlockableAmount;
        address scAddress;
        bytes32 reason;
        uint scIndex;
        for (uint i = 0; i < td.getStakerStakedContractLength(_stakerAddress); i++) {
            scAddress = td.getStakerStakedContractByIndex(_stakerAddress, i);
            scIndex = td.getStakerStakedContractIndex(_stakerAddress, i);
            unlockableAmount = _deprecated_getStakerUnlockableTokensOnSmartContract(
            _stakerAddress, scAddress,
            scIndex);
            td.setUnlockableBeforeLastBurnTokens(_stakerAddress, i, 0);
            td.pushUnlockedStakedTokens(_stakerAddress, i, unlockableAmount);
            reason = keccak256(abi.encodePacked("UW", _stakerAddress, scAddress, scIndex));
            tc.releaseLockedTokens(_stakerAddress, reason, unlockableAmount);
        }
    }

    /**
     * @dev to get tokens of staker locked before burning that are allowed to burn
     * @param stakerAdd is the address of the staker
     * @param stakedAdd is the address of staked contract in concern
     * @param stakerIndex is the staker index in concern
     * @return amount of unlockable tokens
     * @return amount of tokens that can burn
     */
    function _deprecated_unlockableBeforeBurningAndCanBurn(
        address stakerAdd,
        address stakedAdd,
        uint stakerIndex
    )
    public
    view
    returns
    (uint amount, uint canBurn) {

        uint dateAdd;
        uint initialStake;
        uint totalBurnt;
        uint ub;
        (, , dateAdd, initialStake, , totalBurnt, ub) = td.stakerStakedContracts(stakerAdd, stakerIndex);
        canBurn = _deprecated_calculateStakedTokens(initialStake, now.sub(dateAdd).div(1 days), td.scValidDays());
        // Can't use SafeMaths for int.
        int v = int(initialStake - (canBurn) - (totalBurnt) - (
            td.getStakerUnlockedStakedTokens(stakerAdd, stakerIndex)) - (ub));
        uint currentLockedTokens = _deprecated_getStakerLockedTokensOnSmartContract(
            stakerAdd, stakedAdd, td.getStakerStakedContractIndex(stakerAdd, stakerIndex));
        if (v < 0) {
            v = 0;
        }
        amount = uint(v);
        if (canBurn > currentLockedTokens.sub(amount).sub(ub)) {
            canBurn = currentLockedTokens.sub(amount).sub(ub);
        }
    }

    /**
     * @dev to get tokens of staker that are unlockable
     * @param _stakerAddress is the address of the staker
     * @param _stakedContractAddress is the address of staked contract in concern
     * @param _stakedContractIndex is the staked contract index in concern
     * @return amount of unlockable tokens
     */
    function _deprecated_getStakerUnlockableTokensOnSmartContract (
        address _stakerAddress,
        address _stakedContractAddress,
        uint _stakedContractIndex
    )
        public
        view
        returns
        (uint amount)
    {
        uint initialStake;
        uint stakerIndex = td.getStakedContractStakerIndex(
            _stakedContractAddress, _stakedContractIndex);
        uint burnt;
        (, , , initialStake, , burnt,) = td.stakerStakedContracts(_stakerAddress, stakerIndex);
        uint alreadyUnlocked = td.getStakerUnlockedStakedTokens(_stakerAddress, stakerIndex);
        uint currentStakedTokens;
        (, currentStakedTokens) = _deprecated_unlockableBeforeBurningAndCanBurn(_stakerAddress,
            _stakedContractAddress, stakerIndex);
        amount = initialStake.sub(currentStakedTokens).sub(alreadyUnlocked).sub(burnt);
    }

    /**
     * @dev Internal function to get the amount of locked RANCE tokens,
     * staked against smartcontract by index
     * @param _stakerAddress address of user
     * @param _stakedContractAddress staked contract address
     * @param _stakedContractIndex index of staking
     */
    function _deprecated_getStakerLockedTokensOnSmartContract (
        address _stakerAddress,
        address _stakedContractAddress,
        uint _stakedContractIndex
    )
        internal
        view
        returns
        (uint amount)
    {
        bytes32 reason = keccak256(abi.encodePacked("UW", _stakerAddress,
            _stakedContractAddress, _stakedContractIndex));
        amount = tc.tokensLocked(_stakerAddress, reason);
    }

    /**
     * @dev Returns amount of RANCE Tokens locked as Cover Note for given coverId.
     * @param _coverId coverId of the cover.
     */
    function _getLockedCNAgainstCover(uint _coverId) internal view returns(uint) {
        address coverHolder = qd.getCoverMemberAddress(_coverId);
        bytes32 reason = keccak256(abi.encodePacked("CN", coverHolder, _coverId));
        return tc.tokensLockedAtTime(coverHolder, reason, now);
    }

    /**
     * @dev Returns amount of RANCE Tokens locked as Cover Note for given coverId.
     * @param _of address of the coverHolder.
     * @param _coverId coverId of the cover.
     */
    function _getUserLockedCNTokens(address _of, uint _coverId) internal view returns(uint) {
        bytes32 reason = keccak256(abi.encodePacked("CN", _of, _coverId));
        return tc.tokensLockedAtTime(_of, reason, now);
    }

    /**
     * @dev Internal function to gets remaining amount of staked RANCE tokens,
     * against smartcontract by index
     * @param _stakeAmount address of user
     * @param _stakeDays staked contract address
     * @param _validDays index of staking
     */
    function _deprecated_calculateStakedTokens(
        uint _stakeAmount,
        uint _stakeDays,
        uint _validDays
    )
        internal
        pure
        returns (uint amount)
    {
        if (_validDays > _stakeDays) {
            uint rf = ((_validDays.sub(_stakeDays)).mul(100000)).div(_validDays);
            amount = (rf.mul(_stakeAmount)).div(100000);
        } else {
            amount = 0;
        }
    }

    /**
     * @dev Gets the total staked RANCE tokens against Smart contract
     * by all stakers
     * @param _stakedContractAddress smart contract address.
     * @return amount total staked RANCE tokens.
     */
    function _deprecated_burnStakerTokenLockedAgainstSmartContract(
        address _stakerAddress,
        address _stakedContractAddress,
        uint _stakedContractIndex,
        uint _amount
    )
        internal
    {
        uint stakerIndex = td.getStakedContractStakerIndex(
            _stakedContractAddress, _stakedContractIndex);
        td.pushBurnedTokens(_stakerAddress, stakerIndex, _amount);
        bytes32 reason = keccak256(abi.encodePacked("UW", _stakerAddress,
            _stakedContractAddress, _stakedContractIndex));
        tc.burnLockedTokens(_stakerAddress, reason, _amount);
    }
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


contract MCR is Iupgradable {
    using SafeMath for uint;

    Pool1 internal p1;
    PoolData internal pd;
    RANCEToken internal tk;
    QuotationData internal qd;
    MemberRoles internal mr;
    TokenData internal td;
    ProposalCategory internal proposalCategory;

    uint private constant DECIMAL1E18 = uint(10) ** 18;
    uint private constant DECIMAL1E05 = uint(10) ** 5;
    uint private constant DECIMAL1E19 = uint(10) ** 19;
    uint private constant minCapFactor = uint(10) ** 21;

    uint public variableMincap;
    uint public dynamicMincapThresholdx100 = 13000;
    uint public dynamicMincapIncrementx100 = 100;

    event MCREvent(
        uint indexed date,
        uint blockNumber,
        bytes4[] allCurr,
        uint[] allCurrRates,
        uint mcrEtherx100,
        uint mcrPercx100,
        uint vFull
    );

    /** 
     * @dev Adds new MCR data.
     * @param mcrP  Minimum Capital Requirement in percentage.
     * @param vF Pool1 fund value in Ether used in the last full daily calculation of the Capital model.
     * @param onlyDate  Date(yyyymmdd) at which MCR details are getting added.
     */ 
    function addMCRData(
        uint mcrP,
        uint mcrE,
        uint vF,
        bytes4[] calldata curr,
        uint[] calldata _threeDayAvg,
        uint64 onlyDate
    )
        external
        checkPause
    {
        // require(proposalCategory.constructorCheck());
        require(pd.isnotarise(msg.sender));
        if (mr.launched() && pd.capReached() != 1) {
            
            if (mcrP >= 10000)
                pd.setCapReached(1);  

        }
        uint len = pd.getMCRDataLength();
        _addMCRData(len, onlyDate, curr, mcrE, mcrP, vF, _threeDayAvg);
    }

    /**
     * @dev Adds MCR Data for last failed attempt.
     */  
    function addLastMCRData(uint64 date) external checkPause  onlyInternal {
        uint64 lastdate = uint64(pd.getLastMCRDate());
        uint64 failedDate = uint64(date);
        if (failedDate >= lastdate) {
            uint mcrP;
            uint mcrE;
            uint vF;
            (mcrP, mcrE, vF, ) = pd.getLastMCR();
            uint len = pd.getAllCurrenciesLen();
            pd.pushMCRData(mcrP, mcrE, vF, date);
            for (uint j = 0; j < len; j++) {
                bytes4 currName = pd.getCurrenciesByIndex(j);
                pd.updateCAAvgRate(currName, pd.getCAAvgRate(currName));
            }

            emit MCREvent(date, block.number, new bytes4[](0), new uint[](0), mcrE, mcrP, vF);
            // Oraclize call for next MCR calculation
            _callOracliseForMCR();
        }
    }

    /**
     * @dev Iupgradable Interface to update dependent contract address
     */
    function changeDependentContractAddress() public onlyInternal {
        qd = QuotationData(ms.getLatestAddress("QD"));
        p1 = Pool1(ms.getLatestAddress("P1"));
        pd = PoolData(ms.getLatestAddress("PD"));
        tk = RANCEToken(ms.tokenAddress());
        mr = MemberRoles(ms.getLatestAddress("MR"));
        td = TokenData(ms.getLatestAddress("TD"));
        // proposalCategory = ProposalCategory(ms.getLatestAddress("PC"));
    }

    /** 
     * @dev Gets total sum assured(in BNB).
     * @return amount of sum assured
     */  
    function getAllSumAssurance() public view returns(uint amount) {
        uint len = pd.getAllCurrenciesLen();
        for (uint i = 0; i < len; i++) {
            bytes4 currName = pd.getCurrenciesByIndex(i);
            if (currName == "BNB") {
                amount = amount.add(qd.getTotalSumAssured(currName));
            } else {
                if (pd.getCAAvgRate(currName) > 0)
                    amount = amount.add((qd.getTotalSumAssured(currName).mul(100)).div(pd.getCAAvgRate(currName)));
            }
        }
    }

    /**
     * @dev Calculates V(Tp) and MCR%(Tp), i.e, Pool Fund Value in Ether 
     * and MCR% used in the Token Price Calculation.
     * @return vtp  Pool Fund Value in Ether used for the Token Price Model
     * @return mcrtp MCR% used in the Token Price Model. 
     */ 
    function _calVtpAndMCRtp(uint poolBalance) public view returns(uint vtp, uint mcrtp) {
        vtp = 0;
        IERC20 erc20;
        uint currTokens = 0;
        uint i;
        for (i = 1; i < pd.getAllCurrenciesLen(); i++) {
            bytes4 currency = pd.getCurrenciesByIndex(i);
            erc20 = IERC20(pd.getCurrencyAssetAddress(currency));
            currTokens = erc20.balanceOf(address(p1));
            if (pd.getCAAvgRate(currency) > 0)
                vtp = vtp.add((currTokens.mul(100)).div(pd.getCAAvgRate(currency)));
        }

        vtp = vtp.add(poolBalance).add(p1.getInvestmentAssetBalance());
        uint mcrFullperc;
        uint vFull;
        (mcrFullperc, , vFull, ) = pd.getLastMCR();
        if (vFull > 0) {
            mcrtp = (mcrFullperc.mul(vtp)).div(vFull);
        }
    }

    /**
     * @dev Calculates the Token Price of RANCE in a given currency.
     * @param curr Currency name.
     
     */
    function calculateStepTokenPrice(
        bytes4 curr,
        uint mcrtp
    ) 
        public
        view
        onlyInternal
        returns(uint tokenPrice)
    {
        return _calculateTokenPrice(curr, mcrtp);
    }

    /**
     * @dev Calculates the Token Price of RANCE in a given currency 
     * with provided token supply for dynamic token price calculation
     * @param curr Currency name.
     */ 
    function calculateTokenPrice (bytes4 curr) public view returns(uint tokenPrice) {
        uint mcrtp;
        (, mcrtp) = _calVtpAndMCRtp(address(p1).balance); 
        return _calculateTokenPrice(curr, mcrtp);
    }
    
    function calVtpAndMCRtp() public view returns(uint vtp, uint mcrtp) {
        return _calVtpAndMCRtp(address(p1).balance);
    }

    function calculateVtpAndMCRtp(uint poolBalance) public view returns(uint vtp, uint mcrtp) {
        return _calVtpAndMCRtp(poolBalance);
    }

    function getThresholdValues(uint vtp, uint vF, uint totalSA, uint minCap) public view returns(uint lowerThreshold, uint upperThreshold)
    {
        minCap = (minCap.mul(minCapFactor)).add(variableMincap);
        uint lower = 0;
        if (vtp >= vF) {
                upperThreshold = vtp.mul(120).mul(100).div((minCap));     //Max Threshold = [MAX(Vtp, Vfull) x 120] / mcrMinCap
            } else {
                upperThreshold = vF.mul(120).mul(100).div((minCap));
            }

            if (vtp > 0) {
                lower = totalSA.mul(DECIMAL1E18).mul(pd.shockParameter()).div(100);
                if(lower < minCap.mul(11).div(10))
                    lower = minCap.mul(11).div(10);
            }
            if (lower > 0) {                                       //Min Threshold = [Vtp / MAX(TotalActiveSA x ShockParameter, mcrMinCap x 1.1)] x 100
                lowerThreshold = vtp.mul(100).mul(100).div(lower);
            }
    }

    /**
     * @dev Gets max numbers of tokens that can be sold at the moment.
     */ 
    function getMaxSellTokens() public view returns(uint maxTokens) {
        uint baseMin = pd.getCurrencyAssetBaseMin("BNB");
        uint maxTokensAccPoolBal;
        if (address(p1).balance > baseMin.mul(50).div(100)) {
            maxTokensAccPoolBal = address(p1).balance.sub(
            (baseMin.mul(50)).div(100));        
        }
        maxTokensAccPoolBal = (maxTokensAccPoolBal.mul(DECIMAL1E18)).div(
            (calculateTokenPrice("BNB").mul(975)).div(1000));
        uint lastMCRPerc = pd.getLastMCRPerc();
        if (lastMCRPerc > 10000)
            maxTokens = (((uint(lastMCRPerc).sub(10000)).mul(2000)).mul(DECIMAL1E18)).div(10000);
        if (maxTokens > maxTokensAccPoolBal)
            maxTokens = maxTokensAccPoolBal;     
    }

    /**
     * @dev Gets Uint Parameters of a code
     * @param code whose details we want
     * @return string value of the code
     * @return associated amount (time or perc or value) to the code
     */
    function getUintParameters(bytes8 code) external view returns(bytes8 codeVal, uint val) {
        codeVal = code;
        if (code == "DMCT") {
            val = dynamicMincapThresholdx100;

        } else if (code == "DMCI") {

            val = dynamicMincapIncrementx100;

        }
            
    }

    /**
     * @dev Updates Uint Parameters of a code
     * @param code whose details we want to update
     * @param val value to set
     */
    function updateUintParameters(bytes8 code, uint val) public {
        require(ms.checkIsAuthToGoverned(msg.sender));
        if (code == "DMCT") {
           dynamicMincapThresholdx100 = val;

        } else if (code == "DMCI") {

            dynamicMincapIncrementx100 = val;

        }
         else {
            revert("Invalid param code");
        }
            
    }

    /** 
     * @dev Calls oraclize query to calculate MCR details after 24 hours.
     */ 
    function _callOracliseForMCR() internal {
        p1.mcrOraclise(pd.mcrTime());
    }

    /**
     * @dev Calculates the Token Price of SOTE in a given currency 
     * with provided token supply for dynamic token price calculation
     * @param _curr Currency name.  
     * @return tokenPrice Token price.
     */ 
    function _calculateTokenPrice(
        bytes4 _curr,
        uint mcrtp
    )
        internal
        view
        returns(uint tokenPrice)
    {
        uint getA;
        uint getC;
        uint getCAAvgRate;
        uint tokenExponentValue = td.tokenExponent();
        // uint max = (mcrtp.mul(mcrtp).mul(mcrtp).mul(mcrtp));
        uint max = mcrtp ** tokenExponentValue;
        uint dividingFactor = tokenExponentValue.mul(4); 
        (getA, getC, getCAAvgRate) = pd.getTokenPriceDetails(_curr);
        uint mcrEth = pd.getLastMCREther();
        getC = getC.mul(DECIMAL1E18);
        tokenPrice = (mcrEth.mul(DECIMAL1E18).mul(max).div(getC)).div(10 ** dividingFactor);
        tokenPrice = tokenPrice.add(getA.mul(DECIMAL1E18).div(DECIMAL1E05));
        tokenPrice = tokenPrice.mul(getCAAvgRate * 10); 
        tokenPrice = (tokenPrice).div(10**3);
    } 
    
    /**
     * @dev Adds MCR Data. Checks if MCR is within valid 
     * thresholds in order to rule out any incorrect calculations 
     */  
    function _addMCRData(
        uint len,
        uint64 newMCRDate,
        bytes4[] memory curr,
        uint mcrE,
        uint mcrP,
        uint vF,
        uint[] memory _threeDayAvg
    ) 
        internal
    {
        uint vtp = 0;
        uint lowerThreshold = 0;
        uint upperThreshold = 0;
        if (len > 1) {
            (vtp, ) = _calVtpAndMCRtp(address(p1).balance);
            (lowerThreshold, upperThreshold) = getThresholdValues(vtp, vF, getAllSumAssurance(), pd.minCap());

        }
        if(mcrP > dynamicMincapThresholdx100)
            variableMincap =  (variableMincap.mul(dynamicMincapIncrementx100.add(10000)).add(minCapFactor.mul(pd.minCap().mul(dynamicMincapIncrementx100)))).div(10000);


        // Explanation for above formula :- 
        // actual formula -> variableMinCap =  variableMinCap + (variableMinCap+minCap)*dynamicMincapIncrement/100
        // Implemented formula is simplified form of actual formula.
        // Let consider above formula as b = b + (a+b)*c/100
        // here, dynamicMincapIncrement is in x100 format. 
        // so b+(a+b)*cx100/10000 can be written as => (10000.b + b.cx100 + a.cx100)/10000.
        // It can further simplify to (b.(10000+cx100) + a.cx100)/10000.
        if (len == 1 || (mcrP) >= lowerThreshold 
            && (mcrP) <= upperThreshold) {
            vtp = pd.getLastMCRDate(); // due to stack to deep error,we are reusing already declared variable
            pd.pushMCRData(mcrP, mcrE, vF, newMCRDate);
            for (uint i = 0; i < curr.length; i++) {
                pd.updateCAAvgRate(curr[i], _threeDayAvg[i]);
            }
            emit MCREvent(newMCRDate, block.number, curr, _threeDayAvg, mcrE, mcrP, vF);
            // Oraclize call for next MCR calculation
            if (vtp < newMCRDate) {
                _callOracliseForMCR();
            }
        } else {
            p1.mcrOracliseFail(newMCRDate, pd.mcrFailTime());
        }
    }

}



contract Pool1 is Iupgradable {
    using SafeMath for uint;

    Quotation internal q2;
    RANCEToken internal tk;
    TokenController internal tc;
    TokenFunctions internal tf;
    Pool2 internal p2;
    PoolData internal pd;
    MCR internal m1;
    Claims public c1;
    TokenData internal td;
    bool internal locked;

    uint internal constant DECIMAL1E18 = uint(10) ** 18;
    // uint internal constant PRICE_STEP = uint(1000) * DECIMAL1E18;

    event Apiresult(address indexed sender, string msg, bytes32 myid);
    event Payout(address indexed to, uint coverId, uint tokens);

    modifier noReentrancy() {
        require(!locked, "Reentrant call.");
        locked = true;
        _;
        locked = false;
    }

    function () external payable {} //solhint-disable-line

    /**
     * @dev Pays out the sum assured in case a claim is accepted
     * @param coverid Cover Id.
     * @param claimid Claim Id.
     * @return succ true if payout is successful, false otherwise. 
     */ 
    function sendClaimPayout(
        uint coverid,
        uint claimid,
        uint sumAssured,
        address payable coverHolder,
        bytes4 coverCurr
    )
        external
        onlyInternal
        noReentrancy
        returns(bool succ)
    {
        
        uint sa = sumAssured.div(DECIMAL1E18);
        bool check;
        IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr));

        //Payout
        if (coverCurr == "BNB" && address(this).balance >= sumAssured) {
            // check = _transferCurrencyAsset(coverCurr, coverHolder, sumAssured);
            coverHolder.transfer(sumAssured);
            check = true;
        } else if (coverCurr == "DAI" && erc20.balanceOf(address(this)) >= sumAssured) {
            erc20.transfer(coverHolder, sumAssured);
            check = true;
        }
        
        if (check == true) {
            q2.removeSAFromCSA(coverid, sa);
            pd.changeCurrencyAssetVarMin(coverCurr, 
                pd.getCurrencyAssetVarMin(coverCurr).sub(sumAssured));
            emit Payout(coverHolder, coverid, sumAssured);
            succ = true;
        } else {
            c1.setClaimStatus(claimid, 12);
        }
        _triggerExternalLiquidityTrade();
        // p2.internalLiquiditySwap(coverCurr);

        tf.burnStakerLockedToken(coverid, coverCurr, sumAssured);
    }

    /**
     * @dev to trigger external liquidity trade
     */
    function triggerExternalLiquidityTrade() external onlyInternal {
        _triggerExternalLiquidityTrade();
    }

    ///@dev Oraclize call to close emergency pause.
    function closeEmergencyPause(uint time) external onlyInternal {
        bytes32 myid = _oraclizeQuery();
        _saveApiDetails(myid, "EP", 0);
    }

    /// @dev Calls the Oraclize Query to close a given Claim after a given period of time.
    /// @param id Claim Id to be closed
    /// @param time Time (in seconds) after which Claims assessment voting needs to be closed
    function closeClaimsOraclise(uint id, uint time) external onlyInternal {
        bytes32 myid = _oraclizeQuery();
        _saveApiDetails(myid, "CLA", id);
    }

    /// @dev Calls Oraclize Query to expire a given Cover after a given period of time.
    /// @param id Quote Id to be expired
    /// @param time Time (in seconds) after which the cover should be expired
    function closeCoverOraclise(uint id, uint64 time) external onlyInternal {
        bytes32 myid = _oraclizeQuery();
        _saveApiDetails(myid, "COV", id);
    }

    /// @dev Calls the Oraclize Query to initiate MCR calculation.
    /// @param time Time (in milliseconds) after which the next MCR calculation should be initiated
    function mcrOraclise(uint time) external onlyInternal {
        bytes32 myid = _oraclizeQuery();
        _saveApiDetails(myid, "MCR", 0);
    }

    /// @dev Calls the Oraclize Query in case MCR calculation fails.
    /// @param time Time (in seconds) after which the next MCR calculation should be initiated
    function mcrOracliseFail(uint id, uint time) external onlyInternal {
        bytes32 myid = _oraclizeQuery();
        _saveApiDetails(myid, "MCRF", id);
    }

    /// @dev Oraclize call to update investment asset rates.
    function saveIADetailsOracalise(uint time) external onlyInternal {
        bytes32 myid = _oraclizeQuery();
        _saveApiDetails(myid, "IARB", 0);
    }
    
    /**
     * @dev Transfers all assest (i.e BNB balance, Currency Assest) from old Pool to new Pool
     * @param newPoolAddress Address of the new Pool
     */
    function upgradeCapitalPool(address payable newPoolAddress) external noReentrancy onlyInternal {
        for (uint64 i = 1; i < pd.getAllCurrenciesLen(); i++) {
            bytes4 caName = pd.getCurrenciesByIndex(i);
            _upgradeCapitalPool(caName, newPoolAddress);
        }
        if (address(this).balance > 0) {
            Pool1 newP1 = Pool1(newPoolAddress);
            newP1.sendEther.value(address(this).balance)();
        }
    }

    /**
     * @dev Iupgradable Interface to update dependent contract address
     */
    function changeDependentContractAddress() public {
        m1 = MCR(ms.getLatestAddress("MC"));
        tk = RANCEToken(ms.tokenAddress());
        tf = TokenFunctions(ms.getLatestAddress("TF"));
        tc = TokenController(ms.getLatestAddress("TC"));
        pd = PoolData(ms.getLatestAddress("PD"));
        q2 = Quotation(ms.getLatestAddress("QT"));
        p2 = Pool2(ms.getLatestAddress("P2"));
        c1 = Claims(ms.getLatestAddress("CL"));
        td = TokenData(ms.getLatestAddress("TD"));
    }

    function sendEther() public payable {
        
    }

    /**
     * @dev transfers currency asset to an address
     * @param curr is the currency of currency asset to transfer
     * @param amount is amount of currency asset to transfer
     * @return boolean to represent success or failure
     */
    function transferCurrencyAsset(
        bytes4 curr,
        uint amount
    )
        public
        onlyInternal
        noReentrancy
        returns(bool)
    {
    
        return _transferCurrencyAsset(curr, amount);
    } 

    /// @dev Handles callback of external oracle query.
    function __callback(bytes32 myid, string memory result) public {
        result; //silence compiler warning
        // owner will be removed from production build
        ms.delegateCallBack(myid);
    }

    /// @dev Enables user to purchase cover with funding in BNB.
    /// @param smartCAdd Smart Contract Address
    function makeCoverBegin(
        address smartCAdd,
        bytes4 coverCurr,
        uint[] memory coverDetails,
        uint16 coverPeriod,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    )
        public
        isMember
        checkPause
        payable
    {
        require(msg.value == coverDetails[1]);
        q2.verifyCoverDetails(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod, _v, _r, _s);
    }

    /**
     * @dev Enables user to purchase cover via currency asset eg DAI
     */ 
    function makeCoverUsingCA(
        address smartCAdd,
        bytes4 coverCurr,
        uint[] memory coverDetails,
        uint16 coverPeriod,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) 
        public
        isMember
        checkPause
    {
        IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr));
        require(erc20.transferFrom(msg.sender, address(this), coverDetails[1]), "Transfer failed");
        q2.verifyCoverDetails(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod, _v, _r, _s);
    }

    /// @dev Enables user to purchase SOTE at the current token price.
    function buyToken() public payable isMember checkPause returns(bool success) {
        require(msg.value > 0);
        uint tokenPurchased = _getToken(address(this).balance, msg.value);
        tc.mint(msg.sender, tokenPurchased);
        success = true;
    }

    /// @dev Sends a given amount of Ether to a given address.
    /// @param amount amount (in wei) to send.
    /// @param _add Receiver's address.
    /// @return succ True if transfer is a success, otherwise False.
    function transferEther(uint amount, address payable _add) public noReentrancy checkPause returns(bool succ) {
        require(ms.checkIsAuthToGoverned(msg.sender), "Not authorized to Govern");
        succ = _add.send(amount);
    }

    /**
     * @dev Allows selling of SOTE for ether.
     * Seller first needs to give this contract allowance to
     * transfer/burn tokens in the SOTEToken contract
     * @param  _amount Amount of SOTE to sell
     * @return success returns true on successfull sale
     */
    function sellRANCETokens(uint _amount) public isMember noReentrancy checkPause returns(bool success) {
        require(tk.balanceOf(msg.sender) >= _amount, "Not enough balance");
        require(!tf.isLockedForMemberVote(msg.sender), "Member voted");
        require(_amount <= m1.getMaxSellTokens(), "exceeds maximum token sell limit");
        uint sellingPrice = _getWei(_amount);
        tc.burnFrom(msg.sender, _amount);
        msg.sender.transfer(sellingPrice);
        success = true;
    }

    /**
     * @dev gives the investment asset balance
     * @return investment asset balance
     */
    function getInvestmentAssetBalance() public view returns (uint balance) {
        IERC20 erc20;
        uint currTokens;
        for (uint i = 1; i < pd.getInvestmentCurrencyLen(); i++) {
            bytes4 currency = pd.getInvestmentCurrencyByIndex(i);
            erc20 = IERC20(pd.getInvestmentAssetAddress(currency));
            currTokens = erc20.balanceOf(address(p2));
            if (pd.getIAAvgRate(currency) > 0)
                balance = balance.add((currTokens.mul(100)).div(pd.getIAAvgRate(currency)));
        }

        balance = balance.add(address(p2).balance);
    }

    /**
     * @dev Returns the amount of wei a seller will get for selling SOTE
     * @param amount Amount of SOTE to sell
     * @return weiToPay Amount of wei the seller will get
     */
    function getWei(uint amount) public view returns(uint weiToPay) {
        return _getWei(amount);
    }

    /**
     * @dev Returns the amount of token a buyer will get for corresponding wei
     * @param weiPaid Amount of wei 
     * @return tokenToGet Amount of tokens the buyer will get
     */
    function getToken(uint weiPaid) public view returns(uint tokenToGet) {
        return _getToken((address(this).balance).add(weiPaid), weiPaid);
    }

    /**
     * @dev to trigger external liquidity trade
     */
    function _triggerExternalLiquidityTrade() internal {
        if (now > pd.lastLiquidityTradeTrigger().add(pd.liquidityTradeCallbackTime())) {
            pd.setLastLiquidityTradeTrigger();
        }
    }

    /**
     * @dev Returns the amount of wei a seller will get for selling SOTE
     * @param _amount Amount of SOTE to sell
     * @return weiToPay Amount of wei the seller will get
     */
    function _getWei(uint _amount) internal view returns(uint weiToPay) {
        uint tokenPrice;
        uint weiPaid;
        uint tokenSupply = tk.totalSupply();
        uint vtp;
        uint mcrFullperc;
        uint vFull;
        uint mcrtp;
        (mcrFullperc, , vFull, ) = pd.getLastMCR();
        (vtp, ) = m1.calVtpAndMCRtp();

        while (_amount > 0) {
            mcrtp = (mcrFullperc.mul(vtp)).div(vFull);
            tokenPrice = m1.calculateStepTokenPrice("BNB", mcrtp);
            tokenPrice = (tokenPrice.mul(975)).div(1000); //97.5%
            if (_amount <= td.priceStep().mul(DECIMAL1E18)) {
                weiToPay = weiToPay.add((tokenPrice.mul(_amount)).div(DECIMAL1E18));
                break;
            } else {
                _amount = _amount.sub(td.priceStep().mul(DECIMAL1E18));
                tokenSupply = tokenSupply.sub(td.priceStep().mul(DECIMAL1E18));
                weiPaid = (tokenPrice.mul(td.priceStep().mul(DECIMAL1E18))).div(DECIMAL1E18);
                vtp = vtp.sub(weiPaid);
                weiToPay = weiToPay.add(weiPaid);
            }
        }
    }

    /**
     * @dev gives the token
     * @param _poolBalance is the pool balance
     * @param _weiPaid is the amount paid in wei
     * @return the token to get
     */
    function _getToken(uint _poolBalance, uint _weiPaid) internal view returns(uint tokenToGet) {
        uint tokenPrice;
        uint superWeiLeft = (_weiPaid).mul(DECIMAL1E18);
        uint tempTokens;
        uint superWeiSpent;
        uint tokenSupply = tk.totalSupply();
        uint vtp;
        uint mcrFullperc;   
        uint vFull;
        uint mcrtp;
        (mcrFullperc, , vFull, ) = pd.getLastMCR();
        (vtp, ) = m1.calculateVtpAndMCRtp((_poolBalance).sub(_weiPaid));

        require(m1.calculateTokenPrice("BNB") > 0, "Token price can not be zero");
        while (superWeiLeft > 0) {
            mcrtp = (mcrFullperc.mul(vtp)).div(vFull);
            tokenPrice = m1.calculateStepTokenPrice("BNB", mcrtp);            
            tempTokens = superWeiLeft.div(tokenPrice);
            if (tempTokens <= td.priceStep().mul(DECIMAL1E18)) {
                tokenToGet = tokenToGet.add(tempTokens);
                break;
            } else {
                tokenToGet = tokenToGet.add(td.priceStep().mul(DECIMAL1E18));
                tokenSupply = tokenSupply.add(td.priceStep().mul(DECIMAL1E18));
                superWeiSpent = td.priceStep().mul(DECIMAL1E18).mul(tokenPrice);
                superWeiLeft = superWeiLeft.sub(superWeiSpent);
                vtp = vtp.add((td.priceStep().mul(DECIMAL1E18).mul(tokenPrice)).div(DECIMAL1E18));
            }
        }
    }

    /** 
     * @dev Save the details of the Oraclize API.
     * @param myid Id return by the oraclize query.
     * @param _typeof type of the query for which oraclize call is made.
     * @param id ID of the proposal, quote, cover etc. for which oraclize call is made.
     */ 
    function _saveApiDetails(bytes32 myid, bytes4 _typeof, uint id) internal {
        pd.saveApiDetails(myid, _typeof, id);
        pd.addInAllApiCall(myid);
    }

    /**
     * @dev transfers currency asset
     * @param _curr is currency of asset to transfer
     * @param _amount is the amount to be transferred
     * @return boolean representing the success of transfer
     */
    function _transferCurrencyAsset(bytes4 _curr, uint _amount) internal returns(bool succ) {
        if (_curr == "BNB") {
            if (address(this).balance < _amount)
                _amount = address(this).balance;
            p2.sendEther.value(_amount)();
            succ = true;
        } else {
            IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(_curr)); //solhint-disable-line
            if (erc20.balanceOf(address(this)) < _amount) 
                _amount = erc20.balanceOf(address(this));
            require(erc20.transfer(address(p2), _amount)); 
            succ = true;
            
        }
    } 

    /** 
     * @dev Transfers ERC20 Currency asset from this Pool to another Pool on upgrade.
     */ 
    function _upgradeCapitalPool(
        bytes4 _curr,
        address _newPoolAddress
    ) 
        internal
    {
        IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(_curr));
        if (erc20.balanceOf(address(this)) > 0)
            require(erc20.transfer(_newPoolAddress, erc20.balanceOf(address(this))));
    }
    
    // step for ApiId
    uint256 public reqc;

    /**
     * @dev oraclize query
     * @return id of oraclize query
     */
    function _oraclizeQuery() 
        internal
        returns (bytes32 id)
    {
        id = keccak256(abi.encodePacked(this, msg.sender, reqc));
        reqc++;
    }
}



contract Pool2 is Iupgradable {
    using SafeMath for uint;

    MCR internal m1;
    Pool1 internal p1;
    PoolData internal pd;
    Factory internal factory;
    address public uniswapFactoryAddress;
    uint internal constant DECIMAL1E18 = uint(10) ** 18;
    bool internal locked;

    constructor(address _uniswapFactoryAdd) public {
       
        uniswapFactoryAddress = _uniswapFactoryAdd;
        factory = Factory(_uniswapFactoryAdd);
    }

    function() external payable {}

    event Liquidity(bytes16 typeOf, bytes16 functionName);

    event Rebalancing(bytes4 iaCurr, uint tokenAmount);

    modifier noReentrancy() {
        require(!locked, "Reentrant call.");
        locked = true;
        _;
        locked = false;
    }

    /**
     * @dev to change the uniswap factory address 
     * @param newFactoryAddress is the new factory address in concern
     * @return the status of the concerned coverId
     */
    function changeUniswapFactoryAddress(address newFactoryAddress) external onlyInternal {
        // require(ms.isOwner(msg.sender) || ms.checkIsAuthToGoverned(msg.sender));
        uniswapFactoryAddress = newFactoryAddress;
        factory = Factory(uniswapFactoryAddress);
    }

    /**
     * @dev On upgrade transfer all investment assets and ether to new Investment Pool
     * @param newPoolAddress New Investment Assest Pool address
     */
    function upgradeInvestmentPool(address payable newPoolAddress) external onlyInternal noReentrancy {
        uint len = pd.getInvestmentCurrencyLen();
        for (uint64 i = 1; i < len; i++) {
            bytes4 iaName = pd.getInvestmentCurrencyByIndex(i);
            _upgradeInvestmentPool(iaName, newPoolAddress);
        }

        if (address(this).balance > 0) {
            Pool2 newP2 = Pool2(newPoolAddress);
            newP2.sendEther.value(address(this).balance)();
        }
    }

    /**
     * @dev Internal Swap of assets between Capital 
     * and Investment Sub pool for excess or insufficient  
     * liquidity conditions of a given currency.
     */ 
    function internalLiquiditySwap(bytes4 curr) external onlyInternal noReentrancy {
        uint caBalance;
        uint baseMin;
        uint varMin;
        (, baseMin, varMin) = pd.getCurrencyAssetVarBase(curr);
        caBalance = _getCurrencyAssetsBalance(curr);

        if (caBalance > uint(baseMin).add(varMin).mul(2)) {
            _internalExcessLiquiditySwap(curr, baseMin, varMin, caBalance);
        } else if (caBalance < uint(baseMin).add(varMin)) {
            _internalInsufficientLiquiditySwap(curr, baseMin, varMin, caBalance);
            
        }
    }

    /**
     * @dev Saves a given investment asset details. To be called daily.
     * @param curr array of Investment asset name.
     * @param rate array of investment asset exchange rate.
     * @param date current date in yyyymmdd.
     */ 
    function saveIADetails(bytes4[] calldata curr, uint64[] calldata rate, uint64 date, bool bit) 
    external checkPause noReentrancy {
        bytes4 maxCurr;
        bytes4 minCurr;
        uint64 maxRate;
        uint64 minRate;
        //ONLY NOTARZIE ADDRESS CAN POST
        require(pd.isnotarise(msg.sender));
        (maxCurr, maxRate, minCurr, minRate) = _calculateIARank(curr, rate);
        pd.saveIARankDetails(maxCurr, maxRate, minCurr, minRate, date);
        pd.updatelastDate(date);
        uint len = curr.length;
        for (uint i = 0; i < len; i++) {
            pd.updateIAAvgRate(curr[i], rate[i]);
        }
    }

    /**
     * @dev External Trade for excess or insufficient  
     * liquidity conditions of a given currency.
     */ 
    function externalLiquidityTrade() external onlyInternal {
        
        bool triggerTrade;
        bytes4 curr;
        bytes4 minIACurr;
        bytes4 maxIACurr;
        uint amount;
        uint minIARate;
        uint maxIARate;
        uint baseMin;
        uint varMin;
        uint caBalance;


        (maxIACurr, maxIARate, minIACurr, minIARate) = pd.getIARankDetailsByDate(pd.getLastDate());
        uint len = pd.getAllCurrenciesLen();
        for (uint64 i = 0; i < len; i++) {
            curr = pd.getCurrenciesByIndex(i);
            (, baseMin, varMin) = pd.getCurrencyAssetVarBase(curr);
            caBalance = _getCurrencyAssetsBalance(curr);

            if (caBalance > uint(baseMin).add(varMin).mul(2)) { //excess
                amount = caBalance.sub(((uint(baseMin).add(varMin)).mul(3)).div(2)); //*10**18;
                triggerTrade = _externalExcessLiquiditySwap(curr, minIACurr, amount);
            } else if (caBalance < uint(baseMin).add(varMin)) { // insufficient
                amount = (((uint(baseMin).add(varMin)).mul(3)).div(2)).sub(caBalance);
                triggerTrade = _externalInsufficientLiquiditySwap(curr, maxIACurr, amount);
            }

            if (triggerTrade) {
                p1.triggerExternalLiquidityTrade();
            }
        }
    }

    /**
     * Iupgradable Interface to update dependent contract address
     */
    function changeDependentContractAddress() public onlyInternal {
        m1 = MCR(ms.getLatestAddress("MC"));
        pd = PoolData(ms.getLatestAddress("PD"));
        p1 = Pool1(ms.getLatestAddress("P1"));
    }

    function sendEther() public payable {
        
    }

    /** 
     * @dev Gets currency asset balance for a given currency name.
     */   
    function _getCurrencyAssetsBalance(bytes4 _curr) public view returns(uint caBalance) {
        if (_curr == "BNB") {
            caBalance = address(p1).balance;
        } else {
            IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(_curr));
            caBalance = erc20.balanceOf(address(p1));
        }
    }

    /** 
     * @dev Transfers ERC20 investment asset from this Pool to another Pool.
     */ 
    function _transferInvestmentAsset(
        bytes4 _curr,
        address _transferTo,
        uint _amount
    ) 
        internal
    {
        if (_curr == "BNB") {
            if (_amount > address(this).balance)
                _amount = address(this).balance;
            p1.sendEther.value(_amount)();
        } else {
            IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(_curr));
            if (_amount > erc20.balanceOf(address(this)))
                _amount = erc20.balanceOf(address(this));
            require(erc20.transfer(_transferTo, _amount));
        }
    }

    /**
     * @dev to perform rebalancing 
     * @param iaCurr is the investment asset currency
     * @param iaRate is the investment asset rate
     */
    function _rebalancingLiquidityTrading(
        bytes4 iaCurr,
        uint64 iaRate
    ) 
        internal
        checkPause
    {
        uint amountToSell;
        uint totalRiskBal = pd.getLastVfull();
        uint intermediaryEth;
        uint ethVol = pd.ethVolumeLimit();

        totalRiskBal = (totalRiskBal.mul(100000)).div(DECIMAL1E18);
        Exchange exchange;
        if (totalRiskBal > 0) {
            amountToSell = ((totalRiskBal.mul(2).mul(
                iaRate)).mul(pd.variationPercX100())).div(100 * 100 * 100000);
            amountToSell = (amountToSell.mul(
                10**uint(pd.getInvestmentAssetDecimals(iaCurr)))).div(100); // amount of asset to sell

            if (iaCurr != "BNB" && _checkTradeConditions(iaCurr, iaRate, totalRiskBal)) { 
                exchange = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(iaCurr)));
                intermediaryEth = exchange.getTokenToEthInputPrice(amountToSell);
                if (intermediaryEth > (address(exchange).balance.mul(ethVol)).div(100)) { 
                    intermediaryEth = (address(exchange).balance.mul(ethVol)).div(100);
                    amountToSell = (exchange.getEthToTokenInputPrice(intermediaryEth).mul(995)).div(1000);
                }
                IERC20 erc20;
                erc20 = IERC20(pd.getCurrencyAssetAddress(iaCurr));
                erc20.approve(address(exchange), amountToSell);
                exchange.tokenToEthSwapInput(amountToSell, (exchange.getTokenToEthInputPrice(
                    amountToSell).mul(995)).div(1000), pd.uniswapDeadline().add(now));
            } else if (iaCurr == "BNB" && _checkTradeConditions(iaCurr, iaRate, totalRiskBal)) {

                _transferInvestmentAsset(iaCurr, ms.getLatestAddress("P1"), amountToSell);
            }
            emit Rebalancing(iaCurr, amountToSell); 
        }
    }

    /**
     * @dev Checks whether trading is required for a  
     * given investment asset at a given exchange rate.
     */ 
    function _checkTradeConditions(
        bytes4 curr,
        uint64 iaRate,
        uint totalRiskBal
    )
        internal
        view
        returns(bool check)
    {
        if (iaRate > 0) {
            uint iaBalance =  _getInvestmentAssetBalance(curr).div(DECIMAL1E18);
            if (iaBalance > 0 && totalRiskBal > 0) {
                uint iaMax;
                uint iaMin;
                uint checkNumber;
                uint z;
                (iaMin, iaMax) = pd.getInvestmentAssetHoldingPerc(curr);
                z = pd.variationPercX100();
                checkNumber = (iaBalance.mul(100 * 100000)).div(totalRiskBal.mul(iaRate));
                if ((checkNumber > ((totalRiskBal.mul(iaMax.add(z))).mul(100000)).div(100)) ||
                    (checkNumber < ((totalRiskBal.mul(iaMin.sub(z))).mul(100000)).div(100)))
                    check = true; //eligibleIA
            }
        }
    }    

    /** 
     * @dev Gets the investment asset rank.
     */ 
    function _getIARank(
        bytes4 curr,
        uint64 rateX100,
        uint totalRiskPoolBalance
    ) 
        internal
        view
        returns (int rhsh, int rhsl) //internal function
    {

        uint currentIAmaxHolding;
        uint currentIAminHolding;
        uint iaBalance = _getInvestmentAssetBalance(curr);
        (currentIAminHolding, currentIAmaxHolding) = pd.getInvestmentAssetHoldingPerc(curr);
        
        if (rateX100 > 0) {
            uint rhsf;
            rhsf = (iaBalance.mul(1000000)).div(totalRiskPoolBalance.mul(rateX100));
            rhsh = int(rhsf - currentIAmaxHolding);
            rhsl = int(rhsf - currentIAminHolding);
        }
    }

    /** 
     * @dev Calculates the investment asset rank.
     */  
    function _calculateIARank(
        bytes4[] memory curr,
        uint64[] memory rate
    )
        internal
        view
        returns(
            bytes4 maxCurr,
            uint64 maxRate,
            bytes4 minCurr,
            uint64 minRate
        )  
    {
        int max = 0;
        int min = -1;
        int rhsh;
        int rhsl;
        uint totalRiskPoolBalance;
        (totalRiskPoolBalance, ) = m1.calVtpAndMCRtp();
        uint len = curr.length;
        for (uint i = 0; i < len; i++) {
            rhsl = 0;
            rhsh = 0;
            if (pd.getInvestmentAssetStatus(curr[i])) {
                (rhsh, rhsl) = _getIARank(curr[i], rate[i], totalRiskPoolBalance);
                if (rhsh > max || i == 0) {
                    max = rhsh;
                    maxCurr = curr[i];
                    maxRate = rate[i];
                }
                if (rhsl < min || rhsl == 0 || i == 0) {
                    min = rhsl;
                    minCurr = curr[i];
                    minRate = rate[i];
                }
            }
        }
    }

    /**
     * @dev to get balance of an investment asset 
     * @param _curr is the investment asset in concern
     * @return the balance
     */
    function _getInvestmentAssetBalance(bytes4 _curr) internal view returns (uint balance) {
        if (_curr == "BNB") {
            balance = address(this).balance;
        } else {
            IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(_curr));
            balance = erc20.balanceOf(address(this));
        }
    }

    /**
     * @dev Creates Excess liquidity trading order for a given currency and a given balance.
     */  
    function _internalExcessLiquiditySwap(bytes4 _curr, uint _baseMin, uint _varMin, uint _caBalance) internal {
        // require(ms.isInternal(msg.sender) || md.isnotarise(msg.sender));
        bytes4 minIACurr;
        // uint amount;
        
        (, , minIACurr, ) = pd.getIARankDetailsByDate(pd.getLastDate());
        if (_curr == minIACurr) {
            // amount = _caBalance.sub(((_baseMin.add(_varMin)).mul(3)).div(2)); //*10**18;
            p1.transferCurrencyAsset(_curr, _caBalance.sub(((_baseMin.add(_varMin)).mul(3)).div(2)));
        } else {
            p1.triggerExternalLiquidityTrade();
        }
    }

    /** 
     * @dev insufficient liquidity swap  
     * for a given currency and a given balance.
     */ 
    function _internalInsufficientLiquiditySwap(bytes4 _curr, uint _baseMin, uint _varMin, uint _caBalance) internal {
        
        bytes4 maxIACurr;
        uint amount;
        
        (maxIACurr, , , ) = pd.getIARankDetailsByDate(pd.getLastDate());
        
        if (_curr == maxIACurr) {
            amount = (((_baseMin.add(_varMin)).mul(3)).div(2)).sub(_caBalance);
            _transferInvestmentAsset(_curr, ms.getLatestAddress("P1"), amount);
        } else {
            IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(maxIACurr));
            if ((maxIACurr == "BNB" && address(this).balance > 0) || 
            (maxIACurr != "BNB" && erc20.balanceOf(address(this)) > 0))
                p1.triggerExternalLiquidityTrade();
            
        }
    }

    /**
     * @dev Creates External excess liquidity trading  
     * order for a given currency and a given balance.
     * @param curr Currency Asset to Sell
     * @param minIACurr Investment Asset to Buy  
     * @param amount Amount of Currency Asset to Sell
     */  
    function _externalExcessLiquiditySwap(
        bytes4 curr,
        bytes4 minIACurr,
        uint256 amount
    )
        internal
        returns (bool trigger)
    {
        uint intermediaryEth;
        Exchange exchange;
        IERC20 erc20;
        uint ethVol = pd.ethVolumeLimit();
        if (curr == minIACurr) {
            p1.transferCurrencyAsset(curr, amount);
        } else if (curr == "BNB" && minIACurr != "BNB") {
            
            exchange = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(minIACurr)));
            if (amount > (address(exchange).balance.mul(ethVol)).div(100)) { // 4% BNB volume limit 
                amount = (address(exchange).balance.mul(ethVol)).div(100);
                trigger = true;
            }
            p1.transferCurrencyAsset(curr, amount);
            exchange.ethToTokenSwapInput.value(amount)
            (exchange.getEthToTokenInputPrice(amount).mul(995).div(1000), pd.uniswapDeadline().add(now));    
        } else if (curr != "BNB" && minIACurr == "BNB") {
            exchange = Exchange(factory.getExchange(pd.getCurrencyAssetAddress(curr)));
            erc20 = IERC20(pd.getCurrencyAssetAddress(curr));
            intermediaryEth = exchange.getTokenToEthInputPrice(amount);

            if (intermediaryEth > (address(exchange).balance.mul(ethVol)).div(100)) { 
                intermediaryEth = (address(exchange).balance.mul(ethVol)).div(100);
                amount = exchange.getEthToTokenInputPrice(intermediaryEth);
                intermediaryEth = exchange.getTokenToEthInputPrice(amount);
                trigger = true;
            }
            p1.transferCurrencyAsset(curr, amount);
            // erc20.decreaseAllowance(address(exchange), erc20.allowance(address(this), address(exchange)));
            erc20.approve(address(exchange), amount);
            
            exchange.tokenToEthSwapInput(amount, (
                intermediaryEth.mul(995)).div(1000), pd.uniswapDeadline().add(now));   
        } else {
            
            exchange = Exchange(factory.getExchange(pd.getCurrencyAssetAddress(curr)));
            intermediaryEth = exchange.getTokenToEthInputPrice(amount);

            if (intermediaryEth > (address(exchange).balance.mul(ethVol)).div(100)) { 
                intermediaryEth = (address(exchange).balance.mul(ethVol)).div(100);
                amount = exchange.getEthToTokenInputPrice(intermediaryEth);
                trigger = true;
            }
            
            Exchange tmp = Exchange(factory.getExchange(
                pd.getInvestmentAssetAddress(minIACurr))); // minIACurr exchange

            if (intermediaryEth > address(tmp).balance.mul(ethVol).div(100)) { 
                intermediaryEth = address(tmp).balance.mul(ethVol).div(100);
                amount = exchange.getEthToTokenInputPrice(intermediaryEth);
                trigger = true;   
            }
            p1.transferCurrencyAsset(curr, amount);
            erc20 = IERC20(pd.getCurrencyAssetAddress(curr));
            erc20.approve(address(exchange), amount);
            
            exchange.tokenToTokenSwapInput(amount, (tmp.getEthToTokenInputPrice(
                intermediaryEth).mul(995)).div(1000), (intermediaryEth.mul(995)).div(1000), 
                    pd.uniswapDeadline().add(now), pd.getInvestmentAssetAddress(minIACurr));
        }
    }

    /** 
     * @dev insufficient liquidity swap  
     * for a given currency and a given balance.
     * @param curr Currency Asset to buy
     * @param maxIACurr Investment Asset to sell
     * @param amount Amount of Investment Asset to sell
     */ 
    function _externalInsufficientLiquiditySwap(
        bytes4 curr,
        bytes4 maxIACurr,
        uint256 amount
    ) 
        internal
        returns (bool trigger)
    {   

        Exchange exchange;
        IERC20 erc20;
        uint intermediaryEth;
        // uint ethVol = pd.ethVolumeLimit();
        if (curr == maxIACurr) {
            _transferInvestmentAsset(curr, ms.getLatestAddress("P1"), amount);
        } else if (curr == "BNB" && maxIACurr != "BNB") { 
            exchange = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(maxIACurr)));
            intermediaryEth = exchange.getEthToTokenInputPrice(amount);


            if (amount > (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100)) { 
                amount = (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100);
                // amount = exchange.getEthToTokenInputPrice(intermediaryEth);
                intermediaryEth = exchange.getEthToTokenInputPrice(amount);
                trigger = true;
            }
            
            erc20 = IERC20(pd.getCurrencyAssetAddress(maxIACurr));
            if (intermediaryEth > erc20.balanceOf(address(this))) {
                intermediaryEth = erc20.balanceOf(address(this));
            }
            // erc20.decreaseAllowance(address(exchange), erc20.allowance(address(this), address(exchange)));
            erc20.approve(address(exchange), intermediaryEth);
            exchange.tokenToEthTransferInput(intermediaryEth, (
                exchange.getTokenToEthInputPrice(intermediaryEth).mul(995)).div(1000), 
                pd.uniswapDeadline().add(now), address(p1)); 

        } else if (curr != "BNB" && maxIACurr == "BNB") {
            exchange = Exchange(factory.getExchange(pd.getCurrencyAssetAddress(curr)));
            intermediaryEth = exchange.getTokenToEthInputPrice(amount);
            if (intermediaryEth > address(this).balance)
                intermediaryEth = address(this).balance;
            if (intermediaryEth > (address(exchange).balance.mul
            (pd.ethVolumeLimit())).div(100)) { // 4% BNB volume limit 
                intermediaryEth = (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100);
                trigger = true;
            }
            exchange.ethToTokenTransferInput.value(intermediaryEth)((exchange.getEthToTokenInputPrice(
                intermediaryEth).mul(995)).div(1000), pd.uniswapDeadline().add(now), address(p1));   
        } else {
            address currAdd = pd.getCurrencyAssetAddress(curr);
            exchange = Exchange(factory.getExchange(currAdd));
            intermediaryEth = exchange.getTokenToEthInputPrice(amount);
            if (intermediaryEth > (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100)) { 
                intermediaryEth = (address(exchange).balance.mul(pd.ethVolumeLimit())).div(100);
                trigger = true;
            }
            Exchange tmp = Exchange(factory.getExchange(pd.getInvestmentAssetAddress(maxIACurr)));

            if (intermediaryEth > address(tmp).balance.mul(pd.ethVolumeLimit()).div(100)) { 
                intermediaryEth = address(tmp).balance.mul(pd.ethVolumeLimit()).div(100);
                // amount = exchange.getEthToTokenInputPrice(intermediaryEth);
                trigger = true;
            }

            uint maxIAToSell = tmp.getEthToTokenInputPrice(intermediaryEth);

            erc20 = IERC20(pd.getInvestmentAssetAddress(maxIACurr));
            uint maxIABal = erc20.balanceOf(address(this));
            if (maxIAToSell > maxIABal) {
                maxIAToSell = maxIABal;
                intermediaryEth = tmp.getTokenToEthInputPrice(maxIAToSell);
                // amount = exchange.getEthToTokenInputPrice(intermediaryEth);
            }
            amount = exchange.getEthToTokenInputPrice(intermediaryEth);
            erc20.approve(address(tmp), maxIAToSell);
            tmp.tokenToTokenTransferInput(maxIAToSell, (
                amount.mul(995)).div(1000), (
                    intermediaryEth), pd.uniswapDeadline().add(now), address(p1), currAdd);
        }
    }

    /** 
     * @dev Transfers ERC20 investment asset from this Pool to another Pool.
     */ 
    function _upgradeInvestmentPool(
        bytes4 _curr,
        address _newPoolAddress
    ) 
        internal
    {
        IERC20 erc20 = IERC20(pd.getInvestmentAssetAddress(_curr));
        if (erc20.balanceOf(address(this)) > 0)
            require(erc20.transfer(_newPoolAddress, erc20.balanceOf(address(this))));
    }
}

contract Claims is Iupgradable {
    using SafeMath for uint;

    
    TokenFunctions internal tf;
    RANCEToken internal tk;
    TokenController internal tc;
    ClaimsReward internal cr;
    Pool1 internal p1;
    ClaimsData internal cd;
    TokenData internal td;
    PoolData internal pd;
    Pool2 internal p2;
    QuotationData internal qd;
    MCR internal m1;

    uint private constant DECIMAL1E18 = uint(10) ** 18;
    
    /**
     * @dev Sets the status of claim using claim id.
     * @param claimId claim id.
     * @param stat status to be set.
     */ 
    function setClaimStatus(uint claimId, uint stat) external onlyInternal {
        _setClaimStatus(claimId, stat);
    }

    /**
     * @dev Gets claim details of claim id = pending claim start + given index
     */ 
    function getClaimFromNewStart(
        uint index
    )
        external 
        view 
        returns (
            uint coverId,
            uint claimId,
            int8 voteCA,
            int8 voteMV,
            uint statusnumber
        ) 
    {
        (coverId, claimId, voteCA, voteMV, statusnumber) = cd.getClaimFromNewStart(index, msg.sender);
        // status = rewardStatus[statusnumber].claimStatusDesc;
    }

    /**
     * @dev Gets details of a claim submitted by the calling user, at a given index
     */
    function getUserClaimByIndex(
        uint index
    )
        external
        view 
        returns(
            uint status,
            uint coverId,
            uint claimId
        )
    {
        uint statusno;
        (statusno, coverId, claimId) = cd.getUserClaimByIndex(index, msg.sender);
        status = statusno;
    }

    /**
     * @dev Gets details of a given claim id.
     * @param _claimId Claim Id.
     * @return status Current status of claim id
     * @return finalVerdict Decision made on the claim, 1 -> acceptance, -1 -> denial
     * @return claimOwner Address through which claim is submitted
     * @return coverId Coverid associated with the claim id
     */
    function getClaimbyIndex(uint _claimId) external view returns (
        uint claimId,
        uint status,
        int8 finalVerdict,
        address claimOwner,
        uint coverId
    )
    {
        uint stat;
        claimId = _claimId;
        (, coverId, finalVerdict, stat, , ) = cd.getClaim(_claimId);
        claimOwner = qd.getCoverMemberAddress(coverId);
        status = stat;
    }

    /**
     * @dev Calculates total amount that has been used to assess a claim.
     * Computaion:Adds acceptCA(tokens used for voting in favor of a claim)
     * denyCA(tokens used for voting against a claim) *  current token price.
     * @param claimId Claim Id.
     * @param member Member type 0 -> Claim Assessors, else members.
     * @return tokens Total Amount used in Claims assessment.
     */ 
    function getCATokens(uint claimId, uint member) external view returns(uint tokens) {
        uint coverId;
        (, coverId) = cd.getClaimCoverId(claimId);
        bytes4 curr = qd.getCurrencyOfCover(coverId);
        uint tokenx1e18 = m1.calculateTokenPrice(curr);
        uint accept;
        uint deny;
        if (member == 0) {
            (, accept, deny) = cd.getClaimsTokenCA(claimId);
        } else {
            (, accept, deny) = cd.getClaimsTokenMV(claimId);
        }
        tokens = ((accept.add(deny)).mul(tokenx1e18)).div(DECIMAL1E18); // amount (not in tokens)
    }

    /**
     * Iupgradable Interface to update dependent contract address
     */
    function changeDependentContractAddress() public onlyInternal {
        tk = RANCEToken(ms.tokenAddress());
        td = TokenData(ms.getLatestAddress("TD"));
        tf = TokenFunctions(ms.getLatestAddress("TF"));
        tc = TokenController(ms.getLatestAddress("TC"));
        p1 = Pool1(ms.getLatestAddress("P1"));
        p2 = Pool2(ms.getLatestAddress("P2"));
        pd = PoolData(ms.getLatestAddress("PD"));
        cr = ClaimsReward(ms.getLatestAddress("CR"));
        cd = ClaimsData(ms.getLatestAddress("CD"));
        qd = QuotationData(ms.getLatestAddress("QD"));
        m1 = MCR(ms.getLatestAddress("MC"));
    }

    /**
     * @dev Updates the pending claim start variable,
     * the lowest claim id with a pending decision/payout.
     */ 
    function changePendingClaimStart() public onlyInternal {

        uint origstat;
        uint state12Count;
        uint pendingClaimStart = cd.pendingClaimStart();
        uint actualClaimLength = cd.actualClaimLength();
        for (uint i = pendingClaimStart; i < actualClaimLength; i++) {
            (, , , origstat, , state12Count) = cd.getClaim(i);

            if (origstat > 5 && ((origstat != 12) || (origstat == 12 && state12Count >= 60)))
                cd.setpendingClaimStart(i);
            else
                break;
        }
    }

    /**
     * @dev Submits a claim for a given cover note.
     * Adds claim to queue incase of emergency pause else directly submits the claim.
     * @param coverId Cover Id.
     */ 
    function submitClaim(uint coverId) public {
        address qadd = qd.getCoverMemberAddress(coverId);
        require(qadd == msg.sender);
        uint8 cStatus;
        (, cStatus, , , ) = qd.getCoverDetailsByCoverID2(coverId);
        require(cStatus != uint8(QuotationData.CoverStatus.ClaimSubmitted), "Claim already submitted");
        require(cStatus != uint8(QuotationData.CoverStatus.CoverExpired), "Cover already expired");
        if (ms.isPause() == false) {
            _addClaim(coverId, now, qadd);
        } else {
            cd.setClaimAtEmergencyPause(coverId, now, false);
            qd.changeCoverStatusNo(coverId, uint8(QuotationData.CoverStatus.Requested));
        }
    }

    /**
     * @dev Submits the Claims queued once the emergency pause is switched off.
     */
    function submitClaimAfterEPOff() public onlyInternal {
        uint lengthOfClaimSubmittedAtEP = cd.getLengthOfClaimSubmittedAtEP();
        uint firstClaimIndexToSubmitAfterEP = cd.getFirstClaimIndexToSubmitAfterEP();
        uint coverId;
        uint dateUpd;
        bool submit;
        address qadd;
        for (uint i = firstClaimIndexToSubmitAfterEP; i < lengthOfClaimSubmittedAtEP; i++) {
            (coverId, dateUpd, submit) = cd.getClaimOfEmergencyPauseByIndex(i);
            require(submit == false);
            qadd = qd.getCoverMemberAddress(coverId);
            _addClaim(coverId, dateUpd, qadd);
            cd.setClaimSubmittedAtEPTrue(i, true);
        }
        cd.setFirstClaimIndexToSubmitAfterEP(lengthOfClaimSubmittedAtEP);
    }

    /**
     * @dev Castes vote for members who have tokens locked under Claims Assessment
     * @param claimId  claim id.
     * @param verdict 1 for Accept,-1 for Deny.
     */ 
    function submitCAVote(uint claimId, int8 verdict) public isMemberAndcheckPause {
        require(checkVoteClosing(claimId) != 1); 
        require(cd.userClaimVotePausedOn(msg.sender).add(cd.pauseDaysCA()) < now);  
        uint tokens = tc.tokensLockedAtTime(msg.sender, "CLA", now.add(cd.claimDepositTime()));
        require(tokens > 0);
        uint stat;
        (, stat) = cd.getClaimStatusNumber(claimId);
        require(stat == 0);
        require(cd.getUserClaimVoteCA(msg.sender, claimId) == 0);
        td.bookCATokens(msg.sender);
        cd.addVote(msg.sender, tokens, claimId, verdict);
        cd.callVoteEvent(msg.sender, claimId, "CAV", tokens, now, verdict);
        uint voteLength = cd.getAllVoteLength();
        cd.addClaimVoteCA(claimId, voteLength);
        cd.setUserClaimVoteCA(msg.sender, claimId, voteLength);
        cd.setClaimTokensCA(claimId, verdict, tokens);
        tc.extendLockOf(msg.sender, "CLA", td.lockCADays());
        int close = checkVoteClosing(claimId);
        if (close == 1) {
            cr.changeClaimStatus(claimId);
        }
    }

    /**
     * @dev Submits a member vote for assessing a claim.
     * Tokens other than those locked under Claims
     * Assessment can be used to cast a vote for a given claim id.
     * @param claimId Selected claim id.
     * @param verdict 1 for Accept,-1 for Deny.
     */ 
    function submitMemberVote(uint claimId, int8 verdict) public isMemberAndcheckPause {
        require(checkVoteClosing(claimId) != 1);
        uint stat;
        uint tokens = tc.totalBalanceOf(msg.sender);
        (, stat) = cd.getClaimStatusNumber(claimId);
        require(stat >= 1 && stat <= 5);
        require(cd.getUserClaimVoteMember(msg.sender, claimId) == 0);
        cd.addVote(msg.sender, tokens, claimId, verdict);
        cd.callVoteEvent(msg.sender, claimId, "MV", tokens, now, verdict);
        tc.lockForMemberVote(msg.sender, td.lockMVDays());
        uint voteLength = cd.getAllVoteLength();
        cd.addClaimVotemember(claimId, voteLength);
        cd.setUserClaimVoteMember(msg.sender, claimId, voteLength);
        cd.setClaimTokensMV(claimId, verdict, tokens);
        int close = checkVoteClosing(claimId);
        if (close == 1) {
            cr.changeClaimStatus(claimId);
        }
    }

    /**
    * @dev Pause Voting of All Pending Claims when Emergency Pause Start.
    */ 
    function pauseAllPendingClaimsVoting() public onlyInternal {
        uint firstIndex = cd.pendingClaimStart();
        uint actualClaimLength = cd.actualClaimLength();
        for (uint i = firstIndex; i < actualClaimLength; i++) {
            if (checkVoteClosing(i) == 0) {
                uint dateUpd = cd.getClaimDateUpd(i);
                cd.setPendingClaimDetails(i, (dateUpd.add(cd.maxVotingTime())).sub(now), false);
            }
        }
    }

    /**
     * @dev Resume the voting phase of all Claims paused due to an emergency pause.
     */
    function startAllPendingClaimsVoting() public onlyInternal {
        uint firstIndx = cd.getFirstClaimIndexToStartVotingAfterEP();
        uint i;
        uint lengthOfClaimVotingPause = cd.getLengthOfClaimVotingPause();
        for (i = firstIndx; i < lengthOfClaimVotingPause; i++) {
            uint pendingTime;
            uint claimID;
            (claimID, pendingTime, ) = cd.getPendingClaimDetailsByIndex(i);
            uint pTime = (now.sub(cd.maxVotingTime())).add(pendingTime);
            cd.setClaimdateUpd(claimID, pTime);
            cd.setPendingClaimVoteStatus(i, true);
            uint coverid;
            (, coverid) = cd.getClaimCoverId(claimID);
            address qadd = qd.getCoverMemberAddress(coverid);
            tf.extendCNEPOff(qadd, coverid, pendingTime.add(cd.claimDepositTime()));
            p1.closeClaimsOraclise(claimID, uint64(pTime));
        }
        cd.setFirstClaimIndexToStartVotingAfterEP(i);
    }

    /**
     * @dev Checks if voting of a claim should be closed or not.
     * @param claimId Claim Id.
     * @return close 1 -> voting should be closed, 0 -> if voting should not be closed,
     * -1 -> voting has already been closed.
     */ 
    function checkVoteClosing(uint claimId) public view returns(int8 close) {
        close = 0;
        uint status;
        (, status) = cd.getClaimStatusNumber(claimId);
        uint dateUpd = cd.getClaimDateUpd(claimId);
        if (status == 12 && dateUpd.add(cd.payoutRetryTime()) < now) {
            if (cd.getClaimState12Count(claimId) < 60)
                close = 1;
        } 
        
        if (status > 5 && status != 12) {
            close = -1;
        }  else if (status != 12 && dateUpd.add(cd.maxVotingTime()) <= now) {
            close = 1;
        } else if (status != 12 && dateUpd.add(cd.minVotingTime()) >= now) {
            close = 0;
        } else if (status == 0 || (status >= 1 && status <= 5)) {
            close = _checkVoteClosingFinal(claimId, status);
        }
        
    }

    /**
     * @dev Checks if voting of a claim should be closed or not.
     * Internally called by checkVoteClosing method
     * for Claims whose status number is 0 or status number lie between 2 and 6.
     * @param claimId Claim Id.
     * @param status Current status of claim.
     * @return close 1 if voting should be closed,0 in case voting should not be closed,
     * -1 if voting has already been closed.
     */
    function _checkVoteClosingFinal(uint claimId, uint status) internal view returns(int8 close) {
        close = 0;
        uint coverId;
        (, coverId) = cd.getClaimCoverId(claimId);
        bytes4 curr = qd.getCurrencyOfCover(coverId);
        uint tokenx1e18 = m1.calculateTokenPrice(curr);
        uint accept;
        uint deny;
        (, accept, deny) = cd.getClaimsTokenCA(claimId);
        uint caTokens = ((accept.add(deny)).mul(tokenx1e18)).div(DECIMAL1E18);
        (, accept, deny) = cd.getClaimsTokenMV(claimId);
        uint mvTokens = ((accept.add(deny)).mul(tokenx1e18)).div(DECIMAL1E18);
        uint sumassured = qd.getCoverSumAssured(coverId).mul(DECIMAL1E18);
        if (status == 0 && caTokens >= sumassured.mul(10)) {
            close = 1;
        } else if (status >= 1 && status <= 5 && mvTokens >= sumassured.mul(10)) {
            close = 1;
        }
    }

    /**
     * @dev Changes the status of an existing claim id, based on current 
     * status and current conditions of the system
     * @param claimId Claim Id.
     * @param stat status number.  
     */
    function _setClaimStatus(uint claimId, uint stat) internal {

        uint origstat;
        uint state12Count;
        uint dateUpd;
        uint coverId;
        (, coverId, , origstat, dateUpd, state12Count) = cd.getClaim(claimId);
        (, origstat) = cd.getClaimStatusNumber(claimId);

        if (stat == 12 && origstat == 12) {
            cd.updateState12Count(claimId, 1);
        }
        cd.setClaimStatus(claimId, stat);

        if (state12Count >= 60 && stat == 12) {
            cd.setClaimStatus(claimId, 13);
            qd.changeCoverStatusNo(coverId, uint8(QuotationData.CoverStatus.ClaimDenied));
        }
        uint time = now;
        cd.setClaimdateUpd(claimId, time);

        if (stat >= 2 && stat <= 5) {
            p1.closeClaimsOraclise(claimId, cd.maxVotingTime());
        }

        if (stat == 12 && (dateUpd.add(cd.payoutRetryTime()) <= now) && (state12Count < 60)) {
            p1.closeClaimsOraclise(claimId, cd.payoutRetryTime());
        } else if (stat == 12 && (dateUpd.add(cd.payoutRetryTime()) > now) && (state12Count < 60)) {
            uint64 timeLeft = uint64((dateUpd.add(cd.payoutRetryTime())).sub(now));
            p1.closeClaimsOraclise(claimId, timeLeft);
        }
    }

    /**
     * @dev Submits a claim for a given cover note.
     * Set deposits flag against cover.
     */
    function _addClaim(uint coverId, uint time, address add) internal {
        tf.depositCN(coverId);
        uint len = cd.actualClaimLength();
        cd.addClaim(len, coverId, add, now);
        cd.callClaimEvent(coverId, add, len, time);
        qd.changeCoverStatusNo(coverId, uint8(QuotationData.CoverStatus.ClaimSubmitted));
        bytes4 curr = qd.getCurrencyOfCover(coverId);
        uint sumAssured = qd.getCoverSumAssured(coverId).mul(DECIMAL1E18);
        pd.changeCurrencyAssetVarMin(curr, pd.getCurrencyAssetVarMin(curr).add(sumAssured));
        p2.internalLiquiditySwap(curr);
        p1.closeClaimsOraclise(len, cd.maxVotingTime());
    }
}

contract ClaimsReward is Iupgradable {
     using SafeMath for uint;

    RANCEToken internal tk;
    TokenController internal tc;
    TokenFunctions internal tf;
    TokenData internal td;
    QuotationData internal qd;
    Claims internal c1;
    ClaimsData internal cd;
    Pool1 internal p1;
    Pool2 internal p2;
    PoolData internal pd;
    Governance internal gv;
    IPooledStaking internal pooledStaking;

    uint private constant DECIMAL1E18 = uint(10) ** 18;

    function changeDependentContractAddress() public onlyInternal {
        c1 = Claims(ms.getLatestAddress("CL"));
        cd = ClaimsData(ms.getLatestAddress("CD"));
        tk = RANCEToken(ms.tokenAddress());
        tc = TokenController(ms.getLatestAddress("TC"));
        td = TokenData(ms.getLatestAddress("TD"));
        tf = TokenFunctions(ms.getLatestAddress("TF"));
        p1 = Pool1(ms.getLatestAddress("P1"));
        p2 = Pool2(ms.getLatestAddress("P2"));
        pd = PoolData(ms.getLatestAddress("PD"));
        qd = QuotationData(ms.getLatestAddress("QD"));
        gv = Governance(ms.getLatestAddress("GV"));
        pooledStaking = IPooledStaking(ms.getLatestAddress("PS"));
    }

    /// @dev Decides the next course of action for a given claim.
    function changeClaimStatus(uint claimid) public checkPause onlyInternal {

        uint coverid;
        (, coverid) = cd.getClaimCoverId(claimid);

        uint status;
        (, status) = cd.getClaimStatusNumber(claimid);

        // when current status is "Pending-Claim Assessor Vote"
        if (status == 0) {
            _changeClaimStatusCA(claimid, coverid, status);
        } else if (status >= 1 && status <= 5) {
            _changeClaimStatusMV(claimid, coverid, status);
        } else if (status == 12) { // when current status is "Claim Accepted Payout Pending"

            uint sumAssured = qd.getCoverSumAssured(coverid).mul(DECIMAL1E18);
            address payable coverHolder = qd.getCoverMemberAddress(coverid);
            bytes4 coverCurrency = qd.getCurrencyOfCover(coverid);
            bool success = p1.sendClaimPayout(coverid, claimid, sumAssured, coverHolder, coverCurrency);

            if (success) {
                tf.burnStakedTokens(coverid, coverCurrency, sumAssured);
                c1.setClaimStatus(claimid, 14);
            }
        }

        c1.changePendingClaimStart();
    }

    /// @dev Amount of tokens to be rewarded to a user for a particular vote id.
    /// @param check 1 -> CA vote, else member vote
    /// @param voteid vote id for which reward has to be Calculated
    /// @param flag if 1 calculate even if claimed,else don't calculate if already claimed
    /// @return tokenCalculated reward to be given for vote id
    /// @return lastClaimedCheck true if final verdict is still pending for that voteid
    /// @return tokens number of tokens locked under that voteid
    /// @return perc percentage of reward to be given.
    function getRewardToBeGiven(
        uint check,
        uint voteid,
        uint flag
    )
        public
        view
        returns (
            uint tokenCalculated,
            bool lastClaimedCheck,
            uint tokens,
            uint perc
        )

    {
        uint claimId;
        int8 verdict;
        bool claimed;
        uint tokensToBeDist;
        uint totalTokens;
        (tokens, claimId, verdict, claimed) = cd.getVoteDetails(voteid);
        lastClaimedCheck = false;
        int8 claimVerdict = cd.getFinalVerdict(claimId);
        if (claimVerdict == 0) {
            lastClaimedCheck = true;
        }

        if (claimVerdict == verdict && (claimed == false || flag == 1)) {

            if (check == 1) {
                (perc, , tokensToBeDist) = cd.getClaimRewardDetail(claimId);
            } else {
                (, perc, tokensToBeDist) = cd.getClaimRewardDetail(claimId);
            }

            if (perc > 0) {
                if (check == 1) {
                    if (verdict == 1) {
                        (, totalTokens, ) = cd.getClaimsTokenCA(claimId);
                    } else {
                        (, , totalTokens) = cd.getClaimsTokenCA(claimId);
                    }
                } else {
                    if (verdict == 1) {
                        (, totalTokens, ) = cd.getClaimsTokenMV(claimId);
                    }else {
                        (, , totalTokens) = cd.getClaimsTokenMV(claimId);
                    }
                }
                tokenCalculated = (perc.mul(tokens).mul(tokensToBeDist)).div(totalTokens.mul(100));


            }
        }
    }

    /// @dev Transfers all tokens held by contract to a new contract in case of upgrade.
    function upgrade(address _newAdd) public onlyInternal {
        uint amount = tk.balanceOf(address(this));
        if (amount > 0) {
            require(tk.transfer(_newAdd, amount));
        }

    }

    /// @dev Total reward in token due for claim by a user.
    /// @return total total number of tokens
    function getRewardToBeDistributedByUser(address _add) public view returns(uint total) {
        uint lengthVote = cd.getVoteAddressCALength(_add);
        uint lastIndexCA;
        uint lastIndexMV;
        uint tokenForVoteId;
        uint voteId;
        (lastIndexCA, lastIndexMV) = cd.getRewardDistributedIndex(_add);

        for (uint i = lastIndexCA; i < lengthVote; i++) {
            voteId = cd.getVoteAddressCA(_add, i);
            (tokenForVoteId, , , ) = getRewardToBeGiven(1, voteId, 0);
            total = total.add(tokenForVoteId);
        }

        lengthVote = cd.getVoteAddressMemberLength(_add);

        for (uint j = lastIndexMV; j < lengthVote; j++) {
            voteId = cd.getVoteAddressMember(_add, j);
            (tokenForVoteId, , , ) = getRewardToBeGiven(0, voteId, 0);
            total = total.add(tokenForVoteId);
        }
        return (total);
    }

    /// @dev Gets reward amount and claiming status for a given claim id.
    /// @return reward amount of tokens to user.
    /// @return claimed true if already claimed false if yet to be claimed.
    function getRewardAndClaimedStatus(uint check, uint claimId) public view returns(uint reward, bool claimed) {
        uint voteId;
        uint claimid;
        uint lengthVote;

        if (check == 1) {
            lengthVote = cd.getVoteAddressCALength(msg.sender);
            for (uint i = 0; i < lengthVote; i++) {
                voteId = cd.getVoteAddressCA(msg.sender, i);
                (, claimid, , claimed) = cd.getVoteDetails(voteId);
                if (claimid == claimId) { break; }
            }
        } else {
            lengthVote = cd.getVoteAddressMemberLength(msg.sender);
            for (uint j = 0; j < lengthVote; j++) {
                voteId = cd.getVoteAddressMember(msg.sender, j);
                (, claimid, , claimed) = cd.getVoteDetails(voteId);
                if (claimid == claimId) { break; }
            }
        }
        (reward, , , ) = getRewardToBeGiven(check, voteId, 1);

    }

    /**
     * @dev Function used to claim all pending rewards : Claims Assessment + Risk Assessment + Governance
     * Claim assesment, Risk assesment, Governance rewards
     */
    function claimAllPendingReward(uint records) public isMemberAndcheckPause {
        _claimRewardToBeDistributed(records);
        pooledStaking.withdrawReward(msg.sender);
        uint governanceRewards = gv.claimReward(msg.sender, records);
        if (governanceRewards > 0) {
            require(tk.transfer(msg.sender, governanceRewards));
        }
    }
    
    /**
     * @dev Function used to claim all pending rewards : Claims Assessment + Risk Assessment
     * Claim assesment, Risk assesment
     */
    function claimPendingReward(uint records) public isMemberAndcheckPause {
        _claimRewardToBeDistributed(records);
        pooledStaking.withdrawReward(msg.sender);
    }
    
    /**
     * @dev Function used to get pending rewards of a particular user address.
     * @param _add user address.
     * @return total reward amount of the user
     */
    function getPendingRewardOfUser(address _add) public view returns(uint) {
        uint caReward = getRewardToBeDistributedByUser(_add);
        uint pooledStakingReward = pooledStaking.stakerReward(_add);
        return caReward.add(pooledStakingReward);
    }

    /**
     * @dev Function used to get pending rewards of a particular user address.
     * @param _add user address.
     * @return total reward amount of the user
     */
    function getAllPendingRewardOfUser(address _add) public view returns(uint) {
        uint caReward = getRewardToBeDistributedByUser(_add);
        uint pooledStakingReward = pooledStaking.stakerReward(_add);
        uint governanceReward = gv.getPendingReward(_add);
        return caReward.add(pooledStakingReward).add(governanceReward);
    }

    /// @dev Rewards/Punishes users who  participated in Claims assessment.
    //    Unlocking and burning of the tokens will also depend upon the status of claim.
    /// @param claimid Claim Id.
    function _rewardAgainstClaim(uint claimid, uint coverid, uint sumAssured, uint status) internal {
        uint premiumRANCE = qd.getCoverPremiumRANCE(coverid);
        bytes4 curr = qd.getCurrencyOfCover(coverid);
        uint distributableTokens = premiumRANCE.mul(cd.claimRewardPerc()).div(100);//  20% of premium

        uint percCA;
        uint percMV;

        (percCA, percMV) = cd.getRewardStatus(status);
        cd.setClaimRewardDetail(claimid, percCA, percMV, distributableTokens);
        if (percCA > 0 || percMV > 0) {
            tc.mint(address(this), distributableTokens);
        }

        if (status == 6 || status == 9 || status == 11) {
            cd.changeFinalVerdict(claimid, -1);
            td.setDepositCN(coverid, false); // Unset flag
            tf.burnDepositCN(coverid); // burn Deposited CN

            pd.changeCurrencyAssetVarMin(curr, pd.getCurrencyAssetVarMin(curr).sub(sumAssured));
            p2.internalLiquiditySwap(curr);

        } else if (status == 7 || status == 8 || status == 10) {
            cd.changeFinalVerdict(claimid, 1);
            td.setDepositCN(coverid, false); // Unset flag
            tf.unlockCN(coverid);
            bool success = p1.sendClaimPayout(coverid, claimid, sumAssured, qd.getCoverMemberAddress(coverid), curr);
            if (success) {
                tf.burnStakedTokens(coverid, curr, sumAssured);
            }
        }
    }

    /// @dev Computes the result of Claim Assessors Voting for a given claim id.
    function _changeClaimStatusCA(uint claimid, uint coverid, uint status) internal {
        // Check if voting should be closed or not
        if (c1.checkVoteClosing(claimid) == 1) {
            uint caTokens = c1.getCATokens(claimid, 0); // converted in cover currency.
            uint accept;
            uint deny;
            uint acceptAndDeny;
            bool rewardOrPunish;
            uint sumAssured;
            (, accept) = cd.getClaimVote(claimid, 1);
            (, deny) = cd.getClaimVote(claimid, -1);
            acceptAndDeny = accept.add(deny);
            accept = accept.mul(100);
            deny = deny.mul(100);

            if (caTokens == 0) {
                status = 3;
            } else {
                sumAssured = qd.getCoverSumAssured(coverid).mul(DECIMAL1E18);
                // Min threshold reached tokens used for voting > 5* sum assured
                if (caTokens > sumAssured.mul(5)) {

                    if (accept.div(acceptAndDeny) > 70) {
                        status = 7;
                        qd.changeCoverStatusNo(coverid, uint8(QuotationData.CoverStatus.ClaimAccepted));
                        rewardOrPunish = true;
                    } else if (deny.div(acceptAndDeny) > 70) {
                        status = 6;
                        qd.changeCoverStatusNo(coverid, uint8(QuotationData.CoverStatus.ClaimDenied));
                        rewardOrPunish = true;
                    } else if (accept.div(acceptAndDeny) > deny.div(acceptAndDeny)) {
                        status = 4;
                    } else {
                        status = 5;
                    }

                } else {

                    if (accept.div(acceptAndDeny) > deny.div(acceptAndDeny)) {
                        status = 2;
                    } else {
                        status = 3;
                    }
                }
            }

            c1.setClaimStatus(claimid, status);

            if (rewardOrPunish) {
                _rewardAgainstClaim(claimid, coverid, sumAssured, status);
            }
        }
    }

    /// @dev Computes the result of Member Voting for a given claim id.
    function _changeClaimStatusMV(uint claimid, uint coverid, uint status) internal {

        // Check if voting should be closed or not
        if (c1.checkVoteClosing(claimid) == 1) {
            uint8 coverStatus;
            uint statusOrig = status;
            uint mvTokens = c1.getCATokens(claimid, 1); // converted in cover currency.

            // If tokens used for acceptance >50%, claim is accepted
            uint sumAssured = qd.getCoverSumAssured(coverid).mul(DECIMAL1E18);
            uint thresholdUnreached = 0;
            // Minimum threshold for member voting is reached only when
            // value of tokens used for voting > 5* sum assured of claim id
            if (mvTokens < sumAssured.mul(5)) {
                thresholdUnreached = 1;
            }

            uint accept;
            (, accept) = cd.getClaimMVote(claimid, 1);
            uint deny;
            (, deny) = cd.getClaimMVote(claimid, -1);

            if (accept.add(deny) > 0) {
                if (accept.mul(100).div(accept.add(deny)) >= 50 && statusOrig > 1 &&
                    statusOrig <= 5 && thresholdUnreached == 0) {
                    status = 8;
                    coverStatus = uint8(QuotationData.CoverStatus.ClaimAccepted);
                } else if (deny.mul(100).div(accept.add(deny)) >= 50 && statusOrig > 1 &&
                    statusOrig <= 5 && thresholdUnreached == 0) {
                    status = 9;
                    coverStatus = uint8(QuotationData.CoverStatus.ClaimDenied);
                }
            }

            if (thresholdUnreached == 1 && (statusOrig == 2 || statusOrig == 4)) {
                status = 10;
                coverStatus = uint8(QuotationData.CoverStatus.ClaimAccepted);
            } else if (thresholdUnreached == 1 && (statusOrig == 5 || statusOrig == 3 || statusOrig == 1)) {
                status = 11;
                coverStatus = uint8(QuotationData.CoverStatus.ClaimDenied);
            }

            c1.setClaimStatus(claimid, status);
            qd.changeCoverStatusNo(coverid, uint8(coverStatus));
            // Reward/Punish Claim Assessors and Members who participated in Claims assessment
            _rewardAgainstClaim(claimid, coverid, sumAssured, status);
        }
    }

    /// @dev Allows a user to claim all pending  Claims assessment rewards.
    function _claimRewardToBeDistributed(uint _records) internal {
        uint lengthVote = cd.getVoteAddressCALength(msg.sender);
        uint voteid;
        uint lastIndex;
        (lastIndex, ) = cd.getRewardDistributedIndex(msg.sender);
        uint total = 0;
        uint tokenForVoteId = 0;
        bool lastClaimedCheck;
        uint _days = td.lockCADays();
        bool claimed;
        uint counter = 0;
        uint claimId;
        uint perc;
        uint i;
        uint lastClaimed = lengthVote;

        for (i = lastIndex; i < lengthVote && counter < _records; i++) {
            voteid = cd.getVoteAddressCA(msg.sender, i);
            (tokenForVoteId, lastClaimedCheck, , perc) = getRewardToBeGiven(1, voteid, 0);
            if (lastClaimed == lengthVote && lastClaimedCheck == true) {
                lastClaimed = i;
            }
            (, claimId, , claimed) = cd.getVoteDetails(voteid);

            if (perc > 0 && !claimed) {
                counter++;
                cd.setRewardClaimed(voteid, true);
            } else if (perc == 0 && cd.getFinalVerdict(claimId) != 0 && !claimed) {
                (perc, , ) = cd.getClaimRewardDetail(claimId);
                if (perc == 0) {
                    counter++;
                }
                cd.setRewardClaimed(voteid, true);
            }
            if (tokenForVoteId > 0) {
                total = tokenForVoteId.add(total);
            }
        }
        if (lastClaimed == lengthVote) {
            cd.setRewardDistributedIndexCA(msg.sender, i);
        }
        else {
            cd.setRewardDistributedIndexCA(msg.sender, lastClaimed);
        }
        lengthVote = cd.getVoteAddressMemberLength(msg.sender);
        lastClaimed = lengthVote;
        _days = _days.mul(counter);
        if (tc.tokensLockedAtTime(msg.sender, "CLA", now) > 0) {
            tc.reduceLock(msg.sender, "CLA", _days);
        }
        (, lastIndex) = cd.getRewardDistributedIndex(msg.sender);
        lastClaimed = lengthVote;
        counter = 0;
        for (i = lastIndex; i < lengthVote && counter < _records; i++) {
            voteid = cd.getVoteAddressMember(msg.sender, i);
            (tokenForVoteId, lastClaimedCheck, , ) = getRewardToBeGiven(0, voteid, 0);
            if (lastClaimed == lengthVote && lastClaimedCheck == true) {
                lastClaimed = i;
            }
            (, claimId, , claimed) = cd.getVoteDetails(voteid);
            if (claimed == false && cd.getFinalVerdict(claimId) != 0) {
                cd.setRewardClaimed(voteid, true);
                counter++;
            }
            if (tokenForVoteId > 0) {
                total = tokenForVoteId.add(total);
            }
        }
        if (total > 0) {
            require(tk.transfer(msg.sender, total));
        }
        if (lastClaimed == lengthVote) {
            cd.setRewardDistributedIndexMV(msg.sender, i);
        }
        else {
            cd.setRewardDistributedIndexMV(msg.sender, lastClaimed);
        }
    }

    /**
     * @dev Function used to claim the commission earned by the staker.
     */
    function _claimStakeCommission(uint _records, address _user) external onlyInternal {
        uint total=0;
        uint len = td.getStakerStakedContractLength(_user);
        uint lastCompletedStakeCommission = td.lastCompletedStakeCommission(_user);
        uint commissionEarned;
        uint commissionRedeemed;
        uint maxCommission;
        uint lastCommisionRedeemed = len;
        uint counter;
        uint i;

        for (i = lastCompletedStakeCommission; i < len && counter < _records; i++) {
            commissionRedeemed = td.getStakerRedeemedStakeCommission(_user, i);
            commissionEarned = td.getStakerEarnedStakeCommission(_user, i);
            maxCommission = td.getStakerInitialStakedAmountOnContract(
                _user, i).mul(td.stakerMaxCommissionPer()).div(100);
            if (lastCommisionRedeemed == len && maxCommission != commissionEarned)
                lastCommisionRedeemed = i;
            td.pushRedeemedStakeCommissions(_user, i, commissionEarned.sub(commissionRedeemed));
            total = total.add(commissionEarned.sub(commissionRedeemed));
            counter++;
        }
        if (lastCommisionRedeemed == len) {
            td.setLastCompletedStakeCommissionIndex(_user, i);
        } else {
            td.setLastCompletedStakeCommissionIndex(_user, lastCommisionRedeemed);
        }

        if (total > 0)
            require(tk.transfer(_user, total)); //solhint-disable-line
    }
}

contract MemberRoles is IMemberRoles, Governed, Iupgradable {

    TokenController public dAppToken;
    TokenData internal td;
    QuotationData internal qd;
    ClaimsReward internal cr;
    Governance internal gv;
    TokenFunctions internal tf;
    RANCEToken public tk;

    struct MemberRoleDetails {
        uint memberCounter;
        mapping(address => bool) memberActive;
        address[] memberAddress;
        address authorized;
    }

    enum Role {UnAssigned, AdvisoryBoard, Member, Owner}

    event switchedMembership(address indexed previousMember, address indexed newMember, uint timeStamp);

    MemberRoleDetails[] internal memberRoleData;
    bool internal constructorCheck;
    uint public maxABCount;
    bool public launched;
    uint public launchedOn;
    modifier checkRoleAuthority(uint _memberRoleId) {
        if (memberRoleData[_memberRoleId].authorized != address(0))
            require(msg.sender == memberRoleData[_memberRoleId].authorized);
        else
            require(isAuthorizedToGovern(msg.sender), "Not Authorized");
        _;
    }

    /**
     * @dev to swap advisory board member
     * @param _newABAddress is address of new AB member
     * @param _removeAB is advisory board member to be removed
     */
    function swapABMember (
        address _newABAddress,
        address _removeAB
    )
    external
    checkRoleAuthority(uint(Role.AdvisoryBoard)) {

        _updateRole(_newABAddress, uint(Role.AdvisoryBoard), true);
        _updateRole(_removeAB, uint(Role.AdvisoryBoard), false);

    }

    /**
     * @dev to swap the owner address
     * @param _newOwnerAddress is the new owner address
     */
    function swapOwner (
        address _newOwnerAddress
    )
    external {
        require(msg.sender == address(ms));
        _updateRole(ms.owner(), uint(Role.Owner), false);
        _updateRole(_newOwnerAddress, uint(Role.Owner), true);
    }

    /**
     * @dev is used to add initital advisory board members
     * @param abArray is the list of initial advisory board members
     */
    function addInitialABMembers(address[] calldata abArray) external onlyOwner {

        //Ensure that SOTEMaster has initialized.
        require(ms.masterInitialized());

        require(maxABCount >= 
            SafeMath.add(numberOfMembers(uint(Role.AdvisoryBoard)), abArray.length)
        );
        //AB count can't exceed maxABCount
        for (uint i = 0; i < abArray.length; i++) {
            require(checkRole(abArray[i], uint(MemberRoles.Role.Member)));
            _updateRole(abArray[i], uint(Role.AdvisoryBoard), true);   
        }
    }

    /**
     * @dev to change max number of AB members allowed
     * @param _val is the new value to be set
     */
    function changeMaxABCount(uint _val) external onlyInternal {
        maxABCount = _val;
    }

    /**
     * @dev Iupgradable Interface to update dependent contract address
     */
    function changeDependentContractAddress() public {
        td = TokenData(ms.getLatestAddress("TD"));
        cr = ClaimsReward(ms.getLatestAddress("CR"));
        qd = QuotationData(ms.getLatestAddress("QD"));
        gv = Governance(ms.getLatestAddress("GV"));
        tf = TokenFunctions(ms.getLatestAddress("TF"));
        tk = RANCEToken(ms.tokenAddress());
        dAppToken = TokenController(ms.getLatestAddress("TC"));
    }

    /**
     * @dev to change the master address
     * @param _masterAddress is the new master address
     */
    function changeMasterAddress(address _masterAddress) public {
        if (masterAddress != address(0))
            require(masterAddress == msg.sender);
        masterAddress = _masterAddress;
        ms = IRANCEMaster(_masterAddress);
        ranceMasterAddress = _masterAddress;
        
    }
    
    /**
     * @dev to initiate the member roles
     * @param _firstAB is the address of the first AB member
     * @param memberAuthority is the authority (role) of the member
     */
    function memberRolesInitiate (address _firstAB, address memberAuthority) public {
        require(!constructorCheck);
        _addInitialMemberRoles(_firstAB, memberAuthority);
        constructorCheck = true;
    }

    /// @dev Adds new member role
    /// @param _roleName New role name
    /// @param _roleDescription New description hash
    /// @param _authorized Authorized member against every role id
    function addRole( //solhint-disable-line
        bytes32 _roleName,
        string memory _roleDescription,
        address _authorized
    )
    public
    onlyAuthorizedToGovern {
        _addRole(_roleName, _roleDescription, _authorized);
    }

    /// @dev Assign or Delete a member from specific role.
    /// @param _memberAddress Address of Member
    /// @param _roleId RoleId to update
    /// @param _active active is set to be True if we want to assign this role to member, False otherwise!
    function updateRole( //solhint-disable-line
        address _memberAddress,
        uint _roleId,
        bool _active
    )
    internal
    checkRoleAuthority(_roleId) {
        _updateRole(_memberAddress, _roleId, _active);
    }

    /**
     * @dev to add members before launch
     * @param userArray is list of addresses of members
     * @param tokens is list of tokens minted for each array element
     */
    function addMembersBeforeLaunch(address[] memory userArray, uint[] memory tokens) public onlyOwner {
        require(!launched);

        for (uint i=0; i < userArray.length; i++) {
            require(!ms.isMember(userArray[i]));
            dAppToken.addToWhitelist(userArray[i]);
            _updateRole(userArray[i], uint(Role.Member), true);
            dAppToken.mint(userArray[i], tokens[i]);
        }
        launched = true;
        launchedOn = now;

    }

   /** 
     * @dev Called by user to pay joining membership fee
     */ 
    function payJoiningFee(address _userAddress) public payable {
        require(_userAddress != address(0));
        require(!ms.isPause(), "Emergency Pause Applied");
        if (msg.sender == address(ms.getLatestAddress("QT"))) {
            require(td.walletAddress() != address(0), "No walletAddress present");
            dAppToken.addToWhitelist(_userAddress);
            _updateRole(_userAddress, uint(Role.Member), true);            
            td.walletAddress().transfer(msg.value); 
        } else {
            require(!qd.refundEligible(_userAddress));
            require(!ms.isMember(_userAddress));
            require(msg.value == td.joiningFee());
            // auto verdict user
            qd.setRefundEligible(_userAddress, false);
            dAppToken.addToWhitelist(_userAddress);
            _updateRole(_userAddress, uint(Role.Member), true);
            td.walletAddress().transfer(msg.value); //solhint-disable-line
        }
    }

    /**
     * @dev to perform kyc verdict
     * @param _userAddress whose kyc is being performed
     * @param verdict of kyc process
     */
    function kycVerdict(address payable _userAddress, bool verdict) public {

        require(msg.sender == qd.kycAuthAddress());
        require(!ms.isPause());
        require(_userAddress != address(0));
        require(!ms.isMember(_userAddress));
        require(qd.refundEligible(_userAddress));
        if (verdict) {
            qd.setRefundEligible(_userAddress, false);
            uint fee = td.joiningFee();
            dAppToken.addToWhitelist(_userAddress);
            _updateRole(_userAddress, uint(Role.Member), true);
            td.walletAddress().transfer(fee); //solhint-disable-line
            
        } else {
            qd.setRefundEligible(_userAddress, false);
            _userAddress.transfer(td.joiningFee()); //solhint-disable-line
        }
    }

    /**
     * @dev Called by existed member if wish to Withdraw membership.
     */
    function withdrawMembership() public {
        require(!ms.isPause() && ms.isMember(msg.sender));
        require(dAppToken.totalLockedBalance(msg.sender, now) == 0); //solhint-disable-line
        require(!tf.isLockedForMemberVote(msg.sender)); // No locked tokens for Member/Governance voting
        // require(cr.getAllPendingRewardOfUser(msg.sender) == 0); // No pending reward to be claimed(claim assesment).
        require(dAppToken.tokensUnlockable(msg.sender, "CLA") == 0, "Member should have no CLA unlockable tokens");
        // gv.removeDelegation(msg.sender);
        dAppToken.burnFrom(msg.sender, tk.balanceOf(msg.sender));
        _updateRole(msg.sender, uint(Role.Member), false);
        dAppToken.removeFromWhitelist(msg.sender); // need clarification on whitelist        
    }


    /**
     * @dev Called by existed member if wish to switch membership to other address.
     * @param _add address of user to forward membership.
     */
    function switchMembership(address _add) external {
        require(!ms.isPause() && ms.isMember(msg.sender) && !ms.isMember(_add));
        require(dAppToken.totalLockedBalance(msg.sender, now) == 0); //solhint-disable-line
        require(!tf.isLockedForMemberVote(msg.sender)); // No locked tokens for Member/Governance voting
        require(cr.getAllPendingRewardOfUser(msg.sender) == 0); // No pending reward to be claimed(claim assesment).
        require(dAppToken.tokensUnlockable(msg.sender, "CLA") == 0, "Member should have no CLA unlockable tokens");
        gv.removeDelegation(msg.sender);
        dAppToken.addToWhitelist(_add);
        _updateRole(_add, uint(Role.Member), true);
        tk.transferFrom(msg.sender, _add, tk.balanceOf(msg.sender));
        _updateRole(msg.sender, uint(Role.Member), false);
        dAppToken.removeFromWhitelist(msg.sender);
        emit switchedMembership(msg.sender, _add, now);
    }

    /// @dev Return number of member roles
    function totalRoles() public view returns(uint256) { //solhint-disable-line
        return memberRoleData.length;
    }

    /// @dev Change Member Address who holds the authority to Add/Delete any member from specific role.
    /// @param _roleId roleId to update its Authorized Address
    /// @param _newAuthorized New authorized address against role id
    function changeAuthorized(uint _roleId, address _newAuthorized) internal checkRoleAuthority(_roleId) { //solhint-disable-line
        memberRoleData[_roleId].authorized = _newAuthorized;
    }

    /// @dev Gets the member addresses assigned by a specific role
    /// @param _memberRoleId Member role id
    /// @return roleId Role id
    /// @return allMemberAddress Member addresses of specified role id
    function members(uint _memberRoleId) internal view returns(uint, address[] memory memberArray) { //solhint-disable-line
        uint length = memberRoleData[_memberRoleId].memberAddress.length;
        uint i;
        uint j = 0;
        memberArray = new address[](memberRoleData[_memberRoleId].memberCounter);
        for (i = 0; i < length; i++) {
            address member = memberRoleData[_memberRoleId].memberAddress[i];
            if (memberRoleData[_memberRoleId].memberActive[member] && !_checkMemberInArray(member, memberArray)) { //solhint-disable-line
                memberArray[j] = member;
                j++;
            }
        }

        return (_memberRoleId, memberArray);
    }

    /// @dev Gets all members' length
    /// @param _memberRoleId Member role id
    /// @return memberRoleData[_memberRoleId].memberCounter Member length
    function numberOfMembers(uint _memberRoleId) public view returns(uint) { //solhint-disable-line
        return memberRoleData[_memberRoleId].memberCounter;
    }

    /// @dev Return member address who holds the right to add/remove any member from specific role.
    function authorized(uint _memberRoleId) internal view returns(address) { //solhint-disable-line
        return memberRoleData[_memberRoleId].authorized;
    }

    /// @dev Get All role ids array that has been assigned to a member so far.
    function roles(address _memberAddress) internal view returns(uint[] memory) { //solhint-disable-line
        uint length = memberRoleData.length;
        uint[] memory assignedRoles = new uint[](length);
        uint counter = 0; 
        for (uint i = 1; i < length; i++) {
            if (memberRoleData[i].memberActive[_memberAddress]) {
                assignedRoles[counter] = i;
                counter++;
            }
        }
        return assignedRoles;
    }

    /// @dev Returns true if the given role id is assigned to a member.
    /// @param _memberAddress Address of member
    /// @param _roleId Checks member's authenticity with the roleId.
    /// i.e. Returns true if this roleId is assigned to member
    function checkRole(address _memberAddress, uint _roleId) public view returns(bool) { //solhint-disable-line
        if (_roleId == uint(Role.UnAssigned))
            return true;
        else
            if (memberRoleData[_roleId].memberActive[_memberAddress]) //solhint-disable-line
                return true;
            else
                return false;
    }

    /// @dev Return total number of members assigned against each role id.
    /// @return totalMembers Total members in particular role id
    function getMemberLengthForAllRoles() public view returns(uint[] memory totalMembers) { //solhint-disable-line
        totalMembers = new uint[](memberRoleData.length);
        for (uint i = 0; i < memberRoleData.length; i++) {
            totalMembers[i] = numberOfMembers(i);
        }
    }

    /**
     * @dev to update the member roles
     * @param _memberAddress in concern
     * @param _roleId the id of role
     * @param _active if active is true, add the member, else remove it 
     */
    function _updateRole(address _memberAddress,
        uint _roleId,
        bool _active) internal {
        // require(_roleId != uint(Role.TokenHolder), "Membership to Token holder is detected automatically");
        if (_active) {
            require(!memberRoleData[_roleId].memberActive[_memberAddress]);
            memberRoleData[_roleId].memberCounter = SafeMath.add(memberRoleData[_roleId].memberCounter, 1);
            memberRoleData[_roleId].memberActive[_memberAddress] = true;
            memberRoleData[_roleId].memberAddress.push(_memberAddress);
        } else {
            require(memberRoleData[_roleId].memberActive[_memberAddress]);
            memberRoleData[_roleId].memberCounter = SafeMath.sub(memberRoleData[_roleId].memberCounter, 1);
            delete memberRoleData[_roleId].memberActive[_memberAddress];
        }
    }

    /// @dev Adds new member role
    /// @param _roleName New role name
    /// @param _roleDescription New description hash
    /// @param _authorized Authorized member against every role id
    function _addRole(
        bytes32 _roleName,
        string memory _roleDescription,
        address _authorized
    ) internal {
        emit MemberRole(memberRoleData.length, _roleName, _roleDescription);
        memberRoleData.push(MemberRoleDetails(0, new address[](0), _authorized));
    }

    /**
     * @dev to check if member is in the given member array
     * @param _memberAddress in concern
     * @param memberArray in concern
     * @return boolean to represent the presence
     */
    function _checkMemberInArray(
        address _memberAddress,
        address[] memory memberArray
    )
        internal
        pure
        returns(bool memberExists)
    {
        uint i;
        for (i = 0; i < memberArray.length; i++) {
            if (memberArray[i] == _memberAddress) {
                memberExists = true;
                break;
            }
        }
    }

    /**
     * @dev to add initial member roles
     * @param _firstAB is the member address to be added
     * @param memberAuthority is the member authority(role) to be added for
     */
    function _addInitialMemberRoles(address _firstAB, address memberAuthority) internal {
        maxABCount = 5;
        _addRole("Unassigned", "Unassigned", address(0));
        _addRole(
            "Advisory Board",
            "Selected few members that are deeply entrusted by the dApp. An ideal advisory board should be a mix of skills of domain, governance, research, technology, consulting etc to improve the performance of the dApp.", //solhint-disable-line
            address(0)
        );
        _addRole(
            "Member",
            "Represents all users of Mutual.", //solhint-disable-line
            memberAuthority
        );
        _addRole(
            "Owner",
            "Represents Owner of Mutual.", //solhint-disable-line
            address(0)
        );
        // _updateRole(_firstAB, uint(Role.AdvisoryBoard), true);
        _updateRole(_firstAB, uint(Role.Owner), true);
        // _updateRole(_firstAB, uint(Role.Member), true);
        launchedOn = 0;
    }

    function memberAtIndex(uint _memberRoleId, uint index) external view returns (address, bool) {
        address memberAddress = memberRoleData[_memberRoleId].memberAddress[index];
        return (memberAddress, memberRoleData[_memberRoleId].memberActive[memberAddress]);
    }

    function membersLength(uint _memberRoleId) external view returns (uint) {
        return memberRoleData[_memberRoleId].memberAddress.length;
    }
}



contract ProposalCategory is  Governed, IProposalCategory, Iupgradable {

    bool public constructorCheck;
    MemberRoles internal mr;

    struct CategoryStruct {
        uint memberRoleToVote;
        uint majorityVotePerc;
        uint quorumPerc;
        uint[] allowedToCreateProposal;
        uint closingTime;
        uint minStake;
    }

    struct CategoryAction {
        uint defaultIncentive;
        address contractAddress;
        bytes2 contractName;
    }
    
    CategoryStruct[] internal allCategory;
    mapping (uint => CategoryAction) internal categoryActionData;
    mapping (uint => uint) public categoryABReq;
    mapping (uint => uint) public isSpecialResolution;
    mapping (uint => bytes) public categoryActionHashes;

    bool public categoryActionHashUpdated;

    /**
    * @dev Restricts calls to deprecated functions
    */
    modifier deprecated() {
        revert("Function deprecated");
        _;
    }

    /**
    * @dev Adds new category (Discontinued, moved functionality to newCategory)
    * @param _name Category name
    * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
    * @param _majorityVotePerc Majority Vote threshold for Each voting layer
    * @param _quorumPerc minimum threshold percentage required in voting to calculate result
    * @param _allowedToCreateProposal Member roles allowed to create the proposal
    * @param _closingTime Vote closing time for Each voting layer
    * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
    * @param _contractAddress address of contract to call after proposal is accepted
    * @param _contractName name of contract to be called after proposal is accepted
    * @param _incentives rewards to distributed after proposal is accepted
    */
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
        external
        deprecated 
    {
    }

    /**
    * @dev Initiates Default settings for Proposal Category contract (Adding default categories)
    */
    function proposalCategoryInitiate() external { //solhint-disable-line
        require(!constructorCheck);
        constructorCheck = true;
        _addInitialCategories("Uncategorized", "", "MR", 60, 15, 1, 0);

        // 1 -- 5
        _addInitialCategories("Add new member role", "QmQFnBep7AyMYU3LJDuHSpTYatnw65XjHzzirrghtZoR8U", "MR", 60, 15, 1, 0);
        _addInitialCategories("Update member role", "QmXMzSViLBJ22P9oj51Zz7isKTRnXWPHZcQ5hzGvvWD3UV", "MR", 60, 15, 1, 0);
        _addInitialCategories("Add new category", "QmUq9Rb6rWFHZXjVtyzh7AWGDeyVFtDHKiP5fJpgnuinQ7", "PC", 60, 15, 1, 0);
        _addInitialCategories("Edit category", "QmQmvfBiCLfe5jPdq69iRBRRdnSHSroJQ4SG8DhtkXcLfQ", "PC", 60, 15, 1, 0);
        _addInitialCategories("Upgrade a contract Implementation", "Qme4hGas6RuDYk9LKE2XkK9E46LNeCBUzY12DdT5uQstvh", "MS", 50, 15, 2, 80);

        // 6 -- 10
        _addInitialCategories("Implement Emergency Pause", "QmZSaEsvTCpy357ZSrPYKqby1iaksBwPdKCGWzW1HpgSpe", "MS", 0, 15, 1, 0);
        _addInitialCategories("Extend or Switch Off Emergency Pause", "Qmao6dD8amq4kxsAheWn5gQX22ABucFFGRvnRuY1VqtEKy", "MS", 50, 15, 2, 0);
        _addInitialCategories("Burn Claims Assessor Bond", "QmezNJUF2BM5Nv9EMnsEKUmuqjvdySzvQFvhEdvFJbau3k", "TF", 80, 15, 1, 0);
        _addInitialCategories("Pause Claim Assessor Voting for 3 days", "QmRBXh9NGoGV7U7tTurKPhL4bzvDc9n23QZYidELpBPVdg", "CD", 60, 15, 1, 0);
        _addInitialCategories("Changes to Capital Model", "", "EX", 50, 15, 2, 60);

        // 11 -- 15
        _addInitialCategories("Changes to Pricing Model", "", "EX", 50, 15, 2, 60);
        _addInitialCategories("Withdraw funds to Pay for Support Services", "QmZQhJunZesYuCJkdGwejSATTR8eynUgV8372cHvnAPMaM", "P1", 50, 15, 2, 80);
        _addInitialCategories("Add Investment Asset", "Qmd66GdYtn1BYmZTB1op1Fbfkq6uywMpow5LRmG2Twbzjb", "PD", 50, 15, 2, 60);
        _addInitialCategories("Edit Investment Asset min and max holding percentages", "QmXwyffmk7rYGHE7p4g3oroJkmyEYAn6EffhZu2MCNcJGA", "PD", 50, 15, 2, 60);
        _addInitialCategories("Update Investment Asset Status", "QmZkxcC82WFRvnBahLT3eQ95ZSGMxuAyCYqxvR3tSyhFmB", "PD", 50, 15, 2, 60);


        // 16 -- 20
        _addInitialCategories("Change AB Member", "QmUBjPDdSiG3pRMqkVzZA2WaqiksT7ixNd3gPQwngGmF9x", "MR", 50, 15, 2, 0);
        _addInitialCategories("Add Currency Asset", "QmYtpNuTdProressqZwEmN7cFtyyJvhFBrqr6xnxQGWrPm", "PD", 50, 15, 2, 0);
        _addInitialCategories("Any other Item", "", "EX", 50, 15, 2, 80);
        _addInitialCategories("Special Resolution", "", "EX", 75, 0, 2, 0);
        _addInitialCategories("Update Token Parameters", "QmbfJTXyLTDsq41U4dukHbagcXef8bRfyMdMqcqLd9aKNM", "TD", 50, 15, 2, 60);

        // 21 -- 25
        _addInitialCategories("Update Risk Assessment Parameters", "QmUHvBShLpDwPWAsWcZvbUJfVGyXYscybi5ASmF6ectxSo", "TD", 50, 15, 2, 60);
        _addInitialCategories("Update Governance Parameters", "QmdFDVEaZnJxXncFczTW6EvrcgR3jBfuPWftR7PfkPfqqT", "GV", 50, 15, 2, 60);
        _addInitialCategories("Update Quotation Parameters", "QmTtSbBp2Cxaz8HzB4TingUozr9AW91siCfMjjyzf8qqAb", "QD", 50, 15, 2, 60);
        _addInitialCategories("Update Claims Assessment Parameters", "QmPo6HPydwXEeoVdwBpwGeZasFnmFwZoTsQ93Bg5pFtQg6", "CD", 50, 15, 2, 60);
        _addInitialCategories("Update Investment Module Parameters", "QmYSUJBJD9hUevydfdF34rGFG7bBQhMrxh2ga9XfeAkdEM", "PD", 50, 15, 2, 60);

        // 26 -- 30
        _addInitialCategories("Update Capital Model Parameters", "QmaQH6AdvBdgrW4xdzcMHa7gNyYSGa2fz7gBuuic2hLkZQ", "PD", 50, 15, 2, 60);
        _addInitialCategories("Update Address Parameters", "QmPfXySkeDFbdMvZyD35y1hiB4g6ZXLSEHfS7JjS6e1VKL", "MS", 50, 15, 2, 60);
        _addInitialCategories("Update Owner Parameters", "QmTEmDA1ECmGPfh5x3co1GmjXQCp3zisUP6rnLQjWmW8nu", "MS", 50, 15, 3, 0);
        _addInitialCategories("Release new smart contract code", "QmSStfVwXF1TzDPCseVtMydgdF1xmzqhMtfpUg9Btx7tUp", "MS", 50, 15, 2, 80);
        _addInitialCategories("Edit Currency Asset Address", "QmahwCzxmUX1QEjgczmA2NF4Nxtx839eRLCXbBFeFCm3cF", "PD", 50, 15, 3, 60);

        // 31 -- 35
        _addInitialCategories("Edit Currency Asset baseMin", "QmeFSwZ21d7XabxVc7eiNKbtfEXUuD8qQXkeHZ5To1vo4t", "PD", 50, 15, 2, 60);
        _addInitialCategories("Edit Investment Asset Address and decimal", "QmRpztKqva2ud5xz9CQeb562bRQt2VEBPnjaWEPwN8q3vf", "PD", 50, 15, 3, 60);
        _addInitialCategories("Trading Trigger Check", "QmSStfVwXF1TzDPCseVtMydgdF1xmzqhMtfpUg9Btx7tUp", "P2", 50, 15, 2, 80);
        _addInitialCategories("Add new contract", "QmSStfVwXF1TzDPCseVtMydgdF1xmzqhMtfpUg9Btx7tUp", "MS", 50, 15, 2, 80);
        _addInitialCategories("Token Controller Parameters", "QmTtSbBp2Cxaz8HzB4TingUozr9AW91siCfMjjyzf8qqAb", "TC", 50, 15, 2, 60);

        // 36
        _addInitialCategories("Update MCR Parameters", "QmTtSbBp2Cxaz8HzB4TingUozr9AW91siCfMjjyzf8qqAb", "MC", 50, 15, 2, 60);
    }

    function _addInitialCategories(
        string memory _name,
        string memory _actionHash,
        bytes2 _contractName,
        uint _majorityVotePerc, 
        uint _quorumPerc,
        uint _memberRoleToVote,
        uint _categoryABReq
    ) 
        internal 
    {
        uint[] memory allowedToCreateProposal = new uint[](1);
        uint[] memory stakeIncentive = new uint[](4);
        if (_memberRoleToVote == 3) {
            allowedToCreateProposal[0] = 3;
        } else {
            allowedToCreateProposal[0] = 2;
        }
        stakeIncentive[0] = 0;
        stakeIncentive[1] = 0;
        stakeIncentive[2] = _categoryABReq;
        if (_quorumPerc == 0) {//For special resolutions
            stakeIncentive[3] = 1;
        } else {
            stakeIncentive[3] = 0;
        }
        _addCategory(
                _name,
                _memberRoleToVote,
                _majorityVotePerc,
                _quorumPerc,
                allowedToCreateProposal,
                604800,
                _actionHash,
                address(0),
                _contractName,
                stakeIncentive
            );
    }

    /**
    * @dev Initiates Default action function hashes for existing categories
    * To be called after the contract has been upgraded by governance
    */
    function updateCategoryActionHashes() external onlyOwner {

        require(!categoryActionHashUpdated, "Category action hashes already updated");
        categoryActionHashUpdated = true;
        categoryActionHashes[1] = abi.encodeWithSignature("addRole(bytes32,string,address)");
        categoryActionHashes[2] = abi.encodeWithSignature("updateRole(address,uint256,bool)");
        categoryActionHashes[3] = abi.encodeWithSignature("newCategory(string,uint256,uint256,uint256,uint256[],uint256,string,address,bytes2,uint256[],string)");//solhint-disable-line
        categoryActionHashes[4] = abi.encodeWithSignature("editCategory(uint256,string,uint256,uint256,uint256,uint256[],uint256,string,address,bytes2,uint256[],string)");//solhint-disable-line
        categoryActionHashes[5] = abi.encodeWithSignature("upgradeContractImplementation(bytes2,address)");
        categoryActionHashes[6] = abi.encodeWithSignature("startEmergencyPause()");
        categoryActionHashes[7] = abi.encodeWithSignature("addEmergencyPause(bool,bytes4)");
        categoryActionHashes[8] = abi.encodeWithSignature("burnCAToken(uint256,uint256,address)");
        categoryActionHashes[9] = abi.encodeWithSignature("setUserClaimVotePausedOn(address)");
        categoryActionHashes[12] = abi.encodeWithSignature("transferEther(uint256,address)");
        categoryActionHashes[13] = abi.encodeWithSignature("addInvestmentAssetCurrency(bytes4,address,bool,uint64,uint64,uint8)");//solhint-disable-line
        categoryActionHashes[14] = abi.encodeWithSignature("changeInvestmentAssetHoldingPerc(bytes4,uint64,uint64)");
        categoryActionHashes[15] = abi.encodeWithSignature("changeInvestmentAssetStatus(bytes4,bool)");
        categoryActionHashes[16] = abi.encodeWithSignature("swapABMember(address,address)");
        categoryActionHashes[17] = abi.encodeWithSignature("addCurrencyAssetCurrency(bytes4,address,uint256)");
        categoryActionHashes[20] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
        categoryActionHashes[21] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
        categoryActionHashes[22] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
        categoryActionHashes[23] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
        categoryActionHashes[24] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
        categoryActionHashes[25] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
        categoryActionHashes[26] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
        categoryActionHashes[27] = abi.encodeWithSignature("updateAddressParameters(bytes8,address)");
        categoryActionHashes[28] = abi.encodeWithSignature("updateOwnerParameters(bytes8,address)");
        categoryActionHashes[29] = abi.encodeWithSignature("upgradeContract(bytes2,address)");
        categoryActionHashes[30] = abi.encodeWithSignature("changeCurrencyAssetAddress(bytes4,address)");
        categoryActionHashes[31] = abi.encodeWithSignature("changeCurrencyAssetBaseMin(bytes4,uint256)");
        categoryActionHashes[32] = abi.encodeWithSignature("changeInvestmentAssetAddressAndDecimal(bytes4,address,uint8)");//solhint-disable-line
        categoryActionHashes[33] = abi.encodeWithSignature("externalLiquidityTrade()");
        categoryActionHashes[34] = abi.encodeWithSignature("addNewInternalContract(bytes2,address,uint256)");
        categoryActionHashes[35] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
        categoryActionHashes[36] = abi.encodeWithSignature("updateUintParameters(bytes8,uint256)");
    }

    /**
    * @dev Gets Total number of categories added till now
    */
    function totalCategories() external view returns(uint) {
        return allCategory.length;
    }

    /**
    * @dev Gets category details
    */
    function category(uint _categoryId) external view returns(uint, uint, uint, uint, uint[] memory, uint, uint) {
        return(
            _categoryId,
            allCategory[_categoryId].memberRoleToVote,
            allCategory[_categoryId].majorityVotePerc,
            allCategory[_categoryId].quorumPerc,
            allCategory[_categoryId].allowedToCreateProposal,
            allCategory[_categoryId].closingTime,
            allCategory[_categoryId].minStake
        );
    }

    /**
    * @dev Gets category ab required and isSpecialResolution
    * @return the category id
    * @return if AB voting is required
    * @return is category a special resolution
    */
    function categoryExtendedData(uint _categoryId) external view returns(uint, uint, uint) {
        return(
            _categoryId,
            categoryABReq[_categoryId],
            isSpecialResolution[_categoryId]
        );
    }

    /**
     * @dev Gets the category acion details
     * @param _categoryId is the category id in concern
     * @return the category id
     * @return the contract address
     * @return the contract name
     * @return the default incentive
     */
    function categoryAction(uint _categoryId) external view returns(uint, address, bytes2, uint) {

        return(
            _categoryId,
            categoryActionData[_categoryId].contractAddress,
            categoryActionData[_categoryId].contractName,
            categoryActionData[_categoryId].defaultIncentive
        );
    }

    /**
     * @dev Gets the category acion details of a category id 
     * @param _categoryId is the category id in concern
     * @return the category id
     * @return the contract address
     * @return the contract name
     * @return the default incentive
     * @return action function hash
     */
    function categoryActionDetails(uint _categoryId) external view returns(uint, address, bytes2, uint, bytes memory) {
        return(
            _categoryId,
            categoryActionData[_categoryId].contractAddress,
            categoryActionData[_categoryId].contractName,
            categoryActionData[_categoryId].defaultIncentive,
            categoryActionHashes[_categoryId]
        );
    }

    /**
    * @dev Updates dependant contract addresses
    */
    function changeDependentContractAddress() public {
        mr = MemberRoles(ms.getLatestAddress("MR"));
    }

    /**
    * @dev Adds new category
    * @param _name Category name
    * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
    * @param _majorityVotePerc Majority Vote threshold for Each voting layer
    * @param _quorumPerc minimum threshold percentage required in voting to calculate result
    * @param _allowedToCreateProposal Member roles allowed to create the proposal
    * @param _closingTime Vote closing time for Each voting layer
    * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
    * @param _contractAddress address of contract to call after proposal is accepted
    * @param _contractName name of contract to be called after proposal is accepted
    * @param _incentives rewards to distributed after proposal is accepted
    * @param _functionHash function signature to be executed
    */
    function newCategory(
        string memory _name, 
        uint _memberRoleToVote,
        uint _majorityVotePerc, 
        uint _quorumPerc,
        uint[] memory _allowedToCreateProposal,
        uint _closingTime,
        string memory _actionHash,
        address _contractAddress,
        bytes2 _contractName,
        uint[] memory _incentives,
        string memory _functionHash
    ) 
        public
        onlyAuthorizedToGovern 
    {

        require(_quorumPerc <= 100 && _majorityVotePerc <= 100, "Invalid percentage");

        require((_contractName == "EX" && _contractAddress == address(0)) || bytes(_functionHash).length > 0);
        
        require(_incentives[3] <= 1, "Invalid special resolution flag");
        
        //If category is special resolution role authorized should be member
        if (_incentives[3] == 1) {
            require(_memberRoleToVote == uint(MemberRoles.Role.Member));
            _majorityVotePerc = 0;
            _quorumPerc = 0;
        }

        _addCategory(
            _name, 
            _memberRoleToVote,
            _majorityVotePerc, 
            _quorumPerc,
            _allowedToCreateProposal,
            _closingTime,
            _actionHash,
            _contractAddress,
            _contractName,
            _incentives
        );


        if (bytes(_functionHash).length > 0 && abi.encodeWithSignature(_functionHash).length == 4) {
            categoryActionHashes[allCategory.length - 1] = abi.encodeWithSignature(_functionHash);
        }
    }

    /**
     * @dev Changes the master address and update it's instance
     * @param _masterAddress is the new master address
     */
    function changeMasterAddress(address _masterAddress) public {
        if (masterAddress != address(0))
            require(masterAddress == msg.sender);
        masterAddress = _masterAddress;
        ms = IRANCEMaster(_masterAddress);
        ranceMasterAddress = _masterAddress;
        
    }

    /**
    * @dev Updates category details (Discontinued, moved functionality to editCategory)
    * @param _categoryId Category id that needs to be updated
    * @param _name Category name
    * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
    * @param _allowedToCreateProposal Member roles allowed to create the proposal
    * @param _majorityVotePerc Majority Vote threshold for Each voting layer
    * @param _quorumPerc minimum threshold percentage required in voting to calculate result
    * @param _closingTime Vote closing time for Each voting layer
    * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
    * @param _contractAddress address of contract to call after proposal is accepted
    * @param _contractName name of contract to be called after proposal is accepted
    * @param _incentives rewards to distributed after proposal is accepted
    */
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
        internal
        deprecated
    {
    }

    /**
    * @dev Updates category details
    * @param _categoryId Category id that needs to be updated
    * @param _name Category name
    * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
    * @param _allowedToCreateProposal Member roles allowed to create the proposal
    * @param _majorityVotePerc Majority Vote threshold for Each voting layer
    * @param _quorumPerc minimum threshold percentage required in voting to calculate result
    * @param _closingTime Vote closing time for Each voting layer
    * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
    * @param _contractAddress address of contract to call after proposal is accepted
    * @param _contractName name of contract to be called after proposal is accepted
    * @param _incentives rewards to distributed after proposal is accepted
    * @param _functionHash function signature to be executed
    */
    function editCategory(
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
        uint[] memory _incentives,
        string memory _functionHash
    )
        public
        onlyAuthorizedToGovern
    {
        require(_verifyMemberRoles(_memberRoleToVote, _allowedToCreateProposal) == 1, "Invalid Role");

        require(_quorumPerc <= 100 && _majorityVotePerc <= 100, "Invalid percentage");

        require((_contractName == "EX" && _contractAddress == address(0)) || bytes(_functionHash).length > 0);

        require(_incentives[3] <= 1, "Invalid special resolution flag");
        
        //If category is special resolution role authorized should be member
        if (_incentives[3] == 1) {
            require(_memberRoleToVote == uint(MemberRoles.Role.Member));
            _majorityVotePerc = 0;
            _quorumPerc = 0;
        }

        delete categoryActionHashes[_categoryId];
        if (bytes(_functionHash).length > 0 && abi.encodeWithSignature(_functionHash).length == 4) {
            categoryActionHashes[_categoryId] = abi.encodeWithSignature(_functionHash);
        }
        allCategory[_categoryId].memberRoleToVote = _memberRoleToVote;
        allCategory[_categoryId].majorityVotePerc = _majorityVotePerc;
        allCategory[_categoryId].closingTime = _closingTime;
        allCategory[_categoryId].allowedToCreateProposal = _allowedToCreateProposal;
        allCategory[_categoryId].minStake = _incentives[0];
        allCategory[_categoryId].quorumPerc = _quorumPerc;
        categoryActionData[_categoryId].defaultIncentive = _incentives[1];
        categoryActionData[_categoryId].contractName = _contractName;
        categoryActionData[_categoryId].contractAddress = _contractAddress;
        categoryABReq[_categoryId] = _incentives[2];
        isSpecialResolution[_categoryId] = _incentives[3];
        emit Category(_categoryId, _name, _actionHash);
    }

    /**
    * @dev Internal call to add new category
    * @param _name Category name
    * @param _memberRoleToVote Voting Layer sequence in which the voting has to be performed.
    * @param _majorityVotePerc Majority Vote threshold for Each voting layer
    * @param _quorumPerc minimum threshold percentage required in voting to calculate result
    * @param _allowedToCreateProposal Member roles allowed to create the proposal
    * @param _closingTime Vote closing time for Each voting layer
    * @param _actionHash hash of details containing the action that has to be performed after proposal is accepted
    * @param _contractAddress address of contract to call after proposal is accepted
    * @param _contractName name of contract to be called after proposal is accepted
    * @param _incentives rewards to distributed after proposal is accepted
    */
    function _addCategory(
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
        internal
    {
        require(_verifyMemberRoles(_memberRoleToVote, _allowedToCreateProposal) == 1, "Invalid Role");
        allCategory.push(
            CategoryStruct(
                _memberRoleToVote,
                _majorityVotePerc,
                _quorumPerc,
                _allowedToCreateProposal,
                _closingTime,
                _incentives[0]
            )
        );
        uint categoryId = allCategory.length - 1;
        categoryActionData[categoryId] = CategoryAction(_incentives[1], _contractAddress, _contractName);
        categoryABReq[categoryId] = _incentives[2];
        isSpecialResolution[categoryId] = _incentives[3];
        emit Category(categoryId, _name, _actionHash);
    }

    /**
    * @dev Internal call to check if given roles are valid or not
    */
    function _verifyMemberRoles(uint _memberRoleToVote, uint[] memory _allowedToCreateProposal) 
    internal view returns(uint) { 
        uint totalRoles = mr.totalRoles();
        if (_memberRoleToVote >= totalRoles) {
            return 0;
        }
        for (uint i = 0; i < _allowedToCreateProposal.length; i++) {
            if (_allowedToCreateProposal[i] >= totalRoles) {
                return 0;
            }
        }
        return 1;
    }

}

contract Quotation is Iupgradable {
    using SafeMath for uint;

    TokenFunctions internal tf;
    TokenController internal tc;
    TokenData internal td;
    Pool1 internal p1;
    PoolData internal pd;
    QuotationData internal qd;
    MCR internal m1;
    MemberRoles internal mr;
    bool internal locked;

    event RefundEvent(address indexed user, bool indexed status, uint holdedCoverID, bytes32 reason);

    modifier noReentrancy() {
        require(!locked, "Reentrant call.");
        locked = true;
        _;
        locked = false;
    }
    
    /**
     * @dev Iupgradable Interface to update dependent contract address
     */
    function changeDependentContractAddress() public onlyInternal {
        m1 = MCR(ms.getLatestAddress("MC"));
        tf = TokenFunctions(ms.getLatestAddress("TF"));
        tc = TokenController(ms.getLatestAddress("TC"));
        td = TokenData(ms.getLatestAddress("TD"));
        qd = QuotationData(ms.getLatestAddress("QD"));
        p1 = Pool1(ms.getLatestAddress("P1"));
        pd = PoolData(ms.getLatestAddress("PD"));
        mr = MemberRoles(ms.getLatestAddress("MR"));
    }

    function sendEther() public payable {
        
    }

    /**
     * @dev Expires a cover after a set period of time.
     * Changes the status of the Cover and reduces the current
     * sum assured of all areas in which the quotation lies
     * Unlocks the CN tokens of the cover. Updates the Total Sum Assured value.
     * @param _cid Cover Id.
     */ 
    function expireCover(uint _cid) public {
        require(checkCoverExpired(_cid) && qd.getCoverStatusNo(_cid) != uint(QuotationData.CoverStatus.CoverExpired));
        
        tf.unlockCN(_cid);
        bytes4 curr;
        address scAddress;
        uint sumAssured;
        (, , scAddress, curr, sumAssured, ) = qd.getCoverDetailsByCoverID1(_cid);
        if (qd.getCoverStatusNo(_cid) != uint(QuotationData.CoverStatus.ClaimAccepted))
            _removeSAFromCSA(_cid, sumAssured);
        qd.changeCoverStatusNo(_cid, uint8(QuotationData.CoverStatus.CoverExpired));       
    }

    /**
     * @dev Checks if a cover should get expired/closed or not.
     * @param _cid Cover Index.
     * @return expire true if the Cover's time has expired, false otherwise.
     */ 
    function checkCoverExpired(uint _cid) public view returns(bool expire) {

        expire = qd.getValidityOfCover(_cid) < uint64(now);

    }

    /**
     * @dev Updates the Sum Assured Amount of all the quotation.
     * @param _cid Cover id
     * @param _amount that will get subtracted Current Sum Assured 
     * amount that comes under a quotation.
     */ 
    function removeSAFromCSA(uint _cid, uint _amount) public onlyInternal {
        _removeSAFromCSA(_cid, _amount);        
    }

    /**
     * @dev Makes Cover funded via SOTE tokens.
     * @param smartCAdd Smart Contract Address
     */ 
    function makeCoverUsingSOTETokens(
        uint[] memory coverDetails,
        uint16 coverPeriod,
        bytes4 coverCurr,
        address smartCAdd,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    )
        public
        isMemberAndcheckPause
    {
        
        tc.burnFrom(msg.sender, coverDetails[2]); //need burn allowance
        _verifyCoverDetails(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod, _v, _r, _s);
    }

    /**
     * @dev Verifies cover details signed off chain.
     * @param from address of funder.
     * @param scAddress Smart Contract Address
     */
    function verifyCoverDetails(
        address payable from,
        address scAddress,
        bytes4 coverCurr,
        uint[] memory coverDetails,
        uint16 coverPeriod,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    )
        public
        onlyInternal
    {
        _verifyCoverDetails(
            from,
            scAddress,
            coverCurr,
            coverDetails,
            coverPeriod,
            _v,
            _r,
            _s
        );
    }

    /** 
     * @dev Verifies signature.
     * @param coverDetails details related to cover.
     * @param coverPeriod validity of cover.
     * @param smaratCA smarat contract address.
     * @param _v argument from vrs hash.
     * @param _r argument from vrs hash.
     * @param _s argument from vrs hash.
     */ 
    function verifySign(
        uint[] memory coverDetails,
        uint16 coverPeriod,
        bytes4 curr,
        address smaratCA,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) 
        public
        view
        returns(bool)
    {
        require(smaratCA != address(0));
        require(pd.capReached() == 1, "Can not buy cover until cap reached for 1st time");
        bytes32 hash = getOrderHash(coverDetails, coverPeriod, curr, smaratCA);
        return isValidSignature(hash, _v, _r, _s);
    }

    /**
     * @dev Gets order hash for given cover details.
     * @param coverDetails details realted to cover.
     * @param coverPeriod validity of cover.
     * @param smaratCA smarat contract address.
     */ 
    function getOrderHash(
        uint[] memory coverDetails,
        uint16 coverPeriod,
        bytes4 curr,
        address smaratCA
    ) 
        public
        view
        returns(bytes32)
    {
        return keccak256(
            abi.encodePacked(
                coverDetails[0],
                curr, coverPeriod,
                smaratCA,
                coverDetails[1],
                coverDetails[2],
                coverDetails[3],
                coverDetails[4],
                address(this)
            )
        );
    }

    /**
     * @dev Verifies signature.
     * @param hash order hash
     * @param v argument from vrs hash.
     * @param r argument from vrs hash.
     * @param s argument from vrs hash.
     */  
    function isValidSignature(bytes32 hash, uint8 v, bytes32 r, bytes32 s) public view returns(bool) {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
        address a = ecrecover(prefixedHash, v, r, s);
        return (a == qd.getAuthQuoteEngine());
    }

    /**
     * @dev to get the status of recently holded coverID 
     * @param userAdd is the user address in concern
     * @return the status of the concerned coverId
     */
    function getRecentHoldedCoverIdStatus(address userAdd) public view returns(int) {

        uint holdedCoverLen = qd.getUserHoldedCoverLength(userAdd);
        if (holdedCoverLen == 0) {
            return -1;
        } else {
            uint holdedCoverID = qd.getUserHoldedCoverByIndex(userAdd, holdedCoverLen.sub(1));
            return int(qd.holdedCoverIDStatus(holdedCoverID));
        }
    }
    
    /**
     * @dev to initiate the membership and the cover 
     * @param smartCAdd is the smart contract address to make cover on
     * @param coverCurr is the currency used to make cover
     * @param coverDetails list of details related to cover like cover amount, expire time, coverCurrPrice and priceSOTE
     * @param coverPeriod is cover period for which cover is being bought
     * @param _v argument from vrs hash 
     * @param _r argument from vrs hash 
     * @param _s argument from vrs hash 
     */
    function initiateMembershipAndCover(
        address smartCAdd,
        bytes4 coverCurr,
        uint[] memory coverDetails,
        uint16 coverPeriod,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) 
        public
        payable
        checkPause
    {
        require(coverDetails[3] > now);
        require(!qd.timestampRepeated(coverDetails[4]));
        qd.setTimestampRepeated(coverDetails[4]);
        require(!ms.isMember(msg.sender));
        require(qd.refundEligible(msg.sender) == false);
        uint joinFee = td.joiningFee();
        uint totalFee = joinFee;
        if (coverCurr == "BNB") {
            totalFee = joinFee.add(coverDetails[1]);
        } else {
            IERC20 erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr));
            require(erc20.transferFrom(msg.sender, address(this), coverDetails[1]));
        }
        require(msg.value == totalFee);
        require(verifySign(coverDetails, coverPeriod, coverCurr, smartCAdd, _v, _r, _s));
        qd.addHoldCover(msg.sender, smartCAdd, coverCurr, coverDetails, coverPeriod);
        qd.setRefundEligible(msg.sender, true);
    }

    /**
     * @dev to get the verdict of kyc process 
     * @param status is the kyc status
     * @param _add is the address of member
     */
    function kycVerdict(address _add, bool status) public checkPause noReentrancy {
        require(msg.sender == qd.kycAuthAddress());
        _kycTrigger(status, _add);
    }

    /**
     * @dev transfering Ethers to newly created quotation contract.
     */  
    function transferAssetsToNewContract(address newAdd) public onlyInternal noReentrancy {
        uint amount = address(this).balance;
        IERC20 erc20;
        if (amount > 0) {
            // newAdd.transfer(amount);   
            Quotation newQT = Quotation(newAdd);
            newQT.sendEther.value(amount)();
        }
        uint currAssetLen = pd.getAllCurrenciesLen();
        for (uint64 i = 1; i < currAssetLen; i++) {
            bytes4 currName = pd.getCurrenciesByIndex(i);
            address currAddr = pd.getCurrencyAssetAddress(currName);
            erc20 = IERC20(currAddr); //solhint-disable-line
            if (erc20.balanceOf(address(this)) > 0) {
                require(erc20.transfer(newAdd, erc20.balanceOf(address(this))));
            }
        }
    }

    /**
     * @dev Creates cover of the quotation, changes the status of the quotation ,
     * updates the total sum assured and locks the tokens of the cover against a quote.
     * @param from Quote member Ethereum address.
     */  

    function _makeCover ( //solhint-disable-line
        address payable from,
        address scAddress,
        bytes4 coverCurr,
        uint[] memory coverDetails,
        uint16 coverPeriod
    )
        internal
    {
        uint cid = qd.getCoverLength();
        qd.addCover(coverPeriod, coverDetails[0],
            from, coverCurr, scAddress, coverDetails[1], coverDetails[2]);
        // if cover period of quote is less than 60 days.
        if (coverPeriod <= 60) {
            p1.closeCoverOraclise(cid, uint64(uint(coverPeriod).mul(1 days)));
        }
        uint coverNoteAmount = (coverDetails[2].mul(qd.tokensRetained())).div(100);
        tc.mint(from, coverNoteAmount);
        tf.lockCN(coverNoteAmount, coverPeriod, cid, from);
        qd.addInTotalSumAssured(coverCurr, coverDetails[0]);
        qd.addInTotalSumAssuredSC(scAddress, coverCurr, coverDetails[0]);


        tf.pushStakerRewards(scAddress, coverDetails[2]);
    }

    /**
     * @dev Makes a vover.
     * @param from address of funder.
     * @param scAddress Smart Contract Address
     */  
    function _verifyCoverDetails(
        address payable from,
        address scAddress,
        bytes4 coverCurr,
        uint[] memory coverDetails,
        uint16 coverPeriod,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    )
        internal
    {
        require(coverDetails[3] > now);
        require(!qd.timestampRepeated(coverDetails[4]));
        qd.setTimestampRepeated(coverDetails[4]);
        require(verifySign(coverDetails, coverPeriod, coverCurr, scAddress, _v, _r, _s));
        _makeCover(from, scAddress, coverCurr, coverDetails, coverPeriod);

    }

    /**
     * @dev Updates the Sum Assured Amount of all the quotation.
     * @param _cid Cover id
     * @param _amount that will get subtracted Current Sum Assured 
     * amount that comes under a quotation.
     */ 
    function _removeSAFromCSA(uint _cid, uint _amount) internal checkPause {
        address _add;
        bytes4 coverCurr;
        (, , _add, coverCurr, , ) = qd.getCoverDetailsByCoverID1(_cid);
        qd.subFromTotalSumAssured(coverCurr, _amount);        
        qd.subFromTotalSumAssuredSC(_add, coverCurr, _amount);
    }

    /**
     * @dev to trigger the kyc process 
     * @param status is the kyc status
     * @param _add is the address of member
     */
    function _kycTrigger(bool status, address _add) internal {

        uint holdedCoverLen = qd.getUserHoldedCoverLength(_add).sub(1);
        uint holdedCoverID = qd.getUserHoldedCoverByIndex(_add, holdedCoverLen);
        address payable userAdd;
        address scAddress;
        bytes4 coverCurr;
        uint16 coverPeriod;
        uint[]  memory coverDetails = new uint[](4);
        IERC20 erc20;

        (, userAdd, coverDetails) = qd.getHoldedCoverDetailsByID2(holdedCoverID);
        (, scAddress, coverCurr, coverPeriod) = qd.getHoldedCoverDetailsByID1(holdedCoverID);
        require(qd.refundEligible(userAdd));
        qd.setRefundEligible(userAdd, false);
        require(qd.holdedCoverIDStatus(holdedCoverID) == uint(QuotationData.HCIDStatus.kycPending));
        uint joinFee = td.joiningFee();
        if (status) {
            mr.payJoiningFee.value(joinFee)(userAdd);
            if (coverDetails[3] > now) { 
                qd.setHoldedCoverIDStatus(holdedCoverID, uint(QuotationData.HCIDStatus.kycPass));
                address poolAdd = ms.getLatestAddress("P1");
                if (coverCurr == "BNB") {
                    p1.sendEther.value(coverDetails[1])();
                } else {
                    erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr)); //solhint-disable-line
                    require(erc20.transfer(poolAdd, coverDetails[1]));
                }
                emit RefundEvent(userAdd, status, holdedCoverID, "KYC Passed");               
                _makeCover(userAdd, scAddress, coverCurr, coverDetails, coverPeriod);

            } else {
                qd.setHoldedCoverIDStatus(holdedCoverID, uint(QuotationData.HCIDStatus.kycPassNoCover));
                if (coverCurr == "BNB") {
                    userAdd.transfer(coverDetails[1]);
                } else {
                    erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr)); //solhint-disable-line
                    require(erc20.transfer(userAdd, coverDetails[1]));
                }
                emit RefundEvent(userAdd, status, holdedCoverID, "Cover Failed");
            }
        } else {
            qd.setHoldedCoverIDStatus(holdedCoverID, uint(QuotationData.HCIDStatus.kycFailedOrRefunded));
            uint totalRefund = joinFee;
            if (coverCurr == "BNB") {
                totalRefund = coverDetails[1].add(joinFee);
            } else {
                erc20 = IERC20(pd.getCurrencyAssetAddress(coverCurr)); //solhint-disable-line
                require(erc20.transfer(userAdd, coverDetails[1]));
            }
            userAdd.transfer(totalRefund);
            emit RefundEvent(userAdd, status, holdedCoverID, "KYC Failed");
        }
              
    }
}

contract Governance is IGovernance, Iupgradable {

    using SafeMath for uint;

    enum ProposalStatus { 
        Draft,
        AwaitingSolution,
        VotingStarted,
        Accepted,
        Rejected,
        Majority_Not_Reached_But_Accepted,
        Denied
    }

    struct ProposalData {
        uint propStatus;
        uint finalVerdict;
        uint category;
        uint commonIncentive;
        uint dateUpd;
        uint dateCreated;
        address owner;
        string title;
        string desc;
    }

    struct ProposalVote {
        address voter;
        uint proposalId;
        uint dateAdd;
    }

    struct VoteTally {
        mapping(uint=>uint) memberVoteValue;
        mapping(uint=>uint) abVoteValue;
        uint voters;
    }

    struct DelegateVote {
        address follower;
        address leader;
        uint lastUpd;
    }

    ProposalVote[] public allVotes;
    DelegateVote[] public allDelegation;

    mapping(uint => ProposalData) public allProposalData;
    mapping(uint => bytes[]) public allProposalSolutions;
    mapping(address => uint[]) public allVotesByMember;
    mapping(uint => mapping(address => bool)) public rewardClaimed;
    mapping (address => mapping(uint => uint)) public memberProposalVote;
    mapping (address => uint) public followerDelegation;
    mapping (address => uint) public followerCount;
    mapping (address => uint[]) public leaderDelegation;
    mapping (uint => VoteTally) public proposalVoteTally;
    mapping (address => bool) public isOpenForDelegation;
    mapping (address => uint) public lastRewardClaimed;

    bool public constructorCheck;
    uint public tokenHoldingTime;
    uint public roleIdAllowedToCatgorize;
    uint public maxVoteWeigthPer;
    uint public specialResolutionMajPerc;
    uint public maxFollowers;
    uint public totalProposals;
    uint public maxDraftTime;
    uint public actionWaitingTime;

    MemberRoles internal memberRole;
    ProposalCategory internal proposalCategory;
    TokenController internal tokenInstance;

    mapping(uint => uint) public proposalActionStatus;
    mapping(uint => uint) public proposalExecutionTime;
    mapping(uint => mapping(address => bool)) public proposalRejectedByAB;
    mapping(uint => uint) public actionRejectedCount;

    // bool internal actionParamsInitialised;
    
    uint constant internal AB_MAJ_TO_REJECT_ACTION = 3;

    enum ActionStatus {
        Pending,
        Accepted,
        Rejected,
        Executed,
        NoAction
    }

    /**
    * @dev Called whenever an action execution is failed.
    */
    event ActionFailed (
        uint256 proposalId
    );

    /**
    * @dev Called whenever an AB member rejects the action execution.
    */
    event ActionRejected (
        uint256 indexed proposalId,
        address rejectedBy
    );

    /**
    * @dev Checks if msg.sender is proposal owner
    */
    modifier onlyProposalOwner(uint _proposalId) {
        require(msg.sender == allProposalData[_proposalId].owner, "Not allowed");
        _;
    }

    /**
    * @dev Checks if proposal is opened for voting
    */
    modifier voteNotStarted(uint _proposalId) {
        require(allProposalData[_proposalId].propStatus < uint(ProposalStatus.VotingStarted));
        _;
    }

    /**
    * @dev Checks if msg.sender is allowed to create proposal under given category
    */
    modifier isAllowed(uint _categoryId) {
        require(allowedToCreateProposal(_categoryId), "Not allowed");
        _;
    }

    /**
    * @dev Checks if msg.sender is allowed categorize proposal under given category
    */
    modifier isAllowedToCategorize() {
        require(memberRole.checkRole(msg.sender, roleIdAllowedToCatgorize), "Not allowed");
        _;
    }

    /**
    * @dev Checks if msg.sender had any pending rewards to be claimed
    */
    modifier checkPendingRewards {
        require(getPendingReward(msg.sender) == 0, "Claim reward");
        _;
    }

    /**
    * @dev Event emitted whenever a proposal is categorized
    */
    event ProposalCategorized(
        uint indexed proposalId,
        address indexed categorizedBy,
        uint categoryId
    );

    function initGovernance() public {
        require(constructorCheck == false, "already init!");

        totalProposals = 1;
        tokenHoldingTime = 1 * 7 days;
        maxDraftTime = 2 * 7 days;
        maxVoteWeigthPer = 5;
        maxFollowers = 40;
        constructorCheck = true;
        roleIdAllowedToCatgorize = uint(MemberRoles.Role.AdvisoryBoard);
        specialResolutionMajPerc = 75;
        actionWaitingTime = 24 * 1 hours;
    }
    
    /**
     * @dev Removes delegation of an address.
     * @param _add address to undelegate.
     */
    function removeDelegation(address _add) external onlyInternal {
        _unDelegate(_add);
    }


    /**
    * @dev Creates a new proposal
    * @param _proposalDescHash Proposal description hash through IPFS having Short and long description of proposal
    * @param _categoryId This id tells under which the proposal is categorized i.e. Proposal's Objective
    */
    function createProposal(
        string calldata _proposalTitle, 
        string calldata _proposalSD, 
        string calldata _proposalDescHash, 
        uint _categoryId
    ) 
        external isAllowed(_categoryId)
    {
        require(ms.isMember(msg.sender), "Not Member");

        _createProposal(_proposalTitle, _proposalSD, _proposalDescHash, _categoryId);
    }

    /**
    * @dev Categorizes proposal to proceed further. Categories shows the proposal objective.
    */
    function categorizeProposal(
        uint _proposalId,
        uint _categoryId,
        uint _incentive
    )
        external
        voteNotStarted(_proposalId) isAllowedToCategorize
    {
        _categorizeProposal(_proposalId, _categoryId, _incentive);
    }

    /**
    * @dev Submit proposal with solution
    * @param _proposalId Proposal id
    * @param _solutionHash Solution hash contains  parameters, values and description needed according to proposal
    */
    function submitProposalWithSolution(
        uint _proposalId, 
        string calldata _solutionHash, 
        bytes calldata _action
    ) 
        external
        onlyProposalOwner(_proposalId)
    {

        require(allProposalData[_proposalId].propStatus == uint(ProposalStatus.AwaitingSolution));
        
        _proposalSubmission(_proposalId, _solutionHash, _action);
    }

    /**
    * @dev Creates a new proposal with solution
    * @param _proposalDescHash Proposal description hash through IPFS having Short and long description of proposal
    * @param _categoryId This id tells under which the proposal is categorized i.e. Proposal's Objective
    * @param _solutionHash Solution hash contains  parameters, values and description needed according to proposal
    */
    function createProposalwithSolution(
        string calldata _proposalTitle, 
        string calldata _proposalSD, 
        string calldata _proposalDescHash,
        uint _categoryId, 
        string calldata _solutionHash, 
        bytes calldata _action
    ) 
        external isAllowed(_categoryId)
    {


        uint proposalId = totalProposals;

        _createProposal(_proposalTitle, _proposalSD, _proposalDescHash, _categoryId);
        
        require(_categoryId > 0);

        _proposalSubmission(
            proposalId,
            _solutionHash,
            _action
        );
    }

    /**
     * @dev Submit a vote on the proposal.
     * @param _proposalId to vote upon.
     * @param _solutionChosen is the chosen vote.
     */
    function submitVote(uint _proposalId, uint _solutionChosen) external {
        
        require(allProposalData[_proposalId].propStatus == 
        uint(Governance.ProposalStatus.VotingStarted), "Not allowed");

        require(_solutionChosen < allProposalSolutions[_proposalId].length);


        _submitVote(_proposalId, _solutionChosen);
    }

    /**
     * @dev Closes the proposal.
     * @param _proposalId of proposal to be closed.
     */
    function closeProposal(uint _proposalId) external {
        uint category = allProposalData[_proposalId].category;
        
        
        uint _memberRole;
        if (allProposalData[_proposalId].dateUpd.add(maxDraftTime) <= now && 
            allProposalData[_proposalId].propStatus < uint(ProposalStatus.VotingStarted)) {
            _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
        } else {
            require(canCloseProposal(_proposalId) == 1);
            (, _memberRole, , , , , ) = proposalCategory.category(allProposalData[_proposalId].category);
            if (_memberRole == uint(MemberRoles.Role.AdvisoryBoard)) {
                _closeAdvisoryBoardVote(_proposalId, category);
            } else {
                _closeMemberVote(_proposalId, category);
            }
        }
        
    }

    /**
     * @dev Claims reward for member.
     * @param _memberAddress to claim reward of.
     * @param _maxRecords maximum number of records to claim reward for.
     _proposals list of proposals of which reward will be claimed.
     * @return amount of pending reward.
     */
    function claimReward(address _memberAddress, uint _maxRecords) 
        external returns(uint pendingDAppReward) 
    {
        
        uint voteId;
        address leader;
        uint lastUpd;

        require(msg.sender == ms.getLatestAddress("CR"));

        uint delegationId = followerDelegation[_memberAddress];
        
        if (delegationId > 0) {
            DelegateVote memory delegationData = allDelegation[delegationId];
            leader = delegationData.leader;
            lastUpd = delegationData.lastUpd;
        } else
            leader = _memberAddress;

        uint proposalId;
        uint totalVotes = allVotesByMember[leader].length;
        uint lastClaimed = totalVotes;
        uint j;
        uint i;
        for (i = lastRewardClaimed[_memberAddress]; i < totalVotes && j < _maxRecords; i++) {
            voteId = allVotesByMember[leader][i];
            proposalId = allVotes[voteId].proposalId;
            if (proposalVoteTally[proposalId].voters > 0 && (allVotes[voteId].dateAdd > (
                lastUpd.add(tokenHoldingTime)) || leader == _memberAddress)) {
                if (allProposalData[proposalId].propStatus > uint(ProposalStatus.VotingStarted)) {
                    if (!rewardClaimed[voteId][_memberAddress]) {
                        pendingDAppReward = pendingDAppReward.add(
                                allProposalData[proposalId].commonIncentive.div(
                                    proposalVoteTally[proposalId].voters
                                )
                            );
                        rewardClaimed[voteId][_memberAddress] = true;
                        j++;
                    }
                } else {
                    if (lastClaimed == totalVotes) {
                        lastClaimed = i;
                    }
                }
            }
        }

        if (lastClaimed == totalVotes) {
            lastRewardClaimed[_memberAddress] = i;
        } else {
            lastRewardClaimed[_memberAddress] = lastClaimed;
        }

        if (j > 0) {
            emit RewardClaimed(
                _memberAddress,
                pendingDAppReward
            );
        }
    }

    /**
     * @dev Sets delegation acceptance status of individual user
     * @param _status delegation acceptance status
     */
    function setDelegationStatus(bool _status) external isMemberAndcheckPause checkPendingRewards {
        isOpenForDelegation[msg.sender] = _status;
    }

    /**
     * @dev Delegates vote to an address.
     * @param _add is the address to delegate vote to.
     */
    function delegateVote(address _add) external isMemberAndcheckPause checkPendingRewards {

        require(ms.masterInitialized());

        require(allDelegation[followerDelegation[_add]].leader == address(0));

        if (followerDelegation[msg.sender] > 0) {
            require((allDelegation[followerDelegation[msg.sender]].lastUpd).add(tokenHoldingTime) < now);
        }

        require(!alreadyDelegated(msg.sender));
        require(!memberRole.checkRole(msg.sender, uint(MemberRoles.Role.Owner)));
        require(!memberRole.checkRole(msg.sender, uint(MemberRoles.Role.AdvisoryBoard)));


        require(followerCount[_add] < maxFollowers);
        
        if (allVotesByMember[msg.sender].length > 0) {
            require((allVotes[allVotesByMember[msg.sender][allVotesByMember[msg.sender].length - 1]].dateAdd).add(tokenHoldingTime)
            < now);
        }

        require(ms.isMember(_add));

        require(isOpenForDelegation[_add]);

        allDelegation.push(DelegateVote(msg.sender, _add, now));
        followerDelegation[msg.sender] = allDelegation.length - 1;
        leaderDelegation[_add].push(allDelegation.length - 1);
        followerCount[_add]++;
        lastRewardClaimed[msg.sender] = allVotesByMember[_add].length;
    }

    /**
     * @dev Triggers action of accepted proposal after waiting time is finished
     */
    function triggerAction(uint _proposalId) external {
        require(proposalActionStatus[_proposalId] == uint(ActionStatus.Accepted) && proposalExecutionTime[_proposalId] <= now, "Cannot trigger");
        _triggerAction(_proposalId, allProposalData[_proposalId].category);
    }

    /**
     * @dev Provides option to Advisory board member to reject proposal action execution within actionWaitingTime, if found suspicious
     */
    function rejectAction(uint _proposalId) external {
        require(memberRole.checkRole(msg.sender, uint(MemberRoles.Role.AdvisoryBoard)) && proposalExecutionTime[_proposalId] > now);

        require(proposalActionStatus[_proposalId] == uint(ActionStatus.Accepted));

        require(!proposalRejectedByAB[_proposalId][msg.sender]);

        require(
            keccak256(proposalCategory.categoryActionHashes(allProposalData[_proposalId].category))
            != keccak256(abi.encodeWithSignature("swapABMember(address,address)"))
        );

        proposalRejectedByAB[_proposalId][msg.sender] = true;
        actionRejectedCount[_proposalId]++;
        emit ActionRejected(_proposalId, msg.sender);
        if (actionRejectedCount[_proposalId] == AB_MAJ_TO_REJECT_ACTION) {
            proposalActionStatus[_proposalId] = uint(ActionStatus.Rejected);
        }
    }

    /**
     * @dev Gets some details of a propsal
     * @param _proposalId whose details we want
     * @return proposalId
     * @return number of all proposal solutions
     * @return amount of votes 
     */
    function proposalDetails(uint _proposalId) external view returns(uint, uint, uint) {
        return(
            _proposalId,
            allProposalSolutions[_proposalId].length,
            proposalVoteTally[_proposalId].voters
        );
    }

    /**
     * @dev Gets solution action on a proposal
     * @param _proposalId whose details we want
     * @param _solution whose details we want
     * @return action of a solution on a proposal
     */
    function getSolutionAction(uint _proposalId, uint _solution) external view returns(uint, bytes memory) {
        return (
            _solution,
            allProposalSolutions[_proposalId][_solution]
        );
    }

    /**
     * @dev Gets pending rewards of a member
     * @param _memberAddress in concern
     * @return amount of pending reward
     */
    function getPendingReward(address _memberAddress)
        public view returns(uint pendingDAppReward)
    {
        uint delegationId = followerDelegation[_memberAddress];
        address leader;
        uint lastUpd;

        if (delegationId > 0) {
            DelegateVote memory delegationData = allDelegation[delegationId];
            leader = delegationData.leader;
            lastUpd = delegationData.lastUpd;
        } else
            leader = _memberAddress;

        uint proposalId;
        for (uint i = lastRewardClaimed[_memberAddress]; i < allVotesByMember[leader].length; i++) {
            if (allVotes[allVotesByMember[leader][i]].dateAdd > (
                lastUpd.add(tokenHoldingTime)) || leader == _memberAddress) {
                if (!rewardClaimed[allVotesByMember[leader][i]][_memberAddress]) {
                    proposalId = allVotes[allVotesByMember[leader][i]].proposalId;
                    if (proposalVoteTally[proposalId].voters > 0 && allProposalData[proposalId].propStatus
                    > uint(ProposalStatus.VotingStarted)) {
                        pendingDAppReward = pendingDAppReward.add(
                            allProposalData[proposalId].commonIncentive.div(
                                proposalVoteTally[proposalId].voters
                            )
                        );
                    }
                }
            }
        }
    }

    /**
     * @dev Updates Uint Parameters of a code
     * @param code whose details we want to update
     * @param val value to set
     */
    function updateUintParameters(bytes8 code, uint val) public {

        require(ms.checkIsAuthToGoverned(msg.sender));
        if (code == "GOVHOLD") {

            tokenHoldingTime = val * 1 days;

        } else if (code == "MAXFOL") {

            maxFollowers = val;

        } else if (code == "MAXDRFT") {

            maxDraftTime = val * 1 days;

        } else if (code == "EPTIME") {

            ms.updatePauseTime(val * 1 days);

        } else if (code == "ACWT") {

            actionWaitingTime = val * 1 hours;

        } else {

            revert("Invalid code");

        }
    }

    /**
    * @dev Updates all dependency addresses to latest ones from Master
    */
    function changeDependentContractAddress() public {
        tokenInstance = TokenController(ms.dAppLocker());
        memberRole = MemberRoles(ms.getLatestAddress("MR"));
        proposalCategory = ProposalCategory(ms.getLatestAddress("PC"));
    }

    /**
    * @dev Checks if msg.sender is allowed to create a proposal under given category
    */
    function allowedToCreateProposal(uint category) public view returns(bool check) {
        if (category == 0)
            return true;
        uint[] memory mrAllowed;
        (, , , , mrAllowed, , ) = proposalCategory.category(category);
        for (uint i = 0; i < mrAllowed.length; i++) {
            if (mrAllowed[i] == 0 || memberRole.checkRole(msg.sender, mrAllowed[i]))
                return true;
        }
    }

    /**
     * @dev Checks if an address is already delegated
     * @param _add in concern
     * @return bool value if the address is delegated or not
     */
    function alreadyDelegated(address _add) public view returns(bool delegated) {
        for (uint i=0; i < leaderDelegation[_add].length; i++) {
            if (allDelegation[leaderDelegation[_add][i]].leader == _add) {
                return true;
            }
        }
    }


    /**
    * @dev Checks If the proposal voting time is up and it's ready to close 
    *      i.e. Closevalue is 1 if proposal is ready to be closed, 2 if already closed, 0 otherwise!
    * @param _proposalId Proposal id to which closing value is being checked
    */
    function canCloseProposal(uint _proposalId) 
        public 
        view 
        returns(uint)
    {
        uint dateUpdate;
        uint pStatus;
        uint _closingTime;
        uint _roleId;
        uint majority;
        pStatus = allProposalData[_proposalId].propStatus;
        dateUpdate = allProposalData[_proposalId].dateUpd;
        (, _roleId, majority, , , _closingTime, ) = proposalCategory.category(allProposalData[_proposalId].category);
        if (
            pStatus == uint(ProposalStatus.VotingStarted)
        ) {
            uint numberOfMembers = memberRole.numberOfMembers(_roleId);
            if (_roleId == uint(MemberRoles.Role.AdvisoryBoard)) {
                if (proposalVoteTally[_proposalId].abVoteValue[1].mul(100).div(numberOfMembers) >= majority  
                || proposalVoteTally[_proposalId].abVoteValue[1].add(proposalVoteTally[_proposalId].abVoteValue[0]) == numberOfMembers
                || dateUpdate.add(_closingTime) <= now) {

                    return 1;
                }
            } else {
                if (numberOfMembers == proposalVoteTally[_proposalId].voters 
                || dateUpdate.add(_closingTime) <= now)
                    return  1;
            }
        } else if (pStatus > uint(ProposalStatus.VotingStarted)) {
            return  2;
        } else {
            return  0;
        }
    }


    /**
     * @dev Gets vote tally data
     * @param _proposalId in concern
     * @param _solution of a proposal id
     * @return member vote value
     * @return advisory board vote value
     * @return amount of votes
     */
    function voteTallyData(uint _proposalId, uint _solution) public view returns(uint, uint, uint) {
        return (proposalVoteTally[_proposalId].memberVoteValue[_solution],
            proposalVoteTally[_proposalId].abVoteValue[_solution], proposalVoteTally[_proposalId].voters);
    }

    /**
     * @dev Internal call to create proposal
     * @param _proposalTitle of proposal
     * @param _proposalSD is short description of proposal
     * @param _proposalDescHash IPFS hash value of propsal
     * @param _categoryId of proposal
     */
    function _createProposal(
        string memory _proposalTitle,
        string memory _proposalSD,
        string memory _proposalDescHash,
        uint _categoryId
    )
        internal
    {
        require(bytes(_proposalTitle).length <= 64, "Maximum length of title is 64.");
        require(bytes(_proposalSD).length <= 1024, "Maximum length of description is 1024.");
        require(proposalCategory.categoryABReq(_categoryId) == 0 || _categoryId == 0);
        uint _proposalId = totalProposals;
        allProposalData[_proposalId].owner = msg.sender;
        allProposalData[_proposalId].dateUpd = now;
        allProposalData[_proposalId].dateCreated = now;
        allProposalData[_proposalId].title = _proposalTitle;
        allProposalData[_proposalId].desc = _proposalSD;
        allProposalSolutions[_proposalId].push("");
        totalProposals++;

        emit Proposal(
            msg.sender,
            _proposalId,
            now,
            _proposalTitle,
            _proposalSD,
            _proposalDescHash
        );

        if (_categoryId > 0)
            _categorizeProposal(_proposalId, _categoryId, 0);
    }

    /**
     * @dev Internal call to categorize a proposal
     * @param _proposalId of proposal
     * @param _categoryId of proposal
     * @param _incentive is commonIncentive
     */
    function _categorizeProposal(
        uint _proposalId,
        uint _categoryId,
        uint _incentive
    )
        internal
    {
        require(
            _categoryId > 0 && _categoryId < proposalCategory.totalCategories(),
            "Invalid category"
        );
        require(_proposalId < totalProposals, "Invalid proposal Id!");
        allProposalData[_proposalId].category = _categoryId;
        allProposalData[_proposalId].commonIncentive = _incentive;
        allProposalData[_proposalId].propStatus = uint(ProposalStatus.AwaitingSolution);

        emit ProposalCategorized(_proposalId, msg.sender, _categoryId);
    }

    /**
     * @dev Internal call to add solution to a proposal
     * @param _proposalId in concern
     * @param _action on that solution
     * @param _solutionHash string value
     */
    function _addSolution(uint _proposalId, bytes memory _action, string memory _solutionHash)
        internal
    {
        allProposalSolutions[_proposalId].push(_action);
        emit Solution(_proposalId, msg.sender, allProposalSolutions[_proposalId].length - 1, _solutionHash, now);
    }

    /**
    * @dev Internal call to add solution and open proposal for voting
    */
    function _proposalSubmission(
        uint _proposalId,
        string memory _solutionHash,
        bytes memory _action
    )
        internal
    {

        uint _categoryId = allProposalData[_proposalId].category;
        if (proposalCategory.categoryActionHashes(_categoryId).length == 0) {
            require(keccak256(_action) == keccak256(""));
            proposalActionStatus[_proposalId] = uint(ActionStatus.NoAction);
        }
        
        _addSolution(
            _proposalId,
            _action,
            _solutionHash
        );

        _updateProposalStatus(_proposalId, uint(ProposalStatus.VotingStarted));
        (, , , , , uint closingTime, ) = proposalCategory.category(_categoryId);
        emit CloseProposalOnTime(_proposalId, closingTime.add(now));

    }

    /**
     * @dev Internal call to submit vote
     * @param _proposalId of proposal in concern
     * @param _solution for that proposal
     */
    function _submitVote(uint _proposalId, uint _solution) internal {

        uint delegationId = followerDelegation[msg.sender];
        uint mrSequence;
        uint majority;
        uint closingTime;
        (, mrSequence, majority, , , closingTime, ) = proposalCategory.category(allProposalData[_proposalId].category);

        require(allProposalData[_proposalId].dateUpd.add(closingTime) > now, "Closed");

        require(memberProposalVote[msg.sender][_proposalId] == 0, "Not allowed");
        require((delegationId == 0) || (delegationId > 0 && allDelegation[delegationId].leader == address(0) && 
        _checkLastUpd(allDelegation[delegationId].lastUpd)));

        require(memberRole.checkRole(msg.sender, mrSequence), "Not Authorized");
        uint totalVotes = allVotes.length;

        allVotesByMember[msg.sender].push(totalVotes);
        memberProposalVote[msg.sender][_proposalId] = totalVotes;

        allVotes.push(ProposalVote(msg.sender, _proposalId, now));

        emit Vote(msg.sender, _proposalId, totalVotes, now, _solution);
        if (mrSequence == uint(MemberRoles.Role.Owner)) {
            if (_solution == 1)
                _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), allProposalData[_proposalId].category, 1, MemberRoles.Role.Owner);
            else
                _updateProposalStatus(_proposalId, uint(ProposalStatus.Rejected));
        
        } else {
            uint numberOfMembers = memberRole.numberOfMembers(mrSequence);
            _setVoteTally(_proposalId, _solution, mrSequence);

            if (mrSequence == uint(MemberRoles.Role.AdvisoryBoard)) {
                if (proposalVoteTally[_proposalId].abVoteValue[1].mul(100).div(numberOfMembers) 
                >= majority 
                || (proposalVoteTally[_proposalId].abVoteValue[1].add(proposalVoteTally[_proposalId].abVoteValue[0])) == numberOfMembers) {
                    emit VoteCast(_proposalId);
                }
            } else {
                if (numberOfMembers == proposalVoteTally[_proposalId].voters)
                    emit VoteCast(_proposalId);
            }
        }

    }

    /**
     * @dev Internal call to set vote tally of a proposal
     * @param _proposalId of proposal in concern
     * @param _solution of proposal in concern
     * @param mrSequence number of members for a role
     */
    function _setVoteTally(uint _proposalId, uint _solution, uint mrSequence) internal
    {
        uint categoryABReq;
        uint isSpecialResolution;
        (, categoryABReq, isSpecialResolution) = proposalCategory.categoryExtendedData(allProposalData[_proposalId].category);
        if (memberRole.checkRole(msg.sender, uint(MemberRoles.Role.AdvisoryBoard)) && (categoryABReq > 0) || 
            mrSequence == uint(MemberRoles.Role.AdvisoryBoard)) {
            proposalVoteTally[_proposalId].abVoteValue[_solution]++;
        }
        tokenInstance.lockForMemberVote(msg.sender, tokenHoldingTime);
        if (mrSequence != uint(MemberRoles.Role.AdvisoryBoard)) {
            uint voteWeight;
            uint voters = 1;
            uint tokenBalance = tokenInstance.totalBalanceOf(msg.sender);
            uint totalSupply = tokenInstance.totalSupply();
            if (isSpecialResolution == 1) {
                voteWeight = tokenBalance.add(10**18);
            } else {
                voteWeight = (_minOf(tokenBalance, maxVoteWeigthPer.mul(totalSupply).div(100))).add(10**18);
            }
            DelegateVote memory delegationData;
            for (uint i = 0; i < leaderDelegation[msg.sender].length; i++) {
                delegationData = allDelegation[leaderDelegation[msg.sender][i]];
                if (delegationData.leader == msg.sender && 
                _checkLastUpd(delegationData.lastUpd)) {
                    if (memberRole.checkRole(delegationData.follower, mrSequence)) {
                        tokenBalance = tokenInstance.totalBalanceOf(delegationData.follower);
                        tokenInstance.lockForMemberVote(delegationData.follower, tokenHoldingTime);
                        voters++;
                        if (isSpecialResolution == 1) {
                            voteWeight = voteWeight.add(tokenBalance.add(10**18));
                        } else {
                            voteWeight = voteWeight.add((_minOf(tokenBalance, maxVoteWeigthPer.mul(totalSupply).div(100))).add(10**18));
                        }
                    }
                }
            }
            proposalVoteTally[_proposalId].memberVoteValue[_solution] = proposalVoteTally[_proposalId].memberVoteValue[_solution].add(voteWeight);
            proposalVoteTally[_proposalId].voters = proposalVoteTally[_proposalId].voters + voters;
        }
    }

    /**
     * @dev Gets minimum of two numbers
     * @param a one of the two numbers
     * @param b one of the two numbers
     * @return minimum number out of the two
     */
    function _minOf(uint a, uint b) internal pure returns(uint res) {
        res = a;
        if (res > b)
            res = b;
    }
    
    /**
     * @dev Check the time since last update has exceeded token holding time or not
     * @param _lastUpd is last update time
     * @return the bool which tells if the time since last update has exceeded token holding time or not
     */
    function _checkLastUpd(uint _lastUpd) internal view returns(bool) {
        return (now - _lastUpd) > tokenHoldingTime;
    }

    /**
    * @dev Checks if the vote count against any solution passes the threshold value or not.
    */
    function _checkForThreshold(uint _proposalId, uint _category) internal view returns(bool check) {
        uint categoryQuorumPerc;
        uint roleAuthorized;
        (, roleAuthorized, , categoryQuorumPerc, , , ) = proposalCategory.category(_category);
        check = ((proposalVoteTally[_proposalId].memberVoteValue[0]
                            .add(proposalVoteTally[_proposalId].memberVoteValue[1]))
                        .mul(100))
                .div(
                    tokenInstance.totalSupply().add(
                        memberRole.numberOfMembers(roleAuthorized).mul(10 ** 18)
                    )
                ) >= categoryQuorumPerc;
    }
    
    /**
     * @dev Called when vote majority is reached
     * @param _proposalId of proposal in concern
     * @param _status of proposal in concern
     * @param category of proposal in concern
     * @param max vote value of proposal in concern
     */
    function _callIfMajReached(uint _proposalId, uint _status, uint category, uint max, MemberRoles.Role role) internal {
        
        allProposalData[_proposalId].finalVerdict = max;
        _updateProposalStatus(_proposalId, _status);
        emit ProposalAccepted(_proposalId);
        if (proposalActionStatus[_proposalId] != uint(ActionStatus.NoAction)) {
            if (role == MemberRoles.Role.AdvisoryBoard) {
                _triggerAction(_proposalId, category);
            } else {
                proposalActionStatus[_proposalId] = uint(ActionStatus.Accepted);
                proposalExecutionTime[_proposalId] = actionWaitingTime.add(now);
            }
        }
    }

    /**
     * @dev Internal function to trigger action of accepted proposal
     */
    function _triggerAction(uint _proposalId, uint _categoryId) internal {
        proposalActionStatus[_proposalId] = uint(ActionStatus.Executed);
        bytes2 contractName;
        address actionAddress;
        bytes memory _functionHash;
        (, actionAddress, contractName, , _functionHash) = proposalCategory.categoryActionDetails(_categoryId);
        if (contractName == "MS") {
            actionAddress = address(ms);
        } else if (contractName != "EX") {
            actionAddress = ms.getLatestAddress(contractName);
        }
        (bool actionStatus, ) = actionAddress.call(abi.encodePacked(_functionHash, allProposalSolutions[_proposalId][1]));
        if (actionStatus) {
            emit ActionSuccess(_proposalId);
        } else {
            proposalActionStatus[_proposalId] = uint(ActionStatus.Accepted);
            emit ActionFailed(_proposalId);
        }
    }

    /**
     * @dev Internal call to update proposal status
     * @param _proposalId of proposal in concern
     * @param _status of proposal to set
     */
    function _updateProposalStatus(uint _proposalId, uint _status) internal {
        if (_status == uint(ProposalStatus.Rejected) || _status == uint(ProposalStatus.Denied)) {
            proposalActionStatus[_proposalId] = uint(ActionStatus.NoAction);   
        }
        allProposalData[_proposalId].dateUpd = now;
        allProposalData[_proposalId].propStatus = _status;
    }

    /**
     * @dev Internal call to undelegate a follower
     * @param _follower is address of follower to undelegate
     */
    function _unDelegate(address _follower) internal {
        uint followerId = followerDelegation[_follower];
        if (followerId > 0) {

            followerCount[allDelegation[followerId].leader] = followerCount[allDelegation[followerId].leader].sub(1);
            allDelegation[followerId].leader = address(0);
            allDelegation[followerId].lastUpd = now;

            lastRewardClaimed[_follower] = allVotesByMember[_follower].length;
        }
    }

    /**
     * @dev Internal call to close member voting
     * @param _proposalId of proposal in concern
     * @param category of proposal in concern
     */
    function _closeMemberVote(uint _proposalId, uint category) internal {
        uint isSpecialResolution;
        uint abMaj;
        (, abMaj, isSpecialResolution) = proposalCategory.categoryExtendedData(category);
        if (isSpecialResolution == 1) {
            uint acceptedVotePerc = proposalVoteTally[_proposalId].memberVoteValue[1].mul(100)
            .div(
                tokenInstance.totalSupply().add(
                        memberRole.numberOfMembers(uint(MemberRoles.Role.Member)).mul(10**18)
                    ));
            if (acceptedVotePerc >= specialResolutionMajPerc) {
                _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, MemberRoles.Role.Member);
            } else {
                _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
            }
        } else {
            if (_checkForThreshold(_proposalId, category)) {
                uint majorityVote;
                (, , majorityVote, , , , ) = proposalCategory.category(category);
                if (
                    ((proposalVoteTally[_proposalId].memberVoteValue[1].mul(100))
                                        .div(proposalVoteTally[_proposalId].memberVoteValue[0]
                                                .add(proposalVoteTally[_proposalId].memberVoteValue[1])
                                        ))
                    >= majorityVote
                    ) {
                        _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, MemberRoles.Role.Member);
                    } else {
                        _updateProposalStatus(_proposalId, uint(ProposalStatus.Rejected));
                    }
            } else {
                if (abMaj > 0 && proposalVoteTally[_proposalId].abVoteValue[1].mul(100)
                .div(memberRole.numberOfMembers(uint(MemberRoles.Role.AdvisoryBoard))) >= abMaj) {
                    _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, MemberRoles.Role.Member);
                } else {
                    _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
                }
            }
        }

        if (proposalVoteTally[_proposalId].voters > 0) {
            tokenInstance.mint(ms.getLatestAddress("CR"), allProposalData[_proposalId].commonIncentive);
        }
    }

    /**
     * @dev Internal call to close advisory board voting
     * @param _proposalId of proposal in concern
     * @param category of proposal in concern
     */
    function _closeAdvisoryBoardVote(uint _proposalId, uint category) internal {
        uint _majorityVote;
        MemberRoles.Role _roleId = MemberRoles.Role.AdvisoryBoard;
        (, , _majorityVote, , , , ) = proposalCategory.category(category);
        if (proposalVoteTally[_proposalId].abVoteValue[1].mul(100)
        .div(memberRole.numberOfMembers(uint(_roleId))) >= _majorityVote) {
            _callIfMajReached(_proposalId, uint(ProposalStatus.Accepted), category, 1, _roleId);
        } else {
            _updateProposalStatus(_proposalId, uint(ProposalStatus.Denied));
        }
    }
}

