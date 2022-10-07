
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract OverFlow{
    function add1() public pure returns (uint8){
        uint8 x = 127;
        uint8 y = x * 2;
        return y;
    }

    function add2() public pure returns (uint8){
        uint8 x = 240;
        uint8 y = 16;
        uint8 z = x + y;
    }
}