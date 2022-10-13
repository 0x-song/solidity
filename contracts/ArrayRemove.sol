// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract ArrayRemove{
    uint[] public numbers;

    function remove(uint index) public{
        uint length = numbers.length;
        if(index == length - 1){
            numbers.pop();
        }else {
            numbers[index] = numbers[length - 1];
            numbers.pop();
        }
    }

    function test1() external{
        numbers = [1,2,3,4];
        remove(1);
        assert(numbers.length == 3);
        assert(numbers[0] == 1);
        assert(numbers[1] == 4);
        assert(numbers[2] == 3);

        remove(2);
        assert(numbers.length == 2);
        assert(numbers[0] == 1);
        assert(numbers[1] == 4);
    }
}