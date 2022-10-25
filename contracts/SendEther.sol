// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract SendEther {
    //部署的合约的时候，直接给合约传入主币
    constructor() payable{}

    //可以直接接收其他地址发送主币
    receive() external payable{}

    function transferEther(address payable _to) external payable {
        //发送2000wei，此处发送只会携带2300 gas;如果gas耗尽或者其他异常则会revert报出异常
        _to.transfer(2000);
    }

    function sendEther(address payable _to) external payable{
        //如果发送失败，不会revert，而是返回一个bool类型的值
        bool result = _to.send(2000);
        require(result, "send failed");
    }

    function callEther(address payable _to) external payable{
        //call方法执行返回两个值，一个bool类型的值，一个是比如调用智能合约等返回的其他类型的数据
       (bool result, bytes memory data) =  _to.call{value:2000}("");
       require(result, "call failed");
    }
}
//另外创建一个合约用来接收ether，接收到ether之后会调用receive函数
contract EtherReceive{
    event Log(uint amount, uint gas);

    receive() external payable{
        emit Log(msg.value, gasleft());
    }
}