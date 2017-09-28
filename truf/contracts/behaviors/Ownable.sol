pragma solidity ^0.4.13;

contract Ownable {
    address public owner;

    function Ownable() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}