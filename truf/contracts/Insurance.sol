pragma solidity ^0.4.13;

import "./behaviors/Ownable.sol";
import "./behaviors/Feeble.sol";
import "./behaviors/SafeMath.sol";
import "./objects/MultiSig.sol";


//Main logic for insurance
contract Insurance is MultiSig {

	//date of round creation
	uint public roundCrtime;

	//create contract and start first round
	function Insurance() {
		roundCrtime = block.timestamp;
		investorsCount = 0;
		proposalsCount = 0;
		customersCount = 0;
	}

	function () {
		//no eth to the address
		revert();
	}

	//when new round will be started ?
	function timeNewRound() constant returns (uint256 time) {
		return roundCrtime + ROUND_PERIOD;
	}
	//lets start new round
	function newRound() returns (bool) {
		if (roundCrtime + ROUND_PERIOD < block.timestamp) {
			//no time yet
			return false;
		} else {
			//do new round
			roundCrtime = block.timestamp;
			for (uint i=1; i<= proposalsCount; i++){
				if (proposals[i].canceled) {
					investors[proposals[i].investor_index].free_balance
					= safeAdd(investors[proposals[i].investor_index].free_balance, proposals[i].gives);
					proposals[i].gives = 0;

				}
				if (proposals[i].paid > 0) {
					investors[proposals[i].investor_index].free_balance
					= safeAdd(investors[proposals[i].investor_index].free_balance, proposals[i].paid);
					proposals[i].paid = 0;
					proposals[i].left = proposals[i].gives;
				}
			}
			for (i=1; i<= customersCount; i++){
				customers[i].total_get = 0;
			}
			return true;
		}
	}
}
