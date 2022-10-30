// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

interface ICounter {
    
    function count() external view returns (uint);

    function increase() external;
}
//合约部署时，不是CounterImpl和CallInterface即可，接口无法进行部署
contract CounterImpl{
    uint public number;

    function count() external view returns (uint){
        return number;
    }
    //该方法和接口中的方法同名，因为调用时需要保证方法名称相同 
    function increase() external{
        number ++;
    }
    //当前方法再接口中没有，不过也不会影响最终合约的正常运行
    function decrease() external{
        number --;
    }
}

contract CallInterface {
   
   function call1(address _address) external{
        ICounter(_address).increase();
        ICounter(_address).count();
   } 
}