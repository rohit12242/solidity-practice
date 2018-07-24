
pragma solidity ^0.4.17;

import "./ERC20Interface.sol";
import "./SafeMath.sol";
import "./ownable.sol";

contract contractToken is ownable {
    using SafeMath for uint;
    ERC20Interface token;
    mapping(address => uint) employees;
    mapping(address => uint) released;
    mapping(address => bool) employeeLeaved;
    uint public cliff;
    uint public start;
    uint public duration ;
    uint public totalContractAmount;
    mapping(address => uint) salaryOfADay; 
    
    
    
    
    
    constructor(ERC20Interface _token,uint _cliff,uint _start,uint _duration) public{
        
        require(_cliff < _duration);
        token=_token;
        start =_start;
        cliff =_cliff.add(start);
        duration=_duration  ;
        
        
    }
    function addEmployee(address _beneficiary,uint _contractAmount)public onlyOwner {
        require(block.timestamp < start); 
        require(_contractAmount >0);
        require(_beneficiary != address(0));
        require(token.balanceOf(this) >= totalContractAmount.add(_contractAmount));
        totalContractAmount= totalContractAmount.add(_contractAmount);
        
        employees[_beneficiary] = _contractAmount;
        salaryOfADay[_beneficiary] = _contractAmount.div(duration.div(50));
    }
    function release(address _employee) public {
        //require(msg.sender== _employee || (msg.sender== owner && flag== true)); 
        require(employees[msg.sender]>0); 
        if(employeeLeaved[_employee]== true){ 
            require(employees[_employee] >0); 
            token.transfer(_employee, employees[_employee]);
            employees[_employee]=0;
        }
        else {
            uint amount = releasableAmount(_employee);
            require(amount >0);
            released[_employee] = released[_employee].add(amount);
            token.transfer(_employee,amount);
        }
    }
    
    function releasableAmount(address _employee) internal returns(uint) {
        return vesting(_employee).sub(released[_employee]);
    }
    
    
    
    function vesting(address _employee) internal returns(uint) {
        require(employees[_employee]>0);
        if(block.timestamp < cliff){
            return 0;
        }
        else if(block.timestamp >= (start.add(duration)) ){
           
            return employees[_employee];
        }
    
        
        else{
            
            return employees[_employee].mul(block.timestamp.sub(start)).div(duration);
        }
    }
    function employeeLeave(address _employee)public onlyOwner {
        require(employeeLeaved[_employee]==false);
        if(block.timestamp < cliff){
            token.transfer(owner,employees[_employee]);
            employees[_employee]=0;
            employeeLeaved[_employee]= true;
        }
        else{
            uint currentBalance = vesting(_employee); 
            uint unreleased = releasableAmount(_employee); 
            uint remaining = employees[_employee].sub(currentBalance); 
            require(remaining >0);
            token.transfer(owner,unreleased);
            employees[_employee] = unreleased;
            employeeLeaved[_employee]= true;
        
        }
    }
    function employeeAbsent(address _employee) public onlyOwner {
        require(employeeLeaved[_employee]== false);
        released[_employee] = released[_employee].add(salaryOfADay[_employee]); 
        token.transfer(owner,salaryOfADay[_employee]);
    }

    function blocktime() public constant returns(uint) {
        return block.timestamp;
    }
    
}

