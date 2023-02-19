pragma solidity ^0.8.0;

contract CoinFlipper{

    modifier onlyOwner{     //коллекция reqerements
        require(msg.sender == owner);
        _;
    }

    address owner; //состояния
    //uint8 0 => orel
    //event to track result of coin flip
    event CoinFlipper(address player, bool result);
    
    //payable = user может заплатить в бнб(гл монета)
    constructor() payable {
        owner = msg.sender;
    }

    //function that ask for 0 or 1 ...
    function coinFlip(uint8 _option) public payable returns (bool) {//view, pure = gassles
        require(_option<2, "select head or tail"); 
        require(msg.value>0, "add your bet"); //WEI
        require(msg.value*2 <= address(this).balance, "contact-balance is insuffient");

        //pseudoRandom and check with _option
        bool result = block.timestamp*block.gaslimit%2 == _option;
        //TODO add oracle: vrf/v2/introduction

        emit CoinFlipper(msg.sender, result);
        if(result){
            payable(msg.sender).transfer(msg.value*2);
            return true;
        }
        //if user lose? he lose
        return false;
    }
    //owner can withdraw
    function withdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}


