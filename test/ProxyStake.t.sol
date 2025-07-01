// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/ProxyStake.sol";
import "forge-std/Test.sol";

contract ProxyStakeTest is Test {
    ProxyStake public proxyStake;

    receive() external payable {}

    function setUp() public {
        proxyStake = new ProxyStake();
    }
    
    function test_stake() public {
        proxyStake.stake{value : 10 ether}();
        assert(proxyStake.totalBalance() == 10 ether);
    }

    function test_unstake() public {
        proxyStake.stake{value : 10 ether}();
        assert(proxyStake.totalBalance() == 10 ether);

        proxyStake.unstake(5 ether);

        assert(proxyStake.totalBalance() == 5 ether);
    }   

}