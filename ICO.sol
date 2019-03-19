pragma solidity ^0.5.1;

contract SafeMath{
  function safeMul(uint a, uint b) internal returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeDiv(uint a, uint b) internal returns (uint) {
    assert(b > 0);
    uint c = a / b;
    assert(a == b * c + a % b);
    return c;
  }
	
	function safeSub(uint a, uint b) internal returns (uint) {
    	assert(b <= a);
    	return a - b;
  }

	function safeAdd(uint a, uint b) internal returns (uint) {
    	uint c = a + b;
    	assert(c >= a);
    	return c;
  }
}


contract ERC20{

 	function totalSupply() public returns (uint256 _totalSupply) {}
	function balanceOf(address _owner) public returns (uint256 balance) {}
	function transfer(address _recipient, uint256 _value) public returns (bool success) {}
	function transferFrom(address _from, address _recipient, uint256 _value) public returns (bool success) {}
	function approve(address _spender, uint256 _value) public returns (bool success) {}
	function allowance(address _owner, address _spender)public view returns (uint256 remaining) {}

	event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);


}
/**********************************************
 * 
 * ***************************************/
contract ICO is ERC20, SafeMath{

	
	mapping(address => uint256) balances;
    uint256 totalSupplyValue;

	function balanceOf(address _owner)public returns (uint256 balance) {
	    return balances[_owner];
	}

	function transfer(address _to, uint256 _value) public returns (bool success){
	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
	    balances[_to] = safeAdd(balances[_to], _value);
	    emit Transfer(msg.sender, _to, _value);
	    return true;
	}

	mapping (address => mapping (address => uint256)) allowed;

	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
	    uint256 _allowance = allowed[_from][msg.sender];
	    
	    balances[_to] = safeAdd(balances[_to], _value);
	    balances[_from] = safeSub(balances[_from], _value);
	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
	    emit Transfer(_from, _to, _value);
	    return true;
	}

	function approve(address _spender, uint256 _value) public returns (bool success) {
	    allowed[msg.sender][_spender] = _value;
	    emit Approval(msg.sender, _spender, _value);
	    return true;
	}

	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
	    return allowed[_owner][_spender];
	}




	uint256 public endTime;

	modifier during_offering_time(){
		require (now < endTime);
			_;
		
	}

	function () payable external during_offering_time {
		createTokens(msg.sender);
	}

	function createTokens(address recipient) payable public{
		require (msg.value > 0);

		uint tokens = safeDiv(safeMul(msg.value, price), 1 ether);
		totalSupplyValue = safeAdd(totalSupplyValue, tokens);

		balances[recipient] = safeAdd(balances[recipient], tokens);

		owner.transfer(msg.value);
	}




	string 	public name = "ICOCoin";
	string 	public symbol = "IC";
	uint 	public decimals = 3;
	uint256 public INITIAL_SUPPLY = 10000;
	uint256 public price;
	address payable public owner;

	constructor() public{
		totalSupplyValue = INITIAL_SUPPLY;
		balances[msg.sender] = INITIAL_SUPPLY;  // Give all of the initial tokens to the contract deployer.
		endTime = now + 1 weeks;
		owner 	= msg.sender;
		price 	= 500;
	}

}