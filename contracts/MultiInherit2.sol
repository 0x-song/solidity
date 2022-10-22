// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
contract W {
    event Log(string message);

    function foo() virtual  public returns (string memory){
        emit Log("W.foo");
        return "wf";
    }
}
contract X is W{
    function foo() virtual override  public returns (string  memory){
        emit Log("X.foo");
        super.foo();
        return "xf";
    }
}
contract Y is W{
    function foo() virtual override public returns (string  memory){
        emit Log("Y.foo");
        super.foo();
        return "yf";
    }
}
contract Z is X, Y{

    string public text;

    function foo() override(X,Y) public returns (string memory){
        emit Log("Z.foo");
        text  = super.foo();
        return text;
        //return "zf";
    }
}
