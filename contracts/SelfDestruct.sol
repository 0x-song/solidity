// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract KillSelf{

    constructor() payable{}

    function kill() external {
        selfdestruct(payable(msg.sender));
    }

    function getNumber() external pure returns (uint){
        return 123;
    }
}
contract HelperContract{

    function destroy(KillSelf _kill) external{
        _kill.kill();
    }

    function getBalance() external view returns (uint){
        return address(this).balance;
    }
}
