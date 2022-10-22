// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract X {

    function m1() public virtual pure returns (string memory) {
        return "xm1";
    }

    function m2() public virtual pure returns (string memory){
        return "xm2";
    }

    function x() public pure returns (string memory){
        return "x";
    }
    
}
contract Y is X{
    function m1() public virtual override pure returns (string memory) {
        return "ym1";
    }

    function m2() public virtual override pure returns (string memory){
        return "ym2";
    }

    function y() public pure returns (string memory){
        return "y";
    }
}
contract Z is X, Y{
    //m1 m2在两个合约中都有，所以必须要重写实现
    function m1() public override (Y,X) pure returns (string memory){
        return "zm1";
    }

    function m2() public override (X,Y) pure returns (string memory){
        return "zm2";
    }
}

contract M is X, Y {

    function m1() public override (Y,X) pure returns (string memory){
        return "mm1";
    }

    function m2() public override (X,Y) pure returns (string memory){
        return "mm2";
    }
    
    function callParent() public pure returns (string memory){
        //调用super.xxx方法，如果多个父合约都有，那么按照从右往左的顺序来
        return super.m1();
    }

    function callParent2() public pure returns (string memory){
        //调用super.xxx方法，如果多个父合约都有，那么按照从右往左的顺序来
        //如果想调用最左的父合约，可以直接使用如下 语法来进行调用
        return X.m1();
    }
}