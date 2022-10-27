// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract A {
    
    function setX(address _add, uint _x)external{
        //另一个合约当做类型，传递地址
        B(_add).setX(_x);
    }

    function setX2(B _add, uint _x) external{
        //还有另外一种调用方式，直接以B合约类型作为参数
        _add.setX(_x);
    }

    function getX(address _add) external view returns (uint){
       return B(_add).getX();
    }

    //返回值也可以使用下面这种方式来编写
    function getX2(address _add) external view returns (uint result){
       result = B(_add).getX();
    }

    function setXAndReceiveEther(address _add, uint _x) external payable{
        B(_add).setXAndReceiveEther{value:msg.value}(_x);
    }

    function getXAndBal(address _add) external view returns (uint x, uint y){
        (x, y) = B(_add).getXAndEther();
    }

}

contract B{
    uint public x;
    uint public bal;

    function setX(uint _x)external {
        x = _x;
    }

    function getX() external view returns (uint){
        return x;
    }

    function setXAndReceiveEther(uint _x) external payable{
        x = _x;
        bal = msg.value;
    }

    function getXAndEther() external view returns (uint, uint){
        return (x, bal);
    }
}