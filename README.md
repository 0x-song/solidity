# solidity

## 基础语法

- pragma：版本标识指令。用来启动某些编译器检查。比如pragma solidity ^0.8.0;表示当前合约只可以被主版本是0.8的编译器进行编译。又比如pragma solidity >= 0.7.0 < 0.9.0;表示当前合约可以被主版本大于等于0.7，小于0.9的编译器进行编译。

- 值类型

  - bool：布尔类型。取值是true或者false

  - int/unint：表示无符号或者有符号的整数类型。uint8~uint256以及int8~int256。以8位步长递增。uint、int分别代表的是uinit256以及int256。下面的案例就是越界了。

    ```solidity
    
    // SPDX-License-Identifier: SEE LICENSE IN LICENSE
    pragma solidity ^0.8.0;
    contract OverFlow{
        function add1() public pure returns (uint8){
            uint8 x = 127;
            uint8 y = x * 2;
            return y;
        }
    
        function add2() public pure returns (uint8){
            uint8 x = 240;
            uint8 y = 16;
            uint8 z = x + y;
        }
    }
    ```

  - address：地址类型来表示一个账号，地址类型有两种。address：一个20个字节的值。address payable:表示可支付地址，与address相同也是20字节。不过有其自身的成员函数transfer和send。**transfer执行失败会出异常，但是send执行失败会返回false，不会出异常。**

    > \<address>.balance(uint256)   以Wei为单位的地址类型的余额
    >
    > \<address payable>.transfer(uint256 amount) 向地址类型address发送amount数量的Wei，失败时抛出异常。
    >
    > \<address payable>.send(uint256 amount) returns (bool) 向地址address发送amount数量的Wei，失败时返回false。

    ```solidity
    // SPDX-License-Identifier: SEE LICENSE IN LICENSE
    pragma solidity ^0.8.0;
    contract TestAddress{
        function testTransfer(address payable x) public{
            //任何一个合约都可以显式的转换成address类型
            address myaddress = address(this);
            if(myaddress.balance >= 10){
                //如果x是一个合约地址，那么当transfer发生时，合约的receive或者fallback函数会随着transfer一起调用
                x.transfer(10);
            }
        }
    }
    ```

    如下代码所示，每new一次合约，便会创建一个新的合约。

    ```solidity
    // SPDX-License-Identifier: SEE LICENSE IN LICENSE
    pragma solidity ^0.8.0;
    contract A{
    
        function callMethod() public returns (uint){
            //这里发生了什么？为什么会获取不到结果？
            //每调用一次new，那么链上肯定会生成一个新的合约，在internal txns中可以看到
            B b = new B();
            return b.say();
        }
    }
    
    contract B{
    
        function say() public pure returns (uint){
            return 10;
        }
    }
    ```

    ![image-20221008085359038](README.assets/image-20221008085359038.png)

    如果希望调用B合约的say方法，可以使用如下方式来进行：

    ```solidity
    // SPDX-License-Identifier: SEE LICENSE IN LICENSE
    pragma solidity ^0.8.0;
    contract A{
    
        function callMethod(B b) public returns (uint){
            return b.say();
        }
    }
    
    
    contract B{
    
        function say() public pure returns (uint){
            return 10;
        }
    }
    ```

    地址类型还有几个比较偏向于底层的成员变量，类似于java的反射。这部分没有理解，后续需要进一步学习。

    > call
    >
    > Delegatecall
    >
    > Staticcall

    下面这个案例其实就是transfer和call之间的区别。

    transfer在进行转账时，可能会失败，因为gas问题

    而使用call没有这个问题

    ```solidity
    // SPDX-License-Identifier: SEE LICENSE IN LICENSE
    pragma solidity ^0.8.0;
    
    contract Address1{
    
        uint total;
    
        event logdata(uint x);
    
        receive() external payable{
            emit logdata(msg.value);
            total += msg.value;
        }
    
        function getBalance() public view returns (uint){
            return address(this).balance;
        }
    }
    
    contract Call1{
    
        //address owner;
    
        constructor() payable{
            //owner = msg.sender;
            //这行代码可以在部署时，由外部合约控制账号给合约初始化一定的ether
            msg.value;
        }
    
        //至于如何在合约中存储合约控制者的外部账号，暂不清楚
        // function getOwner() public returns (address){
        //     return owner;
        // }
    
        //这个方法再当前合约给其他地址进行转账时，会失败，因为该方法的固定的gas设置为2300
        //而调用transfer方法时，接收地址会调用receive或者fallback方法等，这些也需要gas
        function transferEther(address toAddress) public returns (bool){
            payable(toAddress).transfer(0.01 ether);
            return true;
        }
    
        function transferEtherViaCall(address toAddress) public{
            (bool success, ) = toAddress.call{value: 0.01 ether}("");
            require(success, "transfer ether failed");
        }
    
        // function transfertoContract() payable public{
        //     payable(address(this)).transfer(10 ether);
        // }
    }
    ```

    call和delegatecall之间的区别

    **call会切换上下文，但是delegatecall不会**

    ![image-20221009193956204](README.assets/image-20221009193956204.png)

    ![image-20221009194118936](README.assets/image-20221009194118936.png)

    ```solidity
    // SPDX-License-Identifier: SEE LICENSE IN LICENSE
    pragma solidity ^0.8.0;
    //合约被调用者
    contract Called{
        uint public number;
        address public sender;
    
        function setN(uint n) public{
            number = n;
            sender = msg.sender;
        }
    
        event logdata(uint x);
    
        receive() external payable{
            emit logdata(msg.value);
        }
    
        fallback() external{}
    
        function getBalance() public view returns (uint){
            return address(this).balance;
        }
    }
    
    //合约调用者 注意：caller和called合约调用者和被调用者的变量名称应该完全一致
    contract Caller{
        uint public number;
        address public sender;
    
        function delegateCallN(address e, uint n) public{
            bytes memory methodData = abi.encodeWithSignature("setN(uint256)", n);
            e.delegatecall(methodData);
        }
    
        function callN(address e, uint n) public{
            bytes memory methodData = abi.encodeWithSignature("setN(uint256)", n);
            //不晓得为啥加上gas设置之后，就没法调用了;原因是gas不足，无法调用
            e.call{gas:300000}(methodData);
            //e.call(methodData);
        }
    }
    ```

    Caller是合约的调用者；Called是合约的被调用者

    在Caller中我们定义了两个方法，一个是call方法，一个是delegatecall方法。

    ![image-20221009222656401](README.assets/image-20221009222656401.png)

    **如果函数的运行导致变量值发生修改，那么改变的也是最终被调用者Called身上。**

    ![image-20221009222954231](README.assets/image-20221009222954231.png)

    ![image-20221009223017671](README.assets/image-20221009223017671.png)

    **如果函数的运行导致变量值发生修改，那么改变的是Caller合约调用者里面的变量。**

    ![image-20221009223312693](README.assets/image-20221009223312693.png)