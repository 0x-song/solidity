// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import {HashFunction as Hash1} from "./HashFunction.sol";
import {Address} from'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol';
contract A {
   
   Hash1 hash = new Hash1();


   function importDemo1(string memory _text, uint _num, address _address) external view returns (bytes32){
        return hash.hash1(_text, _num, _address);
   }

   function importDemo2(address _address) external view returns (bool){
      return Address.isContract(_address);
   }
}