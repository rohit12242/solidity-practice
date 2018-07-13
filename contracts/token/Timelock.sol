pragma solidity ^0.4.17;

import "./ERC20Interface.sol";

contract timeLock{
    
    ERC20Interface token;
    address beneficiary;
    uint releaseTime;
    
    function timeLock(ERC20Interface _token,address _beneficiary, uint _releaseTime) public{
        require(_releaseTime > block.timestamp);
        token=_token;
        beneficiary=_beneficiary;
        releaseTime =_releaseTime;
    }
    function release() public {
        require(block.timestamp> releaseTime);
        
        uint amount = token.balanceOf(this);
        require(amount>0);
        token.transfer(beneficiary,amount);
    }
    
}




