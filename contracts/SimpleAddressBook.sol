// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;


contract SimpleAddressBook {

    mapping(address => address[]) private _addresses;
    mapping(address => mapping(address => string)) private _aliases;

    modifier hasAddressBook {
        require(_addresses[msg.sender].length != 0);
        _;
    }

    function createAddressBook() public {
        _addresses[msg.sender].push();
    }

    function addAlias(address addr, string memory name) public hasAddressBook {
        _addresses[msg.sender].push(addr);
        _aliases[msg.sender][addr] = name;
    }

    function getAlias(address addr) public {

    }
}
