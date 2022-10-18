// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract EnumTest {
   enum Status{
        None,
        Pending,
        Shipped,
        Completed,
        Rejected,
        Canceled
   }

   Status public sta;

   function get() view external returns (Status){
        return sta;
   }

   function set(Status _sta) external{
        sta = _sta;
   } 
}