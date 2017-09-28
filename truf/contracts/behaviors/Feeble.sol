pragma solidity ^0.4.13;

import "./Ownable.sol";
import "./SafeMath.sol";

// Collect system fees for support / multisig holders reward

contract Feeble is Ownable, SafeMath {

	uint public collectedFee;

	function Feeble() {
		collectedFee = 0;
	}

	//take fees
	function collectFee() onlyOwner returns(bool) {
		msg.sender.transfer(collectedFee);
		collectedFee = 0;
		return true;
	}

	//for tests
	function donate() payable returns(uint) {
		uint amount = msg.value;
		if (amount <= 0) {
			revert();
		}
		collectedFee = safeAdd(collectedFee, amount);
		return collectedFee;
	}
}