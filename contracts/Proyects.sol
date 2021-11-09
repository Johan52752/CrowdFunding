// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Proyects{
    enum FundraisingState {Opened, Closed}
    
    struct Contributtion{
        address contributor;
        uint value;
    }
    struct Proyect {
        string id;
        string nameProyect;
        string description;
        FundraisingState state;
        uint founds;
        uint fundraisingGoal;
        address payable author;
    }
    
    Proyect[] public proyects;
    
    mapping(string=>Contributtion[]) public contributions;
    
    event FundProyect(string _proyectId , uint _value, uint _founds);
    
    event ChangeProyectState(string _proyectId, FundraisingState _newState);
    
    event proyectCreated(string _proyectId, string _nameProyect, string _description, uint fundraisingGoal);
    
    modifier onlyOwnerChangeState(uint index){
        Proyect memory proyect=proyects[index];
        require(proyect.author==msg.sender, "Only owner can change the state");
        _;
    }
    modifier sendFounds(uint index){
        Proyect memory proyect=proyects[index];
        require(proyect.author!=msg.sender, "The owner cant send founds to his proyect");
        _;
    }
    
    function createProyect(string memory _id, string memory _nameProyect, string memory _description, uint _fundraisingGoal)public{
        require(_fundraisingGoal>0,"fundraising goal must be greater than 0");
        Proyect memory proyect=Proyect(_id, _nameProyect, _description, FundraisingState.Opened , 0 , _fundraisingGoal,payable (msg.sender));
        proyects.push(proyect);
        emit proyectCreated( _id, _nameProyect, _nameProyect, _fundraisingGoal);
    }
    
    function fundProyect(uint index) public payable sendFounds(index){
        Proyect memory proyect=proyects[index];
        // 0 is open && 1 is closed
        require(proyect.state == FundraisingState.Opened , "This project is already closed, you cant send founds");
        require(msg.value> 0 , "You need to give a value greater than zero");
        proyect.author.transfer(msg.value);
        proyect.founds += msg.value;
        proyects[index]=proyect;
        contributions[proyect.id].push(Contributtion(msg.sender, msg.value));
        emit FundProyect(proyect.id, msg.value, proyect.founds);
    }
    function changeProyectState(uint index, FundraisingState _newState) public onlyOwnerChangeState(index){
        Proyect memory proyect=proyects[index];
        require(proyect.state != _newState, "You should change the new state, this is the same as the last one");
        proyect.state = _newState;
        proyects[index]=proyect;
        emit ChangeProyectState(proyect.id, _newState);
    }
}