// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract Pair {

    address public factory;

    address public token1;

    address public token2;

    constructor() {
        factory = msg.sender;
    }

    function initialize(address _token1, address _token2) external {
        token1 = _token1;
        token2 = _token2;
    }
}

contract PairFactory2{

    mapping (address => mapping (address => address)) public tokenPair;

    //保存所有的合约地址信息
    address[] public tokenPairs;

    function createPair2(address _token1, address _token2) external returns (address pairAddress){
        require(_token1 != _token2, "could not create same token pair");
        //这一步为了保证输入不同的地址对得到的顺序是一致的，后面要进行哈希运算
        (address token1, address token2) = _token1 < _token2 ? (_token1, _token2) : (_token2, _token1);
        bytes32 salt = keccak256(abi.encodePacked(token1, token2));
        //使用create2创建新的合约 salt是bytes32位的
        Pair pair = new Pair{salt : salt}();
        pair.initialize(token1, token2);
        pairAddress = address(pair);
        tokenPairs.push(pairAddress);
        tokenPair[token1][token2] = pairAddress;
        tokenPair[token2][token1]  = pairAddress;
    }

    function calculateAddress(address _token1, address _token2) public view returns (address predicatedAddress){
        require(_token1 != _token2, "could not create same token pair");
        //这一步为了保证输入不同的地址对得到的顺序是一致的，后面要进行哈希运算
        (address token1, address token2) = _token1 < _token2 ? (_token1, _token2) : (_token2, _token1);
        bytes32 salt = keccak256(abi.encodePacked(token1, token2));
        //需要四个参数：0xff、当前创建者合约地址、盐、bytecode
        bytes32 hashcode = keccak256(abi.encodePacked(bytes1(0xff), address(this), salt, keccak256(type(Pair).creationCode)));
        predicatedAddress = address(uint160(uint(hashcode)));
    }
}