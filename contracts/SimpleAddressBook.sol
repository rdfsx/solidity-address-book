// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract SimpleAddressBook {
  mapping(address => address[]) private _addresses;
  mapping(address => mapping(address => string)) private _aliases;
  mapping(address => mapping(string => bool)) private _isTakenAlias;

  event AddressBookCreated(address owner);
  event AliasAdded(address owner, address target, string _alias);
  event AliasRemoved(address owner, string _alias);

  modifier hasAddressBook() {
    require(_addresses[msg.sender].length != 0);
    _;
  }

  function createAddressBook() public payable {
    require(
      _addresses[msg.sender].length == 0,
      "You already have an address book!"
    );
    require(
      msg.value >= 0.1 ether,
      "You must pay at least 0.1 eth to create an address book!"
    );
    _addresses[msg.sender].push();
    emit AddressBookCreated(msg.sender);
  }

  function addAlias(address addr, string memory name) public hasAddressBook {
    require(!_isTakenAlias[msg.sender][name], "Alias is already taken!");
    _addresses[msg.sender].push(addr);
    _aliases[msg.sender][addr] = name;
    _isTakenAlias[msg.sender][name] = true;
    emit AliasAdded(msg.sender, addr, name);
  }

  function getAlias(address addr)
    public
    view
    hasAddressBook
    returns (string memory)
  {
    return _aliases[msg.sender][addr];
  }

  function getAddressArray() public view returns (address[] memory) {
    return _addresses[msg.sender];
  }

  function removeAddress(address addr) public {
    for (uint256 i = 0; i < _addresses[msg.sender].length; i++) {
      if (_addresses[msg.sender][i] == addr) {
        _addresses[msg.sender][i] = _addresses[msg.sender][
          _addresses[msg.sender].length - 1
        ];
        _addresses[msg.sender].pop();
        break;
      }
    }

    string memory _alias = _aliases[msg.sender][addr];
    delete _isTakenAlias[msg.sender][_alias];

    delete _aliases[msg.sender][addr];

    emit AliasRemoved(msg.sender, _alias);
  }
}
