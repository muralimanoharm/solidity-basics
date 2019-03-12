pragma solidity ^0.5.1;

contract Will{
 address owner;
 uint fortune;
 bool isDeceased;
 constructor() public payable {
     owner = msg.sender;
     fortune = msg.value;
     isDeceased = false;
 }
 modifier onlyOwner{
     require(msg.sender == owner);
     _;
 }
 
 modifier mustBeDeceased{
     require(isDeceased == true);
     _;
 }
 address payable[] wallets;
 mapping (address=>uint)inheritance;
 function SetInheritance(address payable _wallet,uint _inheritance) public onlyOwner{
     wallets.push(_wallet);
     inheritance[_wallet] = _inheritance;
 }
 
 function payout() private mustBeDeceased{
     for(uint i=0;i<wallets.length;i++){
         wallets[i].transfer(inheritance[wallets[i]]);
     }
 }
 function deceased() public onlyOwner{
     isDeceased = true;
     payout();
 }
}