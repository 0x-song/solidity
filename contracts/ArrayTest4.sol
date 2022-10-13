// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract Array4{
    
    uint[] public numbers;


    /**
     * 删除数组中间某个元素时，不可以像其他编程语言一样，删除该元素，其他后面的元素往前移动
     * 这样会消耗巨量的gas
     * 删除数组两种方式：
     * 1.像上述提及的一样，比如[1,2,3,4,5,6] -----remove(2)下标-----[1,2,4,5,6,6]---pop---[1,2,4,5,6]
     * 2.还有另外一种方式：比如[1,2,3,4,5,6] -----remove(2)下标,最后一个元素赋值给需要删除的元素 [1,2,6,4,5,6]--pop---[1,2,6,4,5]
     * 下面这种方式更加节省gas费，但是如果需要保障数组的顺序，那么只能使用方式1
     */
    function remove1(uint index) public{
        uint length = numbers.length;
        if(index == length - 1){
            numbers.pop();
        }else {
            numbers[index] = numbers[length - 1];
            numbers.pop();
        }
    }
 
    /**
     * [1,2,3,4]  remove index 2
     */
    function remove2(uint index) public{
        uint length = numbers.length;
        if(index  == length - 1){
            numbers.pop();
        }else {
            for (uint i = index; i < length - 1; i++) {
                numbers[i] = numbers[i + 1];
            }
            numbers.pop();
        }
    }

    function test1() external{
        numbers = [1,2,3,4,5];
        remove1(2);
        // [1,2,4,5]
        assert(numbers.length == 4);
        assert(numbers[0] == 1);
        assert(numbers[1] == 2);
        assert(numbers[2] == 5);
        assert(numbers[3] == 4);
    }

    function test2() external{
        numbers = [1,2,3,4,5];
        remove2(2);
        // [1,2,4,5]
        // assert(numbers.length == 4);
        // assert(numbers[0] == 1);
        // assert(numbers[1] == 2);
        // assert(numbers[2] == 5);
        // assert(numbers[3] == 4);
    }
    
}