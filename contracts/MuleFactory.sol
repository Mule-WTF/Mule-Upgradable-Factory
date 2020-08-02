pragma solidity ^0.6.0;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Capped.sol";

contract MuleFactory is Initializable {
  string public token_sub;

  struct TokenContract {
    address creator;
    string name;
    uint256 supply;
    address contractAddress;
  }

  event TokenAdded(address indexed contract_address, string token_name, uint256 total_supply);

  TokenContract[] public contracts;
  address[] public tokenContracts;

  mapping(address => address[]) public creatorContracts;
  mapping(string => TokenContract) public tokenNames;

  function initialize() public initializer {
    token_sub = ".Mule";
  }

  function newToken(string memory _tokenName, uint256 _supply) public payable isValid(_tokenName, _supply) returns (address contractAddress) {
    string memory TokenName = string(abi.encodePacked(_tokenName, token_sub));
    MuleWTF child = new MuleWTF(msg.sender, TokenName, _supply);

    TokenContract memory tc = TokenContract({
      creator: msg.sender,
      name: TokenName,
      supply: _supply,
      contractAddress: address(child)
    });

    contracts.push(tc);
    creatorContracts[msg.sender].push(address(child));
    tokenContracts.push(address(child));
    tokenNames[TokenName] = tc;

    emit TokenAdded(address(child), TokenName, _supply);

    return address(child);
  }

  function allContracts() public view returns (address[] memory) {
    return tokenContracts;
  }

  function contractsByCreator(address _creator) public view returns (address[] memory) {
    return creatorContracts[_creator];
  }

  function contractByName(string memory _name) public view returns (address) {
    TokenContract memory t = tokenNames[_name];
    return t.contractAddress;
  }

  modifier isValid(string memory _name, uint256 _supply) {
    require(contractsByCreator(msg.sender).length < 5, 'Only 5 tokens allowed per address.');
    require(contractByName(_name) == address(0), 'Token name already exists.');
    require(testStr(_name), 'Invalid token name.');
    require(_supply <= 1000000000, 'Supply over max.');
    require(_supply >= 1, 'Supply must be greater than 1.');
    _;
  }

  /* https://ethereum.stackexchange.com/questions/50369/string-validation-solidity-alpha-numeric-and-length/50375#50375 */
  function testStr(string memory str) public pure returns (bool) {
    bytes memory b = bytes(str);
    if(b.length > 8 || b.length < 3) return false;
    for(uint i; i<b.length; i++){
        bytes1 char = b[i];
        if(
            !(char >= 0x30 && char <= 0x39) && //9-0
            !(char >= 0x41 && char <= 0x5A) && //A-Z
            !(char >= 0x61 && char <= 0x7A) && //a-z
            !(char == 0x24) && // $
            !(char == 0x3f) && // ?
            !(char == 0x21) // !
        )
            return false;
    }
    return true;
  }

}

contract MuleWTF is ERC20Capped {
  constructor (address payable tokenOwner, string memory tokenName, uint256 supply) public
    ERC20Capped(supply * (10 ** uint256(18)))
    ERC20(tokenName, tokenName) {
      _mint(tokenOwner, supply * (10 ** uint256(decimals())));
    }
}
