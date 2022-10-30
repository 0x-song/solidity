// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
error executeFailed(string _message);
contract A {
    uint public x;
    string public message;

    event Log(string _message);

    receive() external payable{}

    // fallback() external payable {
    //     emit Log("fallback executed");
    // }

    function m1(string memory _message, uint _x) external payable returns (bool, uint){
        x = _x;
        message = _message;
        return (true, 10086);
    }
}

contract B {

    bytes public data;

    function call1(address _addr) external payable{
        //特别注意，此处uint必须要写成uint256类型
       (bool result, bytes memory _data) = _addr.call{value:1234,gas:100000}(abi.encodeWithSignature("m1(string,uint256)", "hello call", 1234));
        if(!result){
            revert executeFailed("call failed");
        }
        // require(result, "call failed");
        data = _data;
    }

    function callNonExist(address _addr) external {
       (bool result, ) =  _addr.call(abi.encodeWithSignature("nonExist()"));
       if(!result){
        revert executeFailed("call none exist function");
       }
        require(result, "call non-exists function");
    }
}