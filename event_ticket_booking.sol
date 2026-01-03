//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract EventContract {
    struct Event {
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketcount;
        uint ticketremains;
    }

    // Move these inside the contract
    mapping(uint => Event) public events;
    mapping(address => mapping(uint => uint)) public tickets;
    uint public nextId;

    function createEvents(
        string memory name,
        uint date,
        uint price,
        uint ticketCount
    ) external {
        require(date > block.timestamp, 'Event must be in the future');
        require(ticketCount > 0, 'Ticket count must be > 0');
        events[nextId] = Event(msg.sender, name, date, price, ticketCount, ticketCount);
        nextId++;
    }
    function buyTicket(uint id, uint quantity) external payable{
        require(events[id].date!=0,'event does not exist');
        require(events[id].date!=block.timestamp,'event has aleardy occured');
        Event storage _event = events[id];
        require(msg.value==(events[id].price*quantity),'not enough funds');
        require(_event.ticketremains>=quantity,'not enough tickets');
        _event.ticketremains-=quantity;
        tickets[msg.sender][id]+=quantity;
    }
    function transferTicket(uint id, uint quantity, address to) external{
        require(events[id].date!=0,'event does not exist');
        require(events[id].date>block.timestamp,'event has aleardy occured');
        require(tickets[msg.sender][id]>=quantity,'not enough tickets you have');
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity; 
    }
}