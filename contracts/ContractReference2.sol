// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract A{

    function callMethod(B b) public returns (uint){
        return b.say();
    }
}


contract B{

    function say() public pure returns (uint){
        return 10;
    }
}