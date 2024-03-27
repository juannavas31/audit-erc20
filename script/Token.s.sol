// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Token} from "../src/contracts/Token.sol";

contract TokenScript is Script {
    function run() external returns (Token) {
        vm.startBroadcast();
        Token token = new Token("MyToken", "MT", 10000);
        vm.stopBroadcast();

        return token;
    }
}
