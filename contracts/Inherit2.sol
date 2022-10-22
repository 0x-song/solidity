// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract Base {
    uint public x;

    constructor(uint _x){
        x = _x;
    }
}

contract Derived is Base{
    uint public y;

    constructor(uint _y) Base (_y * _y){
        y = _y;
    }
}
contract Derived2 is Base(8){
    
}