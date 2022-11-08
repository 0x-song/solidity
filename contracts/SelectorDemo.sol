// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract SelectDemo {
    
    event Log(bytes data);

    //当我们调用m1方法时，传递过去的完整参数会保存在msg.data全局变量中
    // 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    // input:0x0c7dff020000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4
    //  data:0x0c7dff020000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4
    //  selector:0x0c7dff02
    //  address:0x0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4
    function m1(address _address)external  {
        emit Log(msg.data);
    }

    //验证一下返回值是否是上面的selector 0x0c7dff02
    function m2() external pure returns (bytes4 sele){
        sele = bytes4(keccak256("m1(address)"));
    }
}