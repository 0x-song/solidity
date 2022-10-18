// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract TodoList {
    struct Todo {
        string text;
        bool isCompleted;
    }

    Todo[] public todos;

    function create(string calldata _text) external {
        todos.push(Todo({
            text: _text,
            isCompleted: false
        }));
    }

    function updateText(uint _index, string calldata _text) external {
        todos[_index].text = _text;
        //下面还有一种方式，适合需要修改的变量属性非常多的时候
        //将索引_index下标的数据取出来，放到storage位置，然后再去修改
        Todo storage todo = todos[_index];
        todo.text = _text;
    }

    function get(uint _index) external view returns (string memory, bool){
        Todo memory todo = todos[_index];
        return (todo.text, todo.isCompleted);
    }

    function toggleCompleted(uint _index) external{
        todos[_index].isCompleted = !todos[_index].isCompleted;
    }
}