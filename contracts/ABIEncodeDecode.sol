// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract ABIEncodeAndDecode {
    struct Car {
        string name;
        uint[] nums;
    }
    //abi.encode可以使用abi.decode来进行解码
    function encode(uint _a, address _b, uint[] calldata _c, Car calldata _d) external pure returns (bytes memory){
        return abi.encode(_a, _b, _c, _d);
    }
    
    //Furthermore, structs as well as nested arrays are not supported.不支持struct
    function encodePacked(uint _a, address _b, uint[] calldata _c) external pure returns (bytes memory){
        return abi.encodePacked(_a, _b, _c);
    }

    function decode(bytes calldata data) external pure returns (uint _a, address _b, uint[] memory _c, Car memory _d){
        (_a, _b, _c, _d) = abi.decode(data, (uint, address, uint[], Car));
    }
}