// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
//合约调用发起者
contract B {
    uint public num;

    address public sender;

    //通过发起call调用
    function callSetVariable(address _addr, uint _num) external payable{
       (bool result, bytes memory data) = _addr.call(abi.encodeWithSignature("setVariable(uint256)", _num));
    }

    //发起delegatecall
    function delegateCallSetVariable(address _addr, uint _num) external payable{
        (bool result, bytes memory data) = _addr.delegatecall{gas:100000}(abi.encodeWithSignature("setVariable(uint256)", _num));
    }
}
//合约被调用者
contract C {
    uint public num;

    address public sender;

    function setVariable(uint _num) public payable{
        num = _num;
        sender = msg.sender;
    }
}