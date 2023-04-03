// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;
contract eventcontract{
    struct allevent{
        address organiser;
        string name;
        uint date;
        uint price;
        uint ticketcount;
        uint ticketremain;
    }
    mapping (uint=>allevent) public events;
    mapping (address=>mapping (uint=>uint)) public tickets;
    uint public nextid;
    function createevent(string memory name,uint date,uint price,uint ticketcount) external{
        require(date>block.timestamp,"you can organise event for future date");
        require(ticketcount>10,"ticket count must be greater than 10");
        events[nextid]=allevent(msg.sender,name,date,price,ticketcount,ticketcount);
        nextid++;
    }
    function buytickets(uint id,uint quantity) external payable{
        require(events[id].date!=0,"event does not exist");
        require(events[id].date>=block.timestamp,"you can buy tickets only for future or present");
        allevent storage _event=events[id];
        require(msg.value==(_event.price*quantity),"ether not enough");
        require(_event.ticketremain>=quantity,"not enough ticket available");
        _event.ticketremain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }
    function transferticket(uint id,uint quantity,address to) external{
        require(events[id].date!=0,"event does not exist");
        require(events[id].date>=block.timestamp,"you can buy tickets only for future or present");
        require(tickets[msg.sender][id]>=quantity,"yoyu do not have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }

}