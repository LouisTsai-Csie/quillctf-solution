// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import {RoadClosed} from "../../src/Road-Closed/victim.sol";
import {Attack} from "../../src/Road-Closed/attack.sol";

contract RoadClosedTest is Test {

    RoadClosed public roadClosed;
    Attack public attack;

    function setUp() public {
        roadClosed = new RoadClosed();
    }

    function testSolveChallenge() public {
        address user = makeAddr("user");
        vm.startPrank(user);
        attack = new Attack(address(roadClosed));
        vm.stopPrank();
        assertEq(roadClosed.isHacked(), true);
    }

}
