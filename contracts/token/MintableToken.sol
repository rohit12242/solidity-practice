pragma solidity ^0.4.18;

import "./erc20-token.sol";
contract mintableToken is practiceToken{
    
    function mint(address to , uint value) public hasMintPermission canMint{
        totalSupply = totalSupply.add(value);
        balances[to] = balances[to].add(value);
    }
    
    bool mintingFinished = false;
    modifier canMint(){
        require(!mintingFinished);
        _;
    }
    modifier hasMintPermission(){
        require(msg.sender==owner);
        _;
    }
    function finishMinting() public {
        mintingFinished = true;
    }
}
