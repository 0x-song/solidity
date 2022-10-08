// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract A{

    function callMethod() public returns (uint){
        //这里发生了什么？为什么会获取不到结果？
        //每调用一次new，那么链上肯定会生成一个新的合约，在internal txns中可以看到
        B b = new B();
        return b.say();
    }
}


contract B{

    function say() public pure returns (uint){
        return 10;
    }
}