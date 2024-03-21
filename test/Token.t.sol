// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/contracts/Token.sol";
import "./Mocks/MockToken.sol";
import {Test, console} from "forge-std/Test.sol";

contract MyTokenTest is Test {
    MockToken internal mockToken;

    function setUp() public virtual {
        mockToken = new MockToken("mytoken", "MT", 0);
    }

    function testFuzz_metadata(string memory _name, string memory _symbol, uint256 _totalSupply) public {
        // arrange & act
        Token token = new Token(_name, _symbol, _totalSupply);

        // assert
        assertEq(token.name(), _name);
        assertEq(token.symbol(), _symbol);
        assertEq(token.totalSupply(), _totalSupply);
    }

    function testFuzz_mint(address _account, uint256 _value) public {
        // act
        mockToken.mint(_account, _value);

        // assert
        assertEq(mockToken.totalSupply(), _value);
        assertEq(mockToken.balanceOf(_account), _value);
    }

    function testFuzz_burn(address _account, uint256 _largeValue, uint256 _smallValue) public {
        if (_largeValue < _smallValue) return;

        // arrange
        mockToken.mint(_account, _largeValue);

        // act
        mockToken.burn(_account, _smallValue);

        // assert
        assertEq(mockToken.balanceOf(_account), _largeValue - _smallValue);
        assertEq(mockToken.totalSupply(), _largeValue - _smallValue);
    }

}