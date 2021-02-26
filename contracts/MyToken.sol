// SPDX-License-Identifier: MIT
pragma solidity 0.7.4;

import "node_modules/@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";


contract MyToken is Initializable {
    
    string private name;
    string private symbol;
    uint256 private total_supply;
    uint8 private decimal;
    address public owner;
    bool initialized;


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping (address => uint) private balances;
    mapping (address => mapping(address => uint)) private allownce;

    function initialize() public initializer{
        require(!initialized,"Alreday initialized...!");
        name="FarhanCoins";
        symbol="FRX";
        decimal=18;
        total_supply=10000;
        owner=msg.sender;
        balances[owner]+=total_supply;
        initialized=true;
    }
    
    function totalSupply() external view returns(uint256){
        return total_supply;
    }
    
    function getName() external view returns(string memory){
        return name;
    }
    
    function getSymbol() external view returns(string memory){
        return symbol;
    }
    function getDecimal() external view returns(uint8){
        return decimal;
    }
    
    function balanceOf(address _user) public view returns(uint256){
        return balances[_user];
    }
    
    function transfer(address _to, uint256 _value) external  returns(bool){
        require(_to!=address(0),"Invalid Address");
        require(_value<=balances[msg.sender]);
        balances[msg.sender]-=_value;
        balances[_to]+=_value;
        emit Transfer(msg.sender,_to,_value);
        return true;
    }
    
    function approve(address spender, uint256 amount) external returns(bool){
        require(spender!=address(0),"Not Valid Address ");
        require(amount<=balances[msg.sender]);
        allownce[msg.sender][spender]+=amount;
        emit Approval(owner, spender, amount);(msg.sender,spender,amount);
        return true;
    }
    
    function allowance(address _owner, address _spender) external view returns(uint256){
        return allownce[_owner][_spender];
    }
    
    function transferFrom(address _sender, address _to, uint256 _value) external returns(bool){
        require(_to!=address(0),"Invalid recipient address");
        require(allownce[_sender][msg.sender]<= _value , "_sender have not enough balance");
        balances[_sender]-=_value;
        balances[_to]+=_value;
        allownce[_sender][msg.sender]-=_value;
        return true;
        
    }

        function mint(address _from, uint amount) external returns(bool){
        require(_from!=address(0),"mint: Invalid Address...!");
        require(msg.sender==owner,"mint: Minter is no owner");
        balances[_from]+=amount;
        total_supply+=amount;
        return true;
    }

    function burn(address _from, uint amount) external returns(bool){
        require(_from!=address(0)," burn: invalid address");
        require(amount <total_supply,"burn: Amount is greater than total_supply");
        require(amount<=balances[_from],"burn: not have balance to burn");
        balances[_from]-=amount;
        total_supply-=amount;
        return true;
    }

    function setTotalSupplyToZero() external {
        require(msg.sender==owner,"Not a valid owner...!");
        total_supply=0;
    }
    
}


