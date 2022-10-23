// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract Payable {
    //标注了payable，就表示其可以接收以太坊主币
    function deposit() external payable{
    }

    function getBalance() external view returns (uint){
        return address(this).balance;
    }
}