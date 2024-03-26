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

    function testFuzz_approve(address _spender, uint256 _value) public {
        // arrange
        address owner = address(this);
        mockToken.mint(owner, _value);
        vm.assume(address(_spender) != address(0x0));

        // act
        mockToken.approve(_spender, _value);

        // assert
        assertEq(mockToken.allowance(owner, _spender), _value, "Allowance should equal _value");
    }

    function test_approve_spender_cannot_be_zero_address() public {
        // arrange
        address spender = address(0x0);
        address owner = msg.sender;
        mockToken.mint(owner, 100); 

        // act & assert
        vm.expectRevert();
        mockToken.approve(spender, 100);
    }

}