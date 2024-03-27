// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/contracts/Token.sol";
import "./Mocks/MockToken.sol";
import {Test, console} from "forge-std/Test.sol";

contract MyTokenTest is Test {
    MockToken internal mockToken;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

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
        // arrange
        vm.assume(_account != address(0));

        // act
        mockToken.mint(_account, _value);

        // assert
        assertEq(mockToken.totalSupply(), _value);
        assertEq(mockToken.balanceOf(_account), _value);
    }

    function testFuzz_burn(address _account, uint256 _largeValue, uint256 _smallValue) public {
        // arrange
        vm.assume(_account != address(0));

        if (_largeValue < _smallValue) return;

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
        vm.expectEmit(true, true, false, true);
        emit Approval(owner, _spender, _value);

        // act
        assertTrue(mockToken.approve(_spender, _value));

        // assert
        assertEq(mockToken.allowance(owner, _spender), _value, "Allowance should equal _value");
    }

    function test_approve_spender_cannot_be_zero_address() public {
        // arrange
        address spender = address(0x0);
        address owner = msg.sender;
        mockToken.mint(owner, 100); 

        // act & assertº
        vm.expectRevert();
        mockToken.approve(spender, 100);
    }

    function testFuzz_transfer(address _receiver, uint256 _value) public {
        // arrange
        vm.assume(_receiver != address(0));
        address owner = address(this);
        uint256 initialTotalSupply = mockToken.totalSupply();
        mockToken.mint(owner, _value);
        vm.expectEmit(true, true, false, true);
        emit Transfer(owner, _receiver, _value);

        // act 
        assertTrue(mockToken.transfer(_receiver, _value));

        // assert
        assertEq(mockToken.totalSupply(), initialTotalSupply + _value, "Incorrect total supply");
        assertEq(mockToken.balanceOf(_receiver), _value, "Incorrect receiver balance");
    }

    function testFuzz_transferFrom(address _spender, uint256 _value) public {
        // arrange
        address owner = address(this);
        address _receiver = address(0x00000000000000000000000000000000000006C5);
        vm.assume(_spender != address(0));
        vm.assume(owner != address(0));

        mockToken.mint(owner, _value);
        mockToken.approve(_spender, _value);

        // act
        vm.prank(_spender);
        assertTrue(mockToken.transferFrom(owner, _receiver, _value));

        // assert
        assertEq(mockToken.balanceOf(_receiver), _value, "Incorrect balance of receiver");
        assertEq(mockToken.balanceOf(_spender), 0, "Incorrect balance of spender");
        assertEq(mockToken.balanceOf(owner), 0, "Incorrect balance of owner");
    }
}