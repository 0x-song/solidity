// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract Account {

    address public owner;

    address public factory;

    constructor(address _owner) payable{
        factory = msg.sender;
        owner = _owner;
    }
}

contract AccountFactory{

    Account[] public accounts;

    function createAccount(address _owner) external payable{
        Account account = new Account{value:12345}(_owner);
        accounts.push(account);
    }
}