// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract StructTest{
    struct Car {
        string name;
        uint year;
        address owner;
    }

    //定义一个结构体的状态变量
    Car public car;
    Car[] public cars;

    function examples() external{
        //声明结构体的几种方式
        Car memory toyota = Car("Toyota", 2000, msg.sender);
        Car memory bmw = Car({name: "BMW", year: 2022, owner: msg.sender});
        Car memory tesla;
        tesla.name = "Tesla";
        tesla.year = 2021;
        tesla.owner = msg.sender;

        //将结构体装入到数组中
        cars.push(toyota);
        cars.push(bmw);
        cars.push(tesla);

        //再单独添加一个新的结构体数据
        cars.push(Car({name: "ferrari", owner: msg.sender, year: 2009}));

        //状态变量赋值给本地memory变量，不会影响状态变量的值
        Car memory _car = cars[0];
        _car.name = "Benz";
        _car.year = 1999;

        //原本是bmw，修改之后应该是马自达 
        //但是同时也发现一个问题，如果使用中文，会有错误的，针对unicode编码的字符需要额外进行处理
        Car storage _car2 = cars[1];
        _car2.name = "mzd";
        _car2.year = 2022;
    }
}