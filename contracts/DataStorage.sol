// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract DataStorage {

    uint[] x  = [1,2,3];
    
    function callData1(uint[] calldata _x) public pure returns (uint[] calldata) {
        //calldata类型的变量不可以被修改
        //calldata arrays are read-only
        //_x[0] = 1;
        return _x;
    }

    function storage1() public{
        uint[] storage xs = x;
        xs[0] = 100;
    }

    function memory1() public{
        //storage赋值给memory
        uint[] memory xm = x;
        xm[0] = 100;
        xm[1] = 200;
        x[0] = 400;
    }

    function memory2() public{
        //memory类型的变量赋值给memory，会创建引用，修改一个，另外一个也会随之修改
        //创建memory的数组，需要使用如下方式
        //但是目前依然有困惑：为什么不可以使用uint[] memory xm1 = [1,2,3,4]...
        uint[] memory xm1 = new uint[](7);
        xm1[0] = 1;
        xm1[1] = 2;
        xm1[2] = 3;
        xm1[3] = 4;
        xm1[4] = 4;
        xm1[5] = 5;
        xm1[6] = 6;
        uint[] memory xm2 = xm1;
        xm2[0] = 7;
    }

}