pragma solidity ^0.4.11;

import "./BasicParams.sol";
import "./Investors.sol";
import "../behaviors/SafeMath.sol";

//Customers part
contract Customers is Investors {

	//customers counter for web3 to make requests to see all data
	uint public customersCount;

	//customer structure
	struct Customer {
		address customer; //customer address
		uint256 total_paid; //all money customer had paid
		uint256 total_get; //all money customer will get
	}

	//customers to indexes
	mapping (address => uint) customersToIndexes;

	//indexed customers storage
	mapping(uint => Customer) customers;

	///how to become customer
	//pay to this function and tell how much max will you pay
	function becomeCustomer(uint found_i) payable returns(uint) {
		uint pays = msg.value;
		uint256 will_get = safeDiv(pays * 100 * PERCENT_DIVISION, proposals[found_i].gets);

		uint256 subbed = safeSub(proposals[found_i].left, will_get);
		if (subbed > 0) {
			proposals[found_i].left = subbed;
		} else if (subbed < 0) {
			revert();
		} else {
			delete proposals[found_i].left;
		}

		proposals[found_i].paid = proposals[found_i].paid + pays;

		//check if customer is already in the system
		uint index = customersToIndexes[msg.sender];
		if (index > 0) {
			customers[index].total_paid = customers[index].total_paid + pays;
			customers[index].total_get = customers[index].total_get + will_get;
		} else {
			customersCount++;
			index = customersCount;
			customers[index].customer = msg.sender;
			customers[index].total_paid = pays;
			customers[index].total_get = will_get;
		}

		return will_get;
	}

	function getCustomer(uint index) constant returns( address a, uint256 b, uint256 c) {
		a = customers[index].customer;
		b = customers[index].total_paid;
		c = customers[index].total_get;
	}
}
