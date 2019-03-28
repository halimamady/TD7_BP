pragma solidity  >= 0.4.22 <0.6.0;


contract ticketingSystem
{

struct Artist
{
address owner;
bytes32 name;
uint256 artistCategory;
uint256 totalTicketSold;	
}

struct Venue
{
  uint id;
  bytes32 name;
  address owner;
  uint Comission;
  uint capacity;
 
}

uint256 artistId =1;
uint256 venueCounter =1;

    
mapping(uint256 => Artist) public artistsRegister;
mapping (uint256 => Venue) public venuesRegister;

function createArtist(bytes32 _name, uint256 _artistCategory) public
{	
artistsRegister[artistId].owner = msg.sender;
artistsRegister[artistId].name = _name;
artistsRegister[artistId].artistCategory = _artistCategory;
artistsRegister[artistId].totalTicketSold = 0;
artistId++;
}

function modifyArtist(uint256 id, bytes32 _newName, uint256 _newartistCategory, address _newOwner) public
{
require(msg.sender == artistsRegister[id].owner);
artistsRegister[id].name = _newName;
artistsRegister[id].artistCategory = _newartistCategory;
artistsRegister[id].owner = _newOwner;
}


function createVenue (bytes32 _name, uint _capacity, uint _comission) public
{
  venuesRegister[venueCounter].owner=msg.sender;
  venuesRegister[venueCounter].id=venueCounter;
  venuesRegister[venueCounter].name=_name;
  venuesRegister[venueCounter].capacity=_capacity;
  venuesRegister[venueCounter].Comission=_comission;
  venueCounter++;
}

function modifyVenue(uint id,bytes32 _name,uint _capacity,uint _comission,address _newOwner )public
{
  require(venuesRegister[id].owner==msg.sender);
  venuesRegister[id].owner=_newOwner;
  venuesRegister[id].name=_name;
  venuesRegister[id].capacity=_capacity;
  venuesRegister[id].Comission=_comission;
  
}

}
