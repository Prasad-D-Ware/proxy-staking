// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITokenAddress {
    function mint(address _reciever, uint _value) external;
}

contract ProxyStake {
    uint public totalBalance;
    address public owner;
    mapping(address => uint) balances;
    address public tokenAddress;
    mapping(address => uint) rewards;
    mapping(address => uint) updatedAt;
    uint REWARD_PER_ETH = 1;

    constructor() {
        // constructor
        owner = msg.sender;
    }

    function _updateRewards(address _user) internal {
        if (updatedAt[_user] == 0) {
            updatedAt[_user] = block.timestamp;
            return;
        }
        uint currentReward = rewards[_user];
        uint timeDiff = block.timestamp - updatedAt[_user];

        if (timeDiff == 0) {
            return;
        }
        uint newReward = timeDiff * balances[_user] * REWARD_PER_ETH;
        rewards[_user] += currentReward + newReward;
        updatedAt[_user] = block.timestamp;
    }

    function stake() public payable {
        require(msg.value > 0, "Amount should be greater than 0");
        _updateRewards(msg.sender);
        balances[msg.sender] += msg.value;
        totalBalance += msg.value;
    }

    function unstake(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Not staked this much eth");
        _updateRewards(msg.sender);
        balances[msg.sender] -= _amount;
        totalBalance -= _amount;
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success);
    }

    function getTotalBalace() public view returns (uint) {
        return totalBalance;
    }

    function getBalanceOf(address _address) public view returns (uint) {
        return balances[_address];
    }

    function setTokenAddress(address _tokenAddress) public {
        require(msg.sender == owner, "Only owner can set token address");
        tokenAddress = _tokenAddress;
    }

    function claimReward() public {
        _updateRewards(msg.sender);
        ITokenAddress(tokenAddress).mint(msg.sender, rewards[msg.sender]);
        rewards[msg.sender] = 0;
    }

    function getRewardAvailable() public view returns (uint) {
        uint timeDiff = block.timestamp - updatedAt[msg.sender];
        if (timeDiff == 0) {
            return rewards[msg.sender];
        }

        uint reward = (timeDiff * balances[msg.sender] * REWARD_PER_ETH) +
            rewards[msg.sender];
        return reward;
    }
}
