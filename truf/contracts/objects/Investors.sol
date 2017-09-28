pragma solidity ^0.4.13;

import "./BasicParams.sol";
import "../behaviors/SafeMath.sol";
import "../behaviors/Feeble.sol";

//Customers part
contract Investors is BasicParams, SafeMath, Feeble {

	//investors counter for web3 to make requests to see all data
	uint public investorsCount;

	//investors structure
	struct Investor {
	address investor; //investor address
	uint256 total_balance; //all money investor has in the system
	uint256 free_balance; //free money investor can take away the system
	}

	//investors to indexes
	mapping (address => uint) investorsToIndexes;

	//indexed investors storage
	mapping(uint => Investor) investors;

	//proposals counter for web3 to make requests to see all data
	uint public proposalsCount;

	//proposals structure
	struct Proposal {
		uint investor_index; //index to investor data
		uint256 gives; //money investor gives to system
		uint256 gets; //percent investro wants for usage
		uint256 left; //money not used by customers
		uint256 paid; //money customer paid (and will go to investor when round will be finished)
		bool canceled; //proposal will be returned to investor at the end of the round
	}

	//indexed proposals storage
	mapping(uint => Proposal) proposals;

	//how to become investor
	//pay to this function and tell
	function becomeInvestor(uint256 gets) payable returns(bool) {
		//if (msg.value < 10) {
		//	revert();
		//}
		if (gets < 0 || gets > 100 * PERCENT_DIVISION) {
			gets = 10 * PERCENT_DIVISION; //default value
		}
		uint gives = msg.value;

		//check if investor is already in the system
		uint index = investorsToIndexes[msg.sender];
		if (index > 0) {
			investors[index].total_balance = safeAdd(investors[index].total_balance, gives);
		} else {
			investorsCount++;
			index = investorsCount;
			investors[index].investor = msg.sender;
			investors[index].total_balance = gives;
			investors[index].free_balance = 0;
			investorsToIndexes[msg.sender] = index;
		}
		//add proposal to the row
		proposalsCount++;
		proposals[proposalsCount].investor_index = index;
		proposals[proposalsCount].gives = gives;
		proposals[proposalsCount].gets = gets;
		proposals[proposalsCount].left = gives;
		proposals[proposalsCount].paid = 0;
		proposals[proposalsCount].canceled = false;
	}

	//withdraw money
	function collectMoney(uint256 amount) returns(bool) {
		uint index = investorsToIndexes[msg.sender];
		if (index > 0) {
			if (investors[index].free_balance > amount) {
				revert();
			}
			investors[index].free_balance = safeSub(investors[index].free_balance, amount);
			collectedFee = safeDiv(amount, 10000);
			if (collectedFee < 1) collectedFee = 1;
			msg.sender.transfer(amount - collectedFee);
		} else {
			revert();
		}
	}

	function cancelProposal(uint index) returns(bool) {
		if (proposals[index].investor_index != investorsToIndexes[msg.sender]) {
			revert();
		}
		proposals[index].canceled = true;
		return true;
	}

	function getInvestor(uint index) constant returns( address a, uint256 b, uint256 c) {
		a = investors[index].investor;
		b = investors[index].total_balance;
		c = investors[index].free_balance;
	}

	function getProposal(uint index) constant returns( address a, uint256 b, uint256 c, uint256 d, uint256 e, bool f) {
		a = investors[proposals[index].investor_index].investor;
		b = proposals[index].gives;
		c = proposals[index].gets;
		d = proposals[index].left;
		e = proposals[index].paid;
		f = proposals[index].canceled;
	}
}
