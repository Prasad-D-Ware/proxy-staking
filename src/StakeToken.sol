// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakeToken is ERC20, Ownable {
    address public StakingContract;

    constructor(address _StakingContract) ERC20("STAKETOKEN", "ST") Ownable(msg.sender) {
        StakingContract = _StakingContract;
    }

    function mint(address _reciever, uint _value) public {
        require(
            msg.sender == StakingContract,
            "Only Staking Contract can mint new tokens"
        );
        _mint(_reciever, _value);
    }

    function setStakingContract(address _StakingContract) public onlyOwner {
        StakingContract = _StakingContract;
    }
}