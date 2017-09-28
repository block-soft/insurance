pragma solidity ^0.4.13;

//Main logic for insurance
contract BasicParams {

	//number to multiply percent value to have 0-100 range
	uint constant PERCENT_DIVISION = 1000;

	//time between rounds
	uint constant ROUND_PERIOD = 60 * 60 * 24 * 7;
}