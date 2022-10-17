// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract IterableMapping {
    //存储账号和金额的映射
    mapping (address => uint)  balances;
    //存储账号是否存储过
    mapping (address => bool)  inserted;
    //存储所有的key值
    address[]  keys;

    function deposit(uint _value) external{
        setBalance(msg.sender, _value);
    }

    function setBalance(address _key, uint _value) public{
        balances[_key] = _value;
        if(!inserted[_key]){
            inserted[_key] = true;
            keys.push(_key);
        }
    }

    function length() external view returns (uint){
        return keys.length;
    }

    function first() external view returns (uint){
        return balances[keys[0]];
    }

    function last() external view returns (uint){
        return balances[keys[keys.length - 1]];
    }

    function get(uint _index) external view returns (uint){
        require(_index <= keys.length - 1, "index out of bounds");
        return balances[keys[_index]];
    }

}