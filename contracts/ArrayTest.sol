// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract Array1{
    //定长数组
    uint[8] arr1;
    bytes1[6] arr2;
    address[3] arr3;

    //不定长数组
    uint[] arr4;
    bytes1[] arr5;
    address[] arr6;
    //bytes类型比较特殊，表示数组
    bytes arr7;

    function testArray() public {
        //对于固定长度的数组会直接初始化数组，默认值全部为0；无法调用push方法
        //arr1.push();
        //只有不定长数组，也就是动态数组可以调用push方法；动态数组初始化时长度为0，无填充
        arr4.push();
        arr4.push(1);
        arr4.push(2);
        arr4.push(3);
        arr4.push(4);
        arr4.push(5);

    }
}