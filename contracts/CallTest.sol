// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract Address1{

    uint total;

    event logdata(uint x);

    receive() external payable{
        emit logdata(msg.value);
        total += msg.value;
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }
}

contract Call1{

    //address owner;

    constructor() payable{
        //owner = msg.sender;
        //这行代码可以在部署时，由外部合约控制账号给合约初始化一定的ether
        msg.value;
    }

    //至于如何在合约中存储合约控制者的外部账号，暂不清楚
    // function getOwner() public returns (address){
    //     return owner;
    // }

    //这个方法再当前合约给其他地址进行转账时，会失败，因为该方法的固定的gas设置为2300
    //而调用transfer方法时，接收地址会调用receive或者fallback方法等，这些也需要gas
    function transferEther(address toAddress) public returns (bool){
        payable(toAddress).transfer(0.01 ether);
        return true;
    }

    function transferEtherViaCall(address toAddress) public{
        (bool success, ) = toAddress.call{value: 0.01 ether}("");
        require(success, "transfer ether failed");
    }

    // function transfertoContract() payable public{
    //     payable(address(this)).transfer(10 ether);
    // }
}