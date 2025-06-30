// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProxyStake {
    uint public totalBalance;
    address public owner;
    mapping(address => uint) balances;

    constructor() {
        // constructor
        owner = msg.sender;
    }

    function stake() public payable {
        require(msg.value > 0,"Amount should be greater than 0");
        balances[msg.sender] += msg.value;
        totalBalance += msg.value;
    }

    function unstake(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Not staked this much eth");
        totalBalance-=_amount;
        balances[msg.sender] -= _amount;
        (bool success, ) = msg.sender.call{value : _amount}("");
        require(success);
    }

    function getBalace() public view returns (uint){
        return totalBalance;
    }
}