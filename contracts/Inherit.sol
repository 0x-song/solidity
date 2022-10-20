// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract A {
    
    function m1() public virtual pure returns (string memory){
        return "a";
    }

    function m2() public virtual pure returns (string memory){
        return "a";
    }

    function m3() public virtual pure returns (string memory){
        return "a";
    }
}

contract B is A{
    //如果B里面没有一个方法，部署之后会有A的几个方法

    function m1() public override pure returns (string memory){
        return "b";
    }

    function m2() public override pure returns (string memory){
        return "b";
    }
}