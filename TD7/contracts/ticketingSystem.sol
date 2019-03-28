pragma solidity >=0.4.22<0.6.0;


contract ticketingSystem{

	using SafeMath for uint256;
    using Address for address;
	using Counters for Counters.Counter;

	struct Artist{
	
		bytes32 name;
		int artistCategory;
		int total_ticket;
		address payable owner;
	}
	struct Venue{
		bytes32 name;
		uint capacity;
		int standardComission;
		address payable owner;
	}
	
	struct Concert{
		uint256 concertDate;
		uint venueId;
		uint ticketPrice;
		uint artistId;
		uint totalSoldTicket;
		uint totalMoneyCollected;
		bool validatedByArtist;
		bool validatedByVenue;
	}
	
	struct Ticket{
		address payable owner;
		bool isAvailable;
		uint ticketNumber;
		uint concertId;
		bool isAvailableForSale;
		uint amountPaid;
	}
	
	mapping(uint => Artist) public artistsRegister;
	uint public nextArtistId=1;
	
	mapping(uint => Venue) public venuesRegister;
	uint public nextVenueId=1;

	mapping(uint => Concert) public concertsRegister;
	uint public nextConcertId=1;

	mapping(uint => Ticket) ticketsRegister;
	uint public nextTicketId=1;
	


	
	function createArtist(bytes32 name1,int cat) public returns (uint){

		artistsRegister[nextArtistId].name=name1;
		artistsRegister[nextArtistId].artistCategory=cat;
		artistsRegister[nextArtistId].total_ticket=0;
		artistsRegister[nextArtistId].owner=msg.sender;

		nextArtistId++;
		
		return(nextArtistId-1);
	}
	
	function modifyArtist(uint i, bytes32 newname, int newcat, address payable newowner) public{
		require(msg.sender==artistsRegister[i].owner);
		artistsRegister[i].name=newname;
		artistsRegister[i].artistCategory=newcat;
		artistsRegister[i].owner=newowner;
	}
	
	

	
	function createVenue(bytes32 name1, uint cap, int com) public returns(uint){
		venuesRegister[nextVenueId].name=name1;
		venuesRegister[nextVenueId].capacity=cap;
		venuesRegister[nextVenueId].standardComission=com;
		venuesRegister[nextVenueId].owner=msg.sender;

		nextVenueId++;
		
		return(nextVenueId-1);
	}

	function modifyVenue(uint i, bytes32 newname, uint newcap, int newcom, address payable newowner) public{
		require(msg.sender==venuesRegister[i].owner);
		venuesRegister[i].capacity=newcap;
		venuesRegister[i].standardComission=newcom;
		venuesRegister[i].owner=newowner;
		venuesRegister[i].name=newname;
		
	}
	

	
	function createConcert(uint _artistId, uint _venueId, uint _concertDate, uint _ticketPrice) public returns (uint concertNumber)
	{
		require(_concertDate >= now);
		require(artistsRegister[_artistId].owner != address(0));
		require(venuesRegister[_venueId].owner != address(0));

		concertsRegister[nextConcertId].concertDate = _concertDate;
		concertsRegister[nextConcertId].artistId = _artistId;
		concertsRegister[nextConcertId].venueId = _venueId;
		concertsRegister[nextConcertId].ticketPrice = _ticketPrice;

		validateConcert(nextConcertId);
		concertNumber = nextConcertId;
		nextConcertId +=1;
	}

	function validateConcert(uint _concertId) public
	{
		require(concertsRegister[_concertId].concertDate >= now);

		if (venuesRegister[concertsRegister[_concertId].venueId].owner == msg.sender)
		{
		concertsRegister[_concertId].validatedByVenue = true;
		}
		if (artistsRegister[concertsRegister[_concertId].artistId].owner == msg.sender)
		{
			concertsRegister[_concertId].validatedByArtist = true;
		}
	}
	
	function emitTicket(uint _concertId, address payable ad) public returns (uint ticketNumber)
	{
		uint art=concertsRegister[_concertId].artistId;
		require(artistsRegister[art].owner==msg.sender);
		
		ticketsRegister[nextTicketId].ticketNumber=nextTicketId;
		ticketsRegister[nextTicketId].isAvailable=false;
		ticketsRegister[nextTicketId].concertId=_concertId;
		concertsRegister[_concertId].totalSoldTicket=concertsRegister[_concertId].totalSoldTicket+1;
		ticketsRegister[nextTicketId].owner=ad;
		nextTicketId++;
		ticketNumber=nextArtistId;
	

	}
	
	function useTicket(uint _ticketId) public payable
	{
		require(concertsRegister[ticketsRegister[_ticketId].concertId ].concertDate == now);
		require(ticketsRegister[_ticketId].owner==msg.sender);
		
		ticketsRegister[_ticketId].isAvailable=true;
	}
	
	

	
	function buyTicket(uint _concertId) public payable
	{
		require(msg.value==concertsRegister[_concertId].ticketPrice);
		require(getBalance(msg.sender)>=concertsRegister[_concertId].ticketPrice);
		require(venuesRegister[concertsRegister[_concertId].venueId].capacity>=concertsRegister[_concertId].totalSoldTicket);
		concertsRegister[_concertId].totalMoneyCollected=concertsRegister[_concertId].totalMoneyCollected+msg.value;
		concertsRegister[_concertId].totalSoldTicket=concertsRegister[_concertId].totalSoldTicket+1;
		uint n= emitTicket(_concertId,msg.sender);
		ticketsRegister[n].amountPaid=concertsRegister[_concertId].ticketPrice;
		ticketsRegister[n].isAvailable=true;
		ticketsRegister[n].isAvailableForSale=false;
		ticketsRegister[n].owner=msg.sender;
		ticketsRegister[n].concertId=_concertId;
	}
	
	
	function transferTicket(uint _ticketId, address payable _newOwner) public
	{
		require(ticketsRegister[_ticketId].owner==msg.sender);
		ticketsRegister[_ticketId].owner=_newOwner;
		
	}
	
	
	function getBalance(address owner) public view returns (uint256) {

        require(owner != address(0));
        return address(owner).balance;

    }

}

