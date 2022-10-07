// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract TestAddress{
    function testTransfer(address payable x) public{
        //任何一个合约都可以显式的转换成address类型
        address myaddress = address(this);
        if(myaddress.balance >= 10){
            //如果x是一个合约地址，那么当transfer发生时，合约的receive或者fallback函数会随着transfer一起调用
            x.transfer(10);
        }
    }
}