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