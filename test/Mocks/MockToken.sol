// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.20;

import { Token } from "../../src/contracts/Token.sol";

contract MockToken is Token {
    constructor(string memory name_, string memory symbol_, uint256 totalSupply_) Token(name_, symbol_, totalSupply_) {}

    function mint(address _account, uint256 _value) external {
        _mint(_account, _value);
    }

    function burn(address _owner, uint256 _value) external {
        _burn(_owner, _value);
    }
}