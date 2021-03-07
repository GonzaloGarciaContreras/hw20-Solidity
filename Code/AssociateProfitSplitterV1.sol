pragma solidity ^0.5.0;

// lvl 1: equal split

contract AssociateProfitSplitter {
    
    address human_resources;
    
    // @TODO: Create three payable addresses representing `employee_one`, `employee_two` and `employee_three`.
    address payable public employee_one;
    address payable public employee_two;
    address payable public employee_three;

    constructor(address payable _one, address payable _two, address payable _three) public {
        human_resources = msg.sender;
        employee_one = _one;
        employee_two = _two;
        employee_three = _three;
    }


    function balance() public view returns(uint) {
        return address(this).balance;
    }
    
    address public lastToDeposit;     
    uint public lastDepositBlock;
    uint public lastDepositAmount;

    function deposit() public payable {
        // @TODO: Split `msg.value` into three
        uint amount = msg.value / 3; // Your code here!

        // @TODO: Transfer the amount to each employee
        employee_one.transfer(amount);
        employee_two.transfer(amount);
        employee_three.transfer(amount);

        // @TODO: take care of a potential remainder by sending back to HR (`msg.sender`)        
        msg.sender.transfer(msg.value - amount * 3);

        lastToDeposit = msg.sender;
        lastDepositAmount = msg.value;    
        lastDepositBlock = block.number;
    }

    function() external payable {
        // @TODO: Enforce that the `deposit` function is called in the fallback function!
        deposit();
    }
}
