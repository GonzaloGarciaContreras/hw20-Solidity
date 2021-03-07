pragma solidity ^0.5.0;

// Deploy
// Environment --> compile using Injected Web3 and give permitions to the accounts that access the contract 3 and 5 
// Account --> when deploying use one of the two authorized account in this case I've took account 3 
// Gas limit --> default
// value --> always 0 wei 
// Deploy --> it call metamask 
// Metamask --> deploys the contract with ganache
// Ganache --> the contract has been created in my fintech blockchain (I can see the contract address 
// CREATED CONTRACT ADDRESS 0x789670ab51A182049Bb27ef1aC9349d7187F7293 

// execution 
// I can send eth from metamask account 3 or 5) directly to the contract (its address)
// to deploy --> Value (on top) has to be 0 (if not errors)
// to deposit --> change the valur to send and then click deposit
// balance --> now I can see the balance account (below to balancecontact button)

contract JointSavings {
    // the contract as such can have eth and have an address (wee in ganache)
    // this are the two accouts that can operate the contract (joint savings account)
    // address payable account_one = 0x6E02eD14fd20A4f7A42197D0C0134f015E3e16Bb;   // my account in metamask account 5
    // address payable account_two = 0xFf6c6a4Dc533571f04358EE0b1Fff0aD7920eD56;   // my account in metamask account 3
    address payable public account_one;
    address payable public account_two;

    // constructor functions runs only one time 
    // is the first thing that runs 
    // when we deploy the contract tjis function will ask for the accounts as entry parameters (only runs once)
    constructor (address payable _one, address payable _two) public {
        account_one = _one;
        account_two = _two;
    }
        

        
        
  uint public balanceContract;      // this variable gives the balance of the account/contract 
  
  address public lastToWithdraw;    // last account the withdrawed 
  uint public lastWithdrawBlock;
  uint public lastWithdrawAmount;
  
  uint unlockTime;
  uint fakenow = now;
  
  function fastforward() public{
      fakenow += 100 days;
  }

  function withdraw(uint amount) public {
      //require( ((recipient == account_one) || (recipient == account_two)), "You don't own this account!"); // only account1 and 2 (owners) can withdraw
      // msg.sender // allow me to know what sis the address that is interacting with the contract 
      // I don't need anymore to know who is the recipient as we are only autorithing specific sender 
      // function withdraw(uint amount, address payable recipient) public {
      // recipient.transfer(amount);
    require( ((msg.sender == account_one) || (msg.sender == account_two)), "You don't own this account!"); // only autorithed address can withdraw
    require( (amount < address(this).balance / 4), "you are withdrawing too!!"); // only autorithed address can withdraw
    require( fakenow >= unlockTime, "your account is currently lock");

      
      msg.sender.transfer(amount);
      balanceContract = address(this).balance;  // balanceContract updated with each withdraw; this --> this specific contract 
      
      if (lastToWithdraw != msg.sender) {
         lastToWithdraw = msg.sender;
      }
      
      lastWithdrawAmount = amount;
      lastWithdrawBlock = block.number;
      
      if (amount > address(this).balance / 5 ) {
        unlockTime = now + 24 hours;
      }
 
      
    }
    
    address public lastToDeposit;    // last account the withdrawed 
    uint public lastDepositBlock;
    uint public lastDepositAmount;
  
    function deposit() public payable {
        balanceContract = address(this).balance;
        
        if (lastToDeposit != msg.sender) {
           lastToDeposit = msg.sender;
      }
      
      lastDepositAmount = msg.value;    // no need to create a variable, we can take the value used by the sender 
      lastDepositBlock = block.number;
    }



  function() external payable {}
}

