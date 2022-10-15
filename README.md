# solidity

## 基础语法

###  pragma

版本标识指令。用来启动某些编译器检查。比如pragma solidity ^0.8.0;表示当前合约只可以被主版本是0.8的编译器进行编译。又比如pragma solidity >= 0.7.0 < 0.9.0;表示当前合约可以被主版本大于等于0.7，小于0.9的编译器进行编译。

###  值类型

#### bool

布尔类型。取值是true或者false

#### int/uint

表示无符号或者有符号的整数类型。uint8~uint256以及int8~int256。以8位步长递增。uint、int分别代表的是uinit256以及int256。下面的案例就是越界了。

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

#### address

地址类型来表示一个账号，地址类型有两种。address：一个20个字节的值。address payable:表示可支付地址，与address相同也是20字节。不过有其自身的成员函数transfer和send。**transfer执行失败会出异常，但是send执行失败会返回false，不会出异常。**

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

### 引用类型

值类型在赋值存储时总是完整存储完整的拷贝。而对于一些复杂的数据类型占用的空间会比较大，开销会很大。因此就可以使用引用的方式。通过不同的名称的变量指向同一个值。引用类型有数组、结构体、映射。

####  引用类型的存储位置 

引用类型都有一个额外的属性来标识数据的存储位置（使用引用类型必须明确地提供存储该类型的数据位置）：

**memory**：内存。生命周期只存在于函数调用期间(生存期位于function()函数内，超过作用域失效)。

**storage**：存储。状态变量保存的位置。开销最大(生存期同contract一致，状态变量强制为storage)。

**calldata**：调用数据。用于函数参数不可变存储区域(存储在内存中，不上链。但是和memory不同的是calldata变量不可以修改，类似于final、immutable等，一般用于函数的参数)。

```solidity
function callData1(uint[] calldata _x) public pure returns (uint[] calldata) {
        //calldata类型的变量不可以被修改
        //calldata arrays are read-only
        //_x[0] = 1;
        return _x;
    }
```

#### 不同存储位置赋值规则

不同存储类型的数据在进行相互赋值时，有时候会产生独立的副本（也就是修改新变量的值不会影响原先变量的值），有时候会产生相互引用（修改新变量会影响原先变量的值）

**合约的状态变量(storage)赋值给本地函数里的storage时，会创建引用，改变新变量会影响原先变量。**

```solidity
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract DataStorage {

    uint[] x  = [1,2,3];
    
    function callData1(uint[] calldata _x) public pure returns (uint[] calldata) {
        //calldata类型的变量不可以被修改
        //calldata arrays are read-only
        //_x[0] = 1;
        return _x;
    }

    function storage1() public{
        uint[] storage xs = x;
        xs[0] = 100;
    }
}
```

![image-20221011001101675](README.assets/image-20221011001101675.png)

**合约的状态变量(storage)赋值给memory，会创建独立的副本，修改其中一个不会对另外一个产生影响。**

```solidity
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract DataStorage {

    uint[] x  = [1,2,3];
    
    function callData1(uint[] calldata _x) public pure returns (uint[] calldata) {
        //calldata类型的变量不可以被修改
        //calldata arrays are read-only
        //_x[0] = 1;
        return _x;
    }

    function storage1() public{
        uint[] storage xs = x;
        xs[0] = 100;
    }

    function memory1() public{
        uint[] memory xm = x;
        xm[0] = 100;
        xm[1] = 200;
        x[0] = 400;
    }

}
```

![image-20221011212314964](README.assets/image-20221011212314964.png)

**memory赋值给memory，会创建引用。改变新变量时会修改原变量的值**。

```solidity
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract DataStorage {


    uint[] x  = [1,2,3];
    
    function callData1(uint[] calldata _x) public pure returns (uint[] calldata) {
        //calldata类型的变量不可以被修改
        //calldata arrays are read-only
        //_x[0] = 1;
        return _x;
    }

    function storage1() public{
        uint[] storage xs = x;
        xs[0] = 100;
    }

    function memory1() public{
        //storage赋值给memory
        uint[] memory xm = x;
        xm[0] = 100;
        xm[1] = 200;
        x[0] = 400;
    }

    function memory2() public{
        //memory类型的变量赋值给memory，会创建引用，修改一个，另外一个也会随之修改
        //创建memory的数组，需要使用如下方式
        //但是目前依然有困惑：为什么不可以使用uint[] memory xm1 = [1,2,3,4]...
        //原因在于声明数组时必须指定数组的长度。uint[4] memory xm1 = [1,2,3,4]
        uint[] memory xm1 = new uint[](7);
        xm1[0] = 1;
        xm1[1] = 2;
        xm1[2] = 3;
        xm1[3] = 4;
        xm1[4] = 4;
        xm1[5] = 5;
        xm1[6] = 6;
        uint[] memory xm2 = xm1;
        xm2[0] = 7;
    }
}
```

![image-20221011223701870](README.assets/image-20221011223701870.png)

#### 不同变量的作用域

##### 状态变量

**状态变量**：数据会存储在链上，gas消耗比较大 。类似于其他编程语言的成员变量。

```solidity
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract DataStorage {
		//状态变量
    uint[] x  = [1,2,3];

    function storage1() public{
        uint[] storage xs = x;
        xs[0] = 100;
    }


```

##### 局部变量

**局部变量**：仅在函数执行过程中有效。函数退出之后，变量无效。局部变量仅存储在内存中，不上链，gas消耗低。上图的函数内部。

##### 全局变量

**全局变量**：可以在全局内使用的变量。无需进行声明。

> `blockhash(uint blockNumber) returns (bytes32)`: 指定区块的区块哈希,仅可用于最新的 256 个区块且不包括当前区块，否则返回 0 
>
> `block.basefee` (`uint`): 当前区块的基础费用 ([EIP-3198](https://eips.ethereum.org/EIPS/eip-3198) and [EIP-1559](https://eips.ethereum.org/EIPS/eip-1559))
>
> `block.chainid` (`uint`): 当前链 id
>
> `block.coinbase` (`address payable`): 挖出当前区块的矿工地址
>
> `block.difficulty` (`uint`): 当前区块难度
>
> `block.gaslimit` (`uint`): 当前区块 gas 限额
>
> `block.number` (`uint`): 当前区块号
>
> `block.timestamp` (`uint`): 自unix epoch 起始当前区块以秒计的时间戳
>
> `gasleft() returns (uint256)`: 剩余的gas
>
> `msg.data` (`bytes calldata`): 完整的calldata
>
> `msg.sender` (`address`): 消息发送者(当前调用者)
>
> `msg.sig` (`bytes4`): calldata的前4字节(也就是函数标识符）
>
> `msg.value` (`uint`): 随消息发送的wei的数量
>
> `tx.gasprice` (`uint`):交易的 gas 价格
>
> `tx.origin` (`address`): 交易发起者(完全的调用链)
>
> `keccak256((bytes memory) returns (bytes32)`:计算 Keccak-256 哈希

针对keccak256，引入一个案例，顺便学习solidity中字符串的操作。

```solidity
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;
contract Cryptograph {
    
    function keccakMethod(string memory name) public returns (bytes32){
        bytes memory b1 = bytes(name);
        bytes32 result = keccak256(b1);
        return result;
    }
}
```

#### 引用类型分类

##### 数组 

可以用来存储一组数据。可以分为定长数组以及不定长数组。

**定长数组** ：在声明时就指定数组的长度，T[k]这种格式来表示

**不定长数组(动态数组)**：在声明时不指定数组的长度，T[]这种格式来表示

```solidity
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract Array1{
    //定长数组
    uint[8] arr1;
    bytes1[6] arr2;
    address[3] arr3;

    //不定长数组
    uint[] arr4;
    bytes1[] arr5;
    address[] arr6;
    //bytes类型比较特殊，表示数组
    bytes arr7;
}
```

> 注：关于bytes，是一种特殊类型的数组。类似于byte[]，但是bytes的gas费用更低。bytes和string都可以用来表示字符串，对任意长度的原始字节数据使用bytes，对于任意长度的字符串，比如使用Unicode编码的字符，使用string

**成员**

​	**1.length:表示的是当前数组的长度**

​	**2.push():只有动态数组（不定长数组）和 bytes数组拥有该成员，在末尾添加0**

​	**3.push(x):只有动态数组（不定长数组）和bytes数组拥有该成员，在末尾添加x**

```solidity
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract Array1{
    //定长数组
    uint[8] arr1;
    bytes1[6] arr2;
    address[3] arr3;

    //不定长数组
    uint[] arr4;
    bytes1[] arr5;
    address[] arr6;
    //bytes类型比较特殊，表示数组
    bytes arr7;

    function testArray() public {
        //对于固定长度的数组会直接初始化数组，默认值全部为0；无法调用push方法
        //arr1.push();
        //只有不定长数组，也就是动态数组可以调用push方法；动态数组初始化时长度为0，无填充
        arr4.push();
        arr4.push(1);
        arr4.push(2);
        arr4.push(3);
        arr4.push(4);
        arr4.push(5);
    }
}
```

​	**4.pop():只有动态数组（不定长数组）和bytes数组拥有该成员，移除数组最后一个元素**。**思考：为什么只提供移除数组最后一个元素的方法，而没有提供移除其他元素的方法呢？**

**解决了一个数组越界提示非常模糊的bug。**

```solidity
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
```

**创建数组的规则**

​	**1.对于memory修饰的不定长数组，可以使用new操作符来创建，但是创建之后长度不能改变；对于memory修饰的固定长度数组，直接赋值即可。**

```solidity
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract Array2{
    //数组的创建规则
    function memoryArray() public{
    		//创建内存数组的两种形式，但是目前遇到了下图的疑问，暂未解决
        uint[] memory arr1 = new uint[](3);
        arr1[0] = 1;
        arr1[1] = 3;
        arr1[2] = 5;

        uint[4] memory arr2 = [uint(1),5,7,9];

        string[2] memory arr3 = ["hello", "solidity"];

        //uint a = 1;
    }   
}
```

![image-20221012215723924](README.assets/image-20221012215723924.png)

![image-20221012215839284](README.assets/image-20221012215839284.png)

​	**2.数组字面常数，是用中括号来初始化数组的一种方式。数组里面的每一个元素的值是以第一个元素的值为基准的，比如[1,2,3]，该数组里面的所有的元素都会被认为是uint8类型的，如果使用uint[]来接收(uint默认256),就会出现错误。解决办法也很简单，[uint(1),2,3]这样就解决了问题。这也是上述案例写法的原因。**

​	**3.创建的如果是不定长数组，需要一个一个进行赋值。和其他编程语言一致。**

##### 结构体

用 struct关键字定义一个就结构体，和类比较相似 。

结构体赋值见下面几种方式

```solidity
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
        //声明赋值结构体的几种方式
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
        Car storage _car2 = cars[1];
        _car2.name = "mzd";
        _car2.year = 2022;
    }
}
```

在上述代码中 ，我们修改了cars[0]，但是状态变量中是没有发生修改的；但是我们修改cars[1]，状态变量是会发生修改的。

![image-20221014083825897](README.assets/image-20221014083825897.png)

![image-20221014085228677](README.assets/image-20221014085228677.png)

### 映射

通过key去查询value值。对于学过编程语言的同学来说，应该理解不难。

**映射的规则**：

- 映射的key值只可以是solidity规定的默认数据类型。不可以设置结构体。
- 映射的存储位置必须设置为storage，映射可以作为合约的状态变量，函数内的storage变量。不能用作public函数的参数或者返回值。
- 映射不存储key的信息，也不会有length的信息。

```solidity
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;
contract MappingTest {

    mapping (uint => address) public numbers;

    mapping (uint => uint) public intPairs;
    
    mapping (address => uint) public balances;

    mapping (address => mapping (address => bool)) public isFriends;

    function examples() external {
        //给映射进行赋值操作
        balances[msg.sender] = 123;
        uint balance1 = balances[msg.sender];
        //Explicit conversions to and from address are allowed for uint160, integer literals, bytes20 and contract types.
        uint balance2 = balances[address(1)];

        balances[msg.sender] += 123;
        //delete操作也不是真正的删除，而是重置
        delete balances[msg.sender];

        isFriends[msg.sender][address(this)] = true;
        //映射必须是storage类型
        mapping (address => bool) storage friendsInfo = isFriends[msg.sender];
        // 返回的结果是true
        bool result = friendsInfo[address(this)];
        //返回结果是false
        bool result2 = friendsInfo[address(1)];
        //testMap(balances);
    }

    //Data location must be "memory" or "calldata" for parameter in function, but none was given.
    //但是mapping不可以设置memory或者calldata
    // function testMap(mapping (address => uint) bals) public{
    //     uint bal = bals[msg.sender];
    // }
}
```

