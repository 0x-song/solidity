// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract ABIEncode2 {

    //abi.encode可以使用abi.decode来进行解码
    function encode(uint _a, address _b, uint[] calldata _c) external pure returns (bytes memory){
        return abi.encode(_a, _b, _c);
    }
    
    function encodeWithSignature(uint _a, address _b, uint[] calldata _c) external pure returns (bytes memory){
        return abi.encodeWithSignature("encode(uint256,address,uint256[])", _a, _b, _c);
    }

    function encodeWithSelector(uint _a, address _b, uint[] calldata _c) external pure returns (bytes memory){
        return abi.encodeWithSelector(bytes4(keccak256("encode(uint256,address,uint256[])")), _a, _b, _c);
    }
}