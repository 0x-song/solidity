// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract Array5{
    
    uint[] public numbers;

    function remove1(uint index) public{
        uint length = numbers.length;
        if(index == length - 1){
            numbers.pop();
        }else {
            numbers[index] = numbers[length - 1];
            numbers.pop();
        }
    }
 
    function test1() external{
        numbers = [1,2,3,4,5];
        remove1(2);
        // [1,2,5,4]
        assert(numbers.length == 4);
        assert(numbers[0] == 1);
        assert(numbers[1] == 2);
        assert(numbers[2] == 5);
        assert(numbers[3] == 4);
    }

}