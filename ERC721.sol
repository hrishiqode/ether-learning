pragma solidity >=0.8.2 <0.9.0;

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
        if(balance[msg.sender] <= _value)
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
        emit Transfer(_from,_to,_value);
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

    function forNFTSwap(bytes memory from, bytes memory to, uint256 _value) external returns (bool){
        address _from=abi.decode(from,(address));
        address _to=abi.decode(to,(address));
        transfer(_to,_value);
        emit Transfer(_from,_to,_value);
        return true;
    }

    function forNFTSwap1(bytes memory from, bytes memory to, uint256 _value) external returns (bool){
        /* address _from=abi.decode(from,(address));
        address _to=abi.decode(to,(address));
        transfer(_to,_value);
        emit Transfer(_from,_to,_value); */
        return true;
    }
}
interface IERC721 /* is ERC165 */ {
    /// @dev This emits when ownership of any NFT changes by any mechanism.
    ///  This event emits when NFTs are created (`from` == 0) and destroyed
    ///  (`to` == 0). Exception: during contract creation, any number of NFTs
    ///  may be created and assigned without emitting Transfer. At the time of
    ///  any transfer, the approved address for that NFT (if any) is reset to none.
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    /// @dev This emits when the approved address for an NFT is changed or
    ///  reaffirmed. The zero address indicates there is no approved address.
    ///  When a Transfer event emits, this also indicates that the approved
    ///  address for that NFT (if any) is reset to none.
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    /// @dev This emits when an operator is enabled or disabled for an owner.
    ///  The operator can manage all NFTs of the owner.
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) external view returns (uint256);

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address);

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    /// @param data Additional data with no specified format, sent in call to `_to`
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external payable;

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param _approved The new approved NFT controller
    /// @param _tokenId The NFT to approve
    function approve(address _approved, uint256 _tokenId) external payable;

    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg.sender`'s assets
    /// @dev Emits the ApprovalForAll event. The contract MUST allow
    ///  multiple operators per owner.
    /// @param _operator Address to add to the set of authorized operators
    /// @param _approved True if the operator is approved, false to revoke approval
    function setApprovalForAll(address _operator, bool _approved) external;

    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT.
    /// @param _tokenId The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none
    function getApproved(uint256 _tokenId) external view returns (address);

    /// @notice Query if an address is an authorized operator for another address
    /// @param _owner The address that owns the NFTs
    /// @param _operator The address that acts on behalf of the owner
    /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}

interface IERC165 {
    /// @notice Query if a contract implements an interface
    /// @param interfaceID The interface identifier, as specified in ERC-165
    /// @dev Interface identification is specified in ERC-165. This function
    ///  uses less than 30,000 gas.
    /// @return `true` if the contract implements `interfaceID` and
    ///  `interfaceID` is not 0xffffffff, `false` otherwise
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}
contract Assets is IERC721{
    string private name;

    uint256 public totalTokens;

    string private symbol;

    address creator;

    address private coinsContract;

    mapping(uint256 => address) private owners;

    mapping(uint256 => uint256) private prices;

    mapping(address => uint256) private balances;

    mapping(uint256 => address) private tokenApprovals;

    mapping(address => mapping(address => bool)) private operatorApprovals;

    constructor(address _coinsContract) {
        coinsContract=_coinsContract;
        creator=msg.sender;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        return owners[tokenId];
    }

    function approve(address to, uint256 tokenId) public {
        address owner = owners[tokenId];
        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "Not Authorized"
        );
        tokenApprovals[tokenId] = to;
        emit Approval(owners[tokenId], to, tokenId);
    }

    function getApproved(uint256 tokenId) public view  override returns (address) {
        return tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public  override {
        operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view override returns (bool) {
        return operatorApprovals[owner][operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public  {
        address owner = owners[tokenId];
        require(from == owner && (owner ==msg.sender || isApprovedForAll(owner, msg.sender) || getApproved(tokenId) == to), "Not Authorized");
        delete tokenApprovals[tokenId];
        balances[from]-=1;
        balances[from]+=1;
        owners[tokenId]=to;
        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable {
        transferFrom(from, to, tokenId);
    }

    function mint(uint256 price) public {
        totalTokens++;
        owners[totalTokens]=msg.sender;
        balances[msg.sender]++;
        prices[totalTokens]=price;
    }

    function swap(address from,address to,uint256 tokenId) external returns(bool)
    {
        address payable _coinsContract=payable(coinsContract);
        (bool success,bytes memory data)=_coinsContract.delegatecall((abi.encodeWithSignature("forNFTSwap(bytes,bytes,uint256)",abi.encode(to), abi.encode(from), prices[tokenId])));
        require(success,"Payment not recieved");
        transferFrom(from, to, tokenId);
        return true;
    }
}
