// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract FallBack {
    //给合约发送eth还有另外一种方式，可以将构造函数设置为payable，在部署合约时给合约传递
    constructor() payable{}

    event Log(string func, address sender, uint value, bytes data);
    
    fallback() external payable{
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable{
        emit Log("receive", msg.sender, msg.value, "");
    }
}