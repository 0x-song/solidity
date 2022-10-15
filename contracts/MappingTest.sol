// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;
contract MappingTest {

    mapping (uint => address) public numbers;

    mapping (uint => uint) public intPairs;
    
    mapping (address => uint) public balances;

    mapping (address => mapping (address => bool)) public isFriends;

    function examples() external {
        //给映射进行赋值操作
        balances[msg.sender] = 123;
        uint balance1 = balances[msg.sender];
        //Explicit conversions to and from address are allowed for uint160, integer literals, bytes20 and contract types.
        uint balance2 = balances[address(1)];

        balances[msg.sender] += 123;
        //delete操作也不是真正的删除，而是重置
        delete balances[msg.sender];

        isFriends[msg.sender][address(this)] = true;
        //映射必须是storage类型
        mapping (address => bool) storage friendsInfo = isFriends[msg.sender];
        // 返回的结果是true
        bool result = friendsInfo[address(this)];
        //返回结果是false
        bool result2 = friendsInfo[address(1)];
        //testMap(balances);
    }

    //Data location must be "memory" or "calldata" for parameter in function, but none was given.
    //但是mapping不可以设置memory或者calldata
    // function testMap(mapping (address => uint) bals) public{
    //     uint bal = bals[msg.sender];
    // }
}