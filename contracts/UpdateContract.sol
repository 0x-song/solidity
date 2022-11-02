// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
//利用ProxyContract来调用那两个Update合约，这样可以实现合约的升级
//变量的值依然存储在ProxyConntract中
contract ProxyContract {
    
    uint public num;

    address public sender;

    uint public value;

    function setNum(address _target, uint _num) external payable{
       (bool result, bytes memory data) = _target.delegatecall(abi.encodeWithSignature("setNum(uint256)", _num));
       require(result, "delegatecall failed");
    }
}
//原先的合约逻辑
contract UpdateContract{

    uint public num;

    address public sender;

    uint public value;

    function setNum(uint _num) external payable{
        num = _num + 2;
        sender = msg.sender;
        value = msg.value;
    }
}
//升级之后的合约逻辑
contract UpdateContract2{

    uint public num;

    address public sender;

    uint public value;

    function setNum(uint _num) external payable{
        num = _num * 2;
        sender = msg.sender;
        value = msg.value;
    }
}