// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract StorageTest {
    //状态变量的存储位置是storage
    string public text;

    //参数的变量一般设置为calldata类型；external表示是对于智能合约外部是可见的，但是内部无法调用
    function set(string calldata _text) external{
        text = _text;
    }

    //view表示和智能合约交互只有查询操作；pure表示既不存储，也不修改
    function get() external view returns (string memory){
        return text;
    }
}