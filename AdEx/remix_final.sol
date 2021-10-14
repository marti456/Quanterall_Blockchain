pragma solidity >=0.7.0 <0.9.0;

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";
//import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

interface ERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract MyFirstToken is ERC20{
    using SafeMath for uint256;  
    address public owner;
    string public constant symbol = "ADX";
    string public constant name = "AdEx";
    uint8 public constant decimals = 0;
    
    uint private __totalSupply = 100000000;
    mapping (address => uint) private __balanceOf;
    mapping (address => mapping (address => uint)) private __allowances;
    
    uint public constant hardCapEth = 40000;
    uint public totalEth = 0;
    uint256 public rate = 900;
    uint256 public start;
    
    //event BuyToken(address user, uint amount, uint costWei, uint balance);
    
    constructor() payable{
            //__balanceOf[msg.sender] = 0;
            owner = msg.sender;
            start = block.timestamp;
    }
    
    function totalSupply() public override view returns (uint _totalSupply) {
        return __totalSupply;
    }
    
    function balanceOf(address _addr) public override view returns (uint balance) {
        return __balanceOf[_addr];
    }
    
    function transfer(address _to, uint _value) public override returns (bool success) {
        if (_value >= 0 && _value <= balanceOf(msg.sender)) {
            __balanceOf[msg.sender] -= _value;
            __balanceOf[_to] += _value;
            return true;
        }
        return false;
    }
    
    function transferFrom(address _from, address _to, uint _value) public override returns (bool success) {
        if (__allowances[_from][msg.sender] > 0 && _value > 0 && __allowances[_from][msg.sender] >= _value && __balanceOf[_from] >= _value) {
            __balanceOf[_from] -= _value;
            __balanceOf[_to] += _value;

            __allowances[_from][msg.sender] -= _value;
            return true;
        }
        return false;
    }
    
    function approve(address _spender, uint _value) public override returns (bool success) {
        __allowances[msg.sender][_spender] = _value;
        return true;
    }
    
    function allowance(address _owner, address _spender) public override view returns (uint remaining) {
        return __allowances[_owner][_spender];
    }
    
    function getAddress() public view returns (address){
        return owner;
    }
    
    function mulScale (uint x, uint y, uint128 scale) internal pure returns (uint) {
        uint a = x / scale;
        uint b = x % scale;
        uint c = y / scale;
        uint d = y % scale;
        
        return a * c * scale + a * d + b * c + b * d / scale;
    }
    
    function buyTokens() public payable returns (uint){
        uint256 tokens = 0;
        tokens = mulScale(msg.value, rate,  10**18);
        
        /*if (block.timestamp <= (start + 1 * 1 days)){
            tokens += mulScale(tokens, 30,  100);
        }
        else if (block.timestamp <= (start + 7 * 1 days)){
            tokens += mulScale(tokens, 15,  100);
        }*/
        
        if (compareDates() <= 1){
            tokens += mulScale(tokens, 30,  100);
        }
        else if (compareDates() <= 7){
            tokens += mulScale(tokens, 15,  100);
        }
        
        totalEth += msg.value.div(10**18);
        
        __balanceOf[msg.sender] += tokens;
        __totalSupply -= tokens;
        //token.transfer(_beneficiary, tokens);
        //payable(wallet).transfer(msg.value);
        
        return __balanceOf[msg.sender];
    }
    
    function compareDates() private view returns (uint256){

        uint256 currentTime = block.timestamp;
        uint256 diff = (currentTime - start).div(60).div(60).div(24); 
        return diff;
    }
  
  
}




/*contract Crowdsale{
  using SafeMath for uint256;

  ERC20 public token;
  uint256 public tokens;
  address public wallet;
  uint256 public rate;
  uint256 public weiRaised;
  uint256 public start;

  constructor() payable {
    uint256  _rate = 900;
    MyFirstToken _token = new MyFirstToken();
    start = block.timestamp;

    require(_rate > 0);
    //require(_wallet != address(0));
    //require(_token != address(0));
    
    
    rate = _rate;
    wallet = _token.getAddress();
    token = _token;
    
    require(msg.value != 0);
    tokens = msg.value.mul(rate);
    buyTokens(msg.sender);
  }

  function balanceOfAdEx() external payable returns(uint balance){
    return token.balanceOf(msg.sender);
  }

  
}

*/



/*contract DEX {

    event Bought(uint256 amount);
    event Sold(uint256 amount);


    IERC20 public token;

    constructor() {
        token = new MyFirstToken();
    }

    function buy() payable public {
        uint256 amountTobuy = msg.value;
        uint256 dexBalance = token.balanceOf(address(this));
        require(amountTobuy > 0, "You need to send some ether");
        require(amountTobuy <= dexBalance, "Not enough tokens in the reserve");
        token.transfer(msg.sender, amountTobuy);
        emit Bought(amountTobuy);
    }

    function sell(uint256 amount) public {
        require(amount > 0, "You need to sell at least some tokens");
        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance >= amount, "Check the token allowance");
        token.transferFrom(msg.sender, address(this), amount);
        payable(msg.sender).transfer(amount);
        emit Sold(amount);
    }

}*/