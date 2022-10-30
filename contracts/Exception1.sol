// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
error insufficientBalance(uint available, uint required);

contract ErrorException {
   
   function transfer(address _to, uint amount) external payable{
        if(amount > msg.value){
            revert insufficientBalance(msg.value, amount);
        }
   }
}