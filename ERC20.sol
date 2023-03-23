pragma solidity >=0.8.2 <0.9.0;

interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender) external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value) external returns (bool);

  function transferFrom(address from, address to, uint256 value) external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}
contract Coins is IERC20{
    mapping (address => uint256) private balance;

    address private owner;

    constructor(){
        balance[msg.sender]=1000;
        owner=msg.sender;
    }

    uint256 private totalTokens;

    mapping (address => mapping (address => uint256)) private maximumAllowance;

    mapping (address => mapping (address => uint128)) private totalCalls;

    function totalSupply() public view returns(uint256){
        return totalTokens;
    }

    function balanceOf(address _owner) public view returns(uint256){
        return balance[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success){
        if(balance[msg.sender] >= _value)
        {
            return false;
        }
        balance[msg.sender]=balance[msg.sender]-_value;
        balance[_to]=balance[_to]+_value;
        emit Transfer(msg.sender,_to,_value);
        return true;
    }

    function mint(address _to) public {
        require(msg.sender==owner, "Not Authorized to mint coins");
        balance[_to]=balance[_to]+10;
        totalTokens+=10;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool){
        if(balance[_from] >= _value && _value <= maximumAllowance[msg.sender][_from])
        {
            return false;
        }
        maximumAllowance[_from][_to]=maximumAllowance[_from][_to]-_value;
        balance[_from]=balance[_from]-_value;
        balance[_to]=balance[_to]+_value;
        emit Transfer(_from,_to,_value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool){
        maximumAllowance[msg.sender][_spender]=_value;
        emit Approval(msg.sender,_spender,_value);
        return true;
    }

    function allowance(address _owner, address _spender) external view returns (uint256){
        return maximumAllowance[_owner][_spender];
    }
}