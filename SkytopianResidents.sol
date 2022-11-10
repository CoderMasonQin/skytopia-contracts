// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract SkytopianResidents is Ownable, ERC721Pausable {
    using Strings for uint256;

    uint256 public constant totalSupply = 10000;
    
    uint256 internal _mintAmountPerAddress = 1;
    
    uint256 internal _currentSupply;
    
    string private baseURI = "https://resources.cryptoskyland.com/SkytopianResidents/metadata_";

    mapping(address => bool) internal _minters;
    
    mapping(address => uint256) internal _mintedNumList;

    event MintLog(address to, uint256 tokenid, uint256 price);

    constructor(string memory name, string memory symbol)  ERC721(name, symbol){
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function setMinter(address minter, bool enabled) onlyOwner public {
        _minters[minter] = enabled;
    }

    function setMintAmountPerAddress(uint256 mintAmountPerAddress) onlyOwner public {
        _mintAmountPerAddress = mintAmountPerAddress;
    }

    function getMintAmountPerAddress()  public view returns(uint256 ){
        return _mintAmountPerAddress;
    }

    function isMinter(address who) public view returns (bool) {
        return _minters[who];
    }

    function mintedNum(address who) public view returns(uint256) {
        return _mintedNumList[who];
    }

    function mint(address to, uint256 tokenid, uint256 price)  public  {
        require(
            isMinter(msg.sender),
            "Only a minter can mint"
        );
        require(_mintedNumList[to] < _mintAmountPerAddress,
        "Exceed mint amount per address.");
        require(_currentSupply < totalSupply, "Exceed totalSupply");
        
        _safeMint(to, tokenid);
        _mintedNumList[to]++;
        _currentSupply++;

        emit MintLog(to, tokenid, price);
    }

    function batchTransfer(
        address from,
        address to,
        uint256[] calldata tokenidlist
    ) public {
        for (uint256 i = 0; i < tokenidlist.length; i++) {
            uint256 tokenid = tokenidlist[i];
            transferFrom(from, to,tokenid);
        }
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireMinted(tokenId);
        return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
    }

    function setBaseUri(string memory uri) public onlyOwner {
        baseURI = uri;
    }
}