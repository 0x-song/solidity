// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract HashFunction {
    
    //为什么这里的return bytes32不需要加memory，因为bytes32是定长数组；不定长数组需要添加
    //默认基本类型，不需要刻意指定 存储类型；struct、动态数组、映射、string等引用类型必须指定存储类型，否则编译会报异常
    function hash1(string memory _text, uint _num, address _address) public pure returns (bytes32) {
        //使用hash运算用固定函数,计算之前将数据进行打包。可以有两种方式 abi.encodePacked  abi.encode
        return keccak256(abi.encodePacked(_text, _num, _address));
    }
    function hash2(string memory _text, uint _num, address _address) public pure returns (bytes32) {
        //使用hash运算用固定函数,计算之前将数据进行打包。可以有两种方式 abi.encodePacked  abi.encode
        return keccak256(abi.encode(_text, _num, _address));
    }
    //“AAA”,"AAAA":bytes: 0x00000000000000000000000000000000000000000000000000000000000000400000000000000
    //00000000000000000000000000000000000000000000000008000000000000000000000000000000000000
    //00000000000000000000000000009e2809c414141e2809d00000000000000000000000000000000000000000
    //0000000000000000000000000000000000000000000000000000000000000000000044141414100000000000
    //000000000000000000000000000000000000000000000
    function encode(string memory _text1, string memory _text2) external pure returns (bytes memory){
        return abi.encode(_text1, _text2);
    }

    //bytes: 0xe2809c414141e2809d41414141
    function encodePacked(string memory _text1, string memory _text2) external pure returns (bytes memory){
        return abi.encodePacked(_text1, _text2);
    }

}