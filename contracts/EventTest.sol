// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract EventTest {

    address owner;

    constructor(){
        owner = msg.sender;
    }
    
    //indexed标记可以理解为索引，在以太坊中作为一个topic来进行存储，方便筛查转账地址和接收地址的转账事件
    //每个event事件中最多有3个标记为indexed的变量。每个indexed变量的大小固定是256bit。
    //事件的hash、这三个indexed变量一般在EVM中被存储为topic。
    event transfer(address indexed _from,  address indexed _to, uint val);

    function f_transfer(address _to, uint _val) external {
        //执行转账逻辑，调用该事件
        emit transfer(msg.sender, _to, _val);
    }

    modifier ownerPermission {
        require(msg.sender == owner);//需要保证合约的调用者是合约的拥有者
        _; //如果是的话，则继续运行；否则报错
    }

    //表示的含义是仅当是合约的拥有者才有权限去修改
    function changeOwner(address _newOwner) external ownerPermission{
        owner = _newOwner;
    }
}