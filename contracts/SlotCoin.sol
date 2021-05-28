// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Powerball contract
// Keep up and until the moon!

// To implement: 1. liquidity pool, 2. winning probability 3. how close you were versus winning (just to show in front end)
//               4. how to deal with contract balance received from airdrop
// Key question -- what's balance for this, and what's balance for owner?

contract FreePowerball is ERC20, Ownable {

	using SafeMath for uint256;
	using Address for address;

	// contract setup
	uint256 private _ownershipLimit = 5; // in 0.0001

	// fee structure
	//uint256 private _totalSupply = 1 * 10 ** 12 * 10 ** 18;
	uint256 private _rewardFee = 4;
	uint256 private _liquidityFee = 2;
	uint256 private _rewardPool;

	// monetary system
	uint256 private _mTotalBase = 10 ** 15;
	uint256 private _mMultiplierPrecision = 10 ** 10;
	uint256 private _mMultiplier = 1 * _mMultiplierPrecision;
	uint256 private _mTotalSupply = _mTotalBase.mul(_mMultiplier).div(_mMultiplierPrecision);

	// previous day trading volume
	uint256 private _previousDayStart = 0;
	uint256 private _previousDayVol = 0;
	uint256 private _currentDayVol = 0;

	// winning probability
	uint256 private _volumeWinProbMultiplier = 1; // prob = a * vol% + b * holding %
	uint256 private _holdingWinProbMultiplier = 2;
	uint256 private _step1ProbMultiplier = 100; // this = 100 / _step2ProbCap
	uint256 private _step1ProbCap = 80;
	uint256 private _step2ProbCap = 1; // 1%, 2% or 4%

	// winner verification -- to prevent hacks
	address private _lastBuyder = address(0);
	uint256 private _firstVerifier = 5;
	uint256 private _secondVerifier = 10;
	uint256 private _winVeirificationMod1 = 10;
	uint256 private _winVeirificationMod2 = 10;
	bool private _lotteryInVerification = false;
	address private _lotteryCandidate;
	uint256 private _lotteryCandidateHash;
	uint256 private _numOfVerifier = 0;

	// lottery
	uint256 private _lotteryPrecision = 10 ** 7; // need to be bigger than total balance, or have a floor
	uint256 private _prizeShare = 5; // 10% of the reward pool is given out to the lottery winner -- can make the probability higher
	uint256 private _airDropShare = 5; // 10% of the reward pool is given out in an airdrop
	bool private _lotteryLocked = false;
	address private _lockedCandidate = address(0);
	uint256 private _lockedHash = 0;
	uint256 private _currentRound = 0;

	// historical lottery info

	struct lotteryHistory {
				uint256 time;
				uint256 reward;
				address winner;
    }
	mapping (address => uint256) private _redeemable;
	mapping (uint256 => lotteryHistory) private _previousRounds;
	mapping (address => uint256[3]) private _lastParticipance;


	// diable special transfer
	bool private _specialTransferDisabled = false;

	event LaunchedAndSpecialTransferDisabled();
	event LotterWinner(address winner);
	event AirDrop(uint256 amount);
	event LotterRedeemed(address winner, uint256 reward);

	constructor () ERC20("FreePowerball", "POWERBALL") Ownable() public {
		_balances[owner()] = _mTotalBase;
		emit Transfer(address(0), owner(), _mTotalBase);
	}


	// --------------------------------------------------------------------------
	// Monetary system
	// --------------------------------------------------------------------------

	function _baseToMoney(uint256 amountBase) private view returns (uint256) {
		return amountBase.mul(_mMultiplier);
	}


	function _moneyToBase(uint256 amountMoney) private view returns (uint256) {
		return amountMoney.div(_mMultiplier);
	}


	function getMoneyMultiplier() private view returns (uint256) {
		return _mMultiplier;
	}


	// // view total balance
	function getTotalBalance() public view returns (uint256) {
		return _baseToMoney(_mTotalBase);
	}


	// view reward pool balance
	function getRewardBalance() public view returns (uint256) {
		return _baseToMoney(_rewardPool);
	}


	// view real balance of each account
	function balanceOf(address account) public view override returns (uint256) {
			return _baseToMoney(_balances[account]);
	}


	// check total in circulation
	// total base money: reward pool + holders + contract holding + liquidity pool
	function getTotalCirculation(bool baseBool) public view returns (uint256) {
		uint256 inCirculation = _mTotalBase - _rewardPool - _balances[address(this)];
		if (baseBool) {
				return inCirculation;
		}
		return _baseToMoney(inCirculation);
	}


	// --------------------------------------------------------------------------
	// control
	// --------------------------------------------------------------------------

	function setOwnershipLimit(uint256 limit) public onlyOwner() {
		_ownershipLimit = limit;
	}


	function setTaxFeePercent(uint256 reward, uint256 liquidity) public onlyOwner() {
		_rewardFee = reward;
		_liquidityFee = liquidity;
	}


	function setVerifier(uint256 verifier1, uint256 verifier2) public onlyOwner() {
		_firstVerifier = verifier1;
		_secondVerifier = verifier2;
	}


	function setWinningProb(uint256 newVolumeWinMultiple, uint256 newHoldingWinMultiple, uint256 newStep1Cap, uint256 newStep2Cap) public onlyOwner() {
		_volumeWinProbMultiplier = newVolumeWinMultiple; // prob = a * vol% + b * holding %
		_holdingWinProbMultiplier = newHoldingWinMultiple;
		_step1ProbCap = newStep1Cap;
		_step2ProbCap = newStep2Cap;
		require(((_step2ProbCap == 1) || (_step2ProbCap == 2) || (_step2ProbCap == 4)), "Winning prob cap has only three options 1, 2, 4");
		// to maintain the winning probability -- adjust the step1 probabiity based on verification probability
		if (_step2ProbCap == 1) {
			_winVeirificationMod1 = 10;
			_winVeirificationMod2 = 10;
			_step1ProbMultiplier = 100;
		}
		if (_step2ProbCap == 2) {
			_winVeirificationMod1 = 5;
			_winVeirificationMod2 = 10;
			_step1ProbMultiplier = 50;
		}
		if (_step2ProbCap == 4) {
			_winVeirificationMod1 = 5;
			_winVeirificationMod2 = 5;
			_step1ProbMultiplier = 25;
		}
	}


	function setPrizeDropShare(uint256 newPrizeShare, uint256 newAirDropShare) public onlyOwner() {
		_prizeShare = newPrizeShare;
		_airDropShare = newAirDropShare;
	}


	// --------------------------------------------------------------------------
	// airdrop
	// --------------------------------------------------------------------------


	function _autoAirDrop() private {
		uint256 contractBalancePre = _baseToMoney(_balances[address(this)]);

		uint256 mAmountAirDrop = _rewardPool.mul(_airDropShare).div(100);
		_rewardPool -= mAmountAirDrop;
		_mMultiplier = _mMultiplier.mul(_mTotalBase.mul(_mMultiplierPrecision).div(_mTotalBase - mAmountAirDrop)).div(_mMultiplierPrecision);
		_mTotalBase -= mAmountAirDrop;
		emit AirDrop(mAmountAirDrop);

		// burn the ones received by contract
		uint256 contractBalanceAfter = _baseToMoney(_balances[address(this)]);
		uint256 toBurn = _moneyToBase(contractBalanceAfter - contractBalancePre);
		_burn(address(this), toBurn);
	}


	function manualAirDrop(uint256 percentageToDrop) public onlyOwner() {
		uint256 contractBalancePre = _baseToMoney(_balances[address(this)]);

		require(percentageToDrop <= 99, "Not enough amount in reward pool to airdrop");
		uint256 mAmountAirDrop = _rewardPool.mul(percentageToDrop).div(100);
		_rewardPool -= mAmountAirDrop;
		_mMultiplier.mul(_mTotalBase.mul(_mMultiplierPrecision).div(_mTotalBase - mAmountAirDrop)).div(_mMultiplierPrecision);
		_mTotalBase -= mAmountAirDrop;
		emit AirDrop(mAmountAirDrop);

		// burn the ones received by contract
		uint256 contractBalanceAfter = _baseToMoney(_balances[address(this)]);
		uint256 toBurn = _moneyToBase(contractBalanceAfter - contractBalancePre);
		_burn(address(this), toBurn);
	}


	// --------------------------------------------------------------------------
	// transfer
	// --------------------------------------------------------------------------


	// compute values before transfer happens
	function _getTransferValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
		uint256 rewardToCollect = tAmount.mul(_rewardFee).div(100);
		uint256 liquidityToCollect = tAmount.mul(_liquidityFee).div(100);
		uint256 amountToTransfer = tAmount.sub(rewardToCollect).sub(liquidityToCollect);
		return (amountToTransfer, rewardToCollect, liquidityToCollect);
	}


	// transfer function
	function _transfer(address sender, address receipient, uint256 amountIn) internal override {

		// update trading volume
		_updateTradingVolume();

		// convert money to base amount
		uint256 amount = _moneyToBase(amountIn);

		// check eligibility
		require(sender != address(0), "ERC20: transfer from the zero address");
		require(receipient != address(0), "ERC20: transfer to the zero address");
		uint256 senderBalance = _balances[sender];
		require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");

		// compute amount to be received
		(uint256 amountAfterTax, uint256 rewardToCollect, uint256 liquidityToCollect) = _getTransferValues(amount);

		// check if new ownership is below limit + redeem
		uint256 newOwnership = _balances[receipient] + amountAfterTax;
		uint256 redeemable = _redeemable[receipient];
		if (redeemable < 1) {
			require(newOwnership.mul(10000).div(_mTotalBase) <= _ownershipLimit, "Amount after purchase exceeds ownership limit");
		}
		else {
			uint baseToRedeem = redeemable.mul(_rewardPool).div(100);
			newOwnership += baseToRedeem;
			_rewardPool -= baseToRedeem;
			_autoAirDrop();
			emit LotterRedeemed(receipient, baseToRedeem);
		}

		// make the transfer
		_rewardPool += rewardToCollect;
		_balances[sender] = senderBalance - amount;
		_balances[receipient] = newOwnership;
		emit Transfer(sender, receipient, amountAfterTax);

		// cumulating trading volume and track last buyer
		_currentDayVol += amount;
		_lastBuyder = receipient;

		// if lottery is open -- if the person is eligible, run step 1
		if (!_lotteryLocked) {
			if (_getAvailabilityForLottery(receipient)) {
				_checkWinStep1(receipient, amount);
			}
			else {
				_numOfVerifier += 1;
				_lastParticipance[receipient] = [block.timestamp, _currentRound, 0];

				if (_numOfVerifier == _firstVerifier) {
					_checkWinStep2Verification1(receipient, amount);
				}

				if (_numOfVerifier == _secondVerifier) {
					_checkWinStep2Verification2(receipient, amount);
				}
			}
		}
	}


	function _updateTradingVolume() private {
		if (block.timestamp - _previousDayStart > 1 days) {
			_previousDayStart = block.timestamp;
			_previousDayVol = _currentDayVol;
			_currentDayVol = 0;
		}
	}


	// --------------------------------------------------------------------------
	// probabilities
	// --------------------------------------------------------------------------


	// winning p1 based on holding
	function _getHoldingPercentage(address buyer) private view returns (uint256) {
		uint256 eligibleShares = getTotalCirculation(true);
		return balanceOf(buyer).mul(_lotteryPrecision).div(eligibleShares);
	}


	// winning p2 based on volume
	function _getVolumePercentage(uint256 amount) private view returns (uint256) {
		return amount.mul(_lotteryPrecision).div(_previousDayVol);
	}


	// generate winning probability
	function _getWinProbStep1(address buyer, uint256 amount) private view returns (uint256) {
		uint256 prob;
		prob = _getHoldingPercentage(buyer) * _holdingWinProbMultiplier;
		prob += _getVolumePercentage(amount) * _volumeWinProbMultiplier;
		if (prob == 0){
			prob += _lotteryPrecision / 10000; // lowest probability is 1/10000
		}
		if (prob >= _step1ProbCap * _lotteryPrecision / 100){
			prob = _step1ProbCap * _lotteryPrecision / 100; // capped ste1 prob
		}
		return prob;
	}


	// check if step 1 wins
	function _checkWinStep1(address buyer, uint256 amount) private returns (bool) {
		uint256 lotteryHash = uint256(keccak256(abi.encode(buyer, _lastBuyder ,amount, block.timestamp))) % _lotteryPrecision;
		if (lotteryHash < _getWinProbStep1(buyer, amount)) {
			_lotteryLocked = true;
			_lockedCandidate = buyer;
			_lockedHash = lotteryHash;
			return true;
		}
		_lastParticipance[buyer] = [block.timestamp, _currentRound, 0];
		return false;
	}


	// two verifications for the winner
	function _checkWinStep2Verification1(address verifier, uint amount) private {
			uint256 verifyHash1 = uint256(keccak256(abi.encode(verifier, amount, block.timestamp))) % _winVeirificationMod1;
			if (_lockedHash % _winVeirificationMod1 == verifyHash1) {
				return;
			}
			else {
				_lastParticipance[_lockedCandidate] = [block.timestamp, _currentRound, 1];
				_unlockLotteryPool();
				return;
			}
	}


	function _checkWinStep2Verification2(address verifier, uint amount) private {
			uint256 verifyHash2 = uint256(keccak256(abi.encode(verifier, amount, block.timestamp))) % _winVeirificationMod2;
			if (_lockedHash % _winVeirificationMod2 == verifyHash2) {
				_redeemable[_lockedCandidate] = _prizeShare;
				_previousRounds[_currentRound] = lotteryHistory(block.timestamp, _prizeShare, _lockedCandidate);
				_lastParticipance[_lockedCandidate] = [block.timestamp, _currentRound, 2];
				return;
			}
			else{
				_unlockLotteryPool();
			}
	}


	function _unlockLotteryPool() private {
		_lotteryLocked = false;
		_lockedCandidate = address(0);
		_lockedHash = 0;
		_numOfVerifier = 0;
		return;
	}


	// --------------------------------------------------------------------------
	// lottery
	// --------------------------------------------------------------------------


	function getRedeemable(address buyer) public view returns(uint256) {
		return _baseToMoney(_redeemable[buyer]);
	}


	function _getAvailabilityForLottery(address buyer) private view returns(bool) {
		if (buyer == address(this)) {
			return false;
		}
		else return (block.timestamp - _lastParticipance[buyer][0] >= 1 days);
	}


	function getCurrentRound() public view returns(uint256) {
		return _currentRound;
	}


	function getHistRoundInfo(uint256 round) public view returns(uint256, uint256, address) {
		return (_previousRounds[round].time, _previousRounds[round].reward, _previousRounds[round].winner);
	}


	function getHistPersonalInfo(address buyer) public view returns(uint256, uint256) {
		return (_lastParticipance[buyer][0], _lastParticipance[buyer][1]);
	}


	// --------------------------------------------------------------------------
	// special transfer
	// --------------------------------------------------------------------------

	function _burn(address account, uint256 amount) internal override {
			require(account != address(0), "ERC20: burn from the zero address");
			_beforeTokenTransfer(account, address(0), amount);
			uint256 accountBalance = _balances[account];
			require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
			_balances[account] = accountBalance - amount;
			_mTotalBase -= amount;
			emit Transfer(account, address(0), _baseToMoney(amount));
	}


	function disableSpecialTransfer() public {
		_specialTransferDisabled = true;
		emit LaunchedAndSpecialTransferDisabled();
	}


	// vanilla transfer
	function specialVanillaTransfer(address sender, address receipient, uint256 amountIn) public {

		require(!_specialTransferDisabled, "Special Transfer is already disabled");

		// convert money to base amount
		uint256 amount = _moneyToBase(amountIn);

		// check eligibility
		require(sender != address(0), "ERC20: transfer from the zero address");
		require(receipient != address(0), "ERC20: transfer to the zero address");
		uint256 senderBalance = _balances[sender];
		require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
		_balances[sender] = senderBalance - amount;
		_balances[receipient] += amount;
		emit Transfer(sender, receipient, amountIn);

	}


}
