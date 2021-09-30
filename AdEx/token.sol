pragma solidity >=0.7.0 <0.9.0;

import "browser/ERC20.sol";

contract MyFirstToken is ERC20 {
    string public constant symbol = "ADX";
    string public constant name = "AdEx";
    uint8 public constant decimals = 0;
    
    uint private constant __totalSupply = 100000000;
    mapping (address => uint) private __balanceOf;
    mapping (address => mapping (address => uint)) private __allowances;
    
    uint public constant hardCapETH = 40000;
    uint public totalETH = 0;
    uint public rate = 900;
    
    constructor() public {
            __balanceOf[msg.sender] = __totalSupply;
    }
    
    function totalSupply() public returns (uint _totalSupply) {
        _totalSupply = __totalSupply;
    }
    
    function balanceOf(address _addr) public returns (uint balance) {
        return __balanceOf[_addr];
    }
    
    function transfer(address _to, uint _value) public returns (bool success) {
        if (_value >= 0 && _value <= balanceOf(msg.sender)) {
            __balanceOf[msg.sender] -= _value;
            __balanceOf[_to] += _value;
            return true;
        }
        return false;
    }
    
    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        if (__allowances[_from][msg.sender] > 0 && _value > 0 && __allowances[_from][msg.sender] >= _value && __balanceOf[_from] >= _value) {
            __balanceOf[_from] -= _value;
            __balanceOf[_to] += _value;

            __allowances[_from][msg.sender] -= _value;
            return true;
        }
        return false;
    }
    
    function approve(address _spender, uint _value) public returns (bool success) {
        __allowances[msg.sender][_spender] = _value;
        return true;
    }
    
    function allowance(address _owner, address _spender) public returns (uint remaining) {
        return __allowances[_owner][_spender];
    }
    
    function buyToken(uint amount) payable public returns (bool success) {
    // ensure enough tokens are owned by the depositor
    uint costWei = (amount * 1 ether) / rate;
    totalETH += costWei;
    require(msg.value >= costWei);
    assert(token.transfer(msg.sender, amount));
    BuyToken(msg.sender, amount, costWei, token.balanceOf(msg.sender));
    uint change = msg.value - costWei;
    if (change >= 1) msg.sender.transfer(change); //??????????????????????????????????
    return true;
  }
}