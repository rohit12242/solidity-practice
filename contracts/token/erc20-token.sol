pragma solidity ^0.4.17;

import "./ierc20.sol";
import "../math/SafeMath.sol";

contract practiceToken is ERC20Interface{
    using SafeMath for uint256;
    uint public totalSupply =1000000;
    string public tokenName ='Ram';
    uint public decimal =3;
    address owner;
    
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
    function practiceToken()  {
        owner=msg.sender;
        balances[msg.sender] = totalSupply;
    }
    function totalSupply() public constant returns(uint){
        return totalSupply;
    }
    function balanceOf(address tokenOwner) public constant returns(uint){
        return balances[tokenOwner];
    }
    function transfer(address to,uint tokens) public returns(bool ){
        require(balances[msg.sender] >= tokens && tokens>0);
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        
        
    }
    function approve(address spender,uint _value) public returns(bool ){
        allowed[msg.sender][spender] = _value;
    }
    function transferFrom(address from ,address to, uint _value) public returns(bool){
        require(allowed[from][msg.sender] >= _value
                && balances[from] >= _value
                && _value >0
                 );
                 
        balances[from] = balances[from].sub(_value);
        balances[to] = balances[to].add(_value);
        allowed[from][msg.sender]= allowed[from][msg.sender].sub(_value);
    }
    function allowance(address tokenOwner,address spender) public constant returns(uint){
        return allowed[tokenOwner][spender];
    }

    
