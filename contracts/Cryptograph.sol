// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;
contract Cryptograph {
    
    function keccakMethod(string memory name) public returns (bytes32){
        bytes memory b1 = bytes(name);
        bytes32 result = keccak256(b1);
        return result;
    }
}