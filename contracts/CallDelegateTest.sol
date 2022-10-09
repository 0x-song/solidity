// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
//合约被调用者
contract Called{
    uint public number;
    address public sender;

    function setN(uint n) public{
        number = n;
        sender = msg.sender;
    }

    event logdata(uint x);

    receive() external payable{
        emit logdata(msg.value);
    }

    fallback() external{}

    function getBalance() public view returns (uint){
        return address(this).balance;
    }
}

//合约调用者 注意：caller和called合约调用者和被调用者的变量名称应该完全一致
contract Caller{
    uint public number;
    address public sender;

    function delegateCallN(address e, uint n) public{
        bytes memory methodData = abi.encodeWithSignature("setN(uint256)", n);
        e.delegatecall(methodData);
    }

    function callN(address e, uint n) public{
        bytes memory methodData = abi.encodeWithSignature("setN(uint256)", n);
        //不晓得为啥加上gas设置之后，就没法调用了;原因是gas不足，无法调用
        e.call{gas:300000}(methodData);
        //e.call(methodData);
    }
}