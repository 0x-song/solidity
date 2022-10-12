// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract Array2{
    //数组的创建规则
    function memoryArray() public{
        uint[] memory arr1 = new uint[](3);
        arr1[0] = 1;
        arr1[1] = 3;
        arr1[2] = 5;

        uint[4] memory arr2 = [uint(1),5,7,9];

        string[2] memory arr3 = ["hello", "solidity"];

        //uint a = 1;
    }
    
}