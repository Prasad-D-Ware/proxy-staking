// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/ProxyStake.sol";
import "forge-std/Test.sol";

contract ProxyStakeTest is Test {
    ProxyStake public proxyStake;

    function setUp() public {
        proxyStake = new ProxyStake();
    }
}