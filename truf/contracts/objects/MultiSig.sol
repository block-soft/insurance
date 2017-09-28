pragma solidity ^0.4.13;

import "./Customers.sol";

contract MultiSig is Customers {

    struct sign {
    int8 verdict; // 0 - no verdict, -1 - negative and 1 - positive
    bool isValue; // to check if address exists
    }

    address public APPROVER_1 = 0x668b53A4399a9c5072170161AB6434Db6e0297Cc; // TODO: hardcode real address
    address public APPROVER_2 = 0x33BDc3912BFED78E3b859F23BDAE4C414CB91EB1; // TODO: hardcode real address
    address public APPROVER_3 = 0x8ab83928F45D70682e458f9f4d103715Ad4B1020; // TODO: hardcode real address
    address public APPROVER_4 = 0x4EEa9723961a0C683855a8203e2b3EcBf56C6486; // TODO: hardcode real address
    address public APPROVER_5 = 0x981E8b390aDc58542D80BFb6854C4b3fD6DF520C; // TODO: hardcode real address


    mapping (address => sign) public signs;

    uint public approves = 0;
    uint public declines = 0;

    function MultiSig() {
        signs[APPROVER_1].isValue = true;
        signs[APPROVER_2].isValue = true;
        signs[APPROVER_3].isValue = true;
        signs[APPROVER_4].isValue = true;
        signs[APPROVER_5].isValue = true;
    }

    function approve() {
        if (!signs[msg.sender].isValue) {
            revert();
        }

        if (signs[msg.sender].verdict == 0) {
            signs[msg.sender].verdict = 1;
            approves++;
        } else if (signs[msg.sender].verdict == -1) {
            signs[msg.sender].verdict = 1;
            approves++;
            declines--;
        }

        if (approves >= 3) {
            for (uint i=1; i<= customersCount; i++){
                customers[i].customer.transfer(customers[i].total_get);
            }
            suicide(owner);
        }
    }

    function decline() {
        if (!signs[msg.sender].isValue) {
            revert();
        }

        if (signs[msg.sender].verdict == 0) {
            signs[msg.sender].verdict = -1;
            declines++;
        } else if (signs[msg.sender].verdict == 1) {
            signs[msg.sender].verdict = -1;
            approves--;
            declines++;
        }

        if (declines >= 3) {
            suicide(owner);
        }
    }

}
