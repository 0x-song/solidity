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
        require(msg.sender == factory, "failed");
        token1 = _token1;
        token2 = _token2;
    }
}
contract PairFactory{

    mapping (address => mapping (address => address)) public tokenPair;

    address[] public allPairs;

    //创建币对合约
    function createContract(address _token1, address _token2)external {
        Pair pair = new Pair();
        pair.initialize(_token1, _token2);
        address pairAddress = address(pair);
        allPairs.push(pairAddress);
        tokenPair[_token1][_token2] = pairAddress;
        tokenPair[_token2][_token1] = pairAddress;
    }

}