// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract Lottery
{
    address public Manager;
    address payable[] public Participants;

    constructor()
    {
        Manager=msg.sender;
    }

    receive() payable external
    {
        require(msg.value ==  1 ether);
        Participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint)
    {
        require(msg.sender == Manager);
        return address(this).balance;
    }

    function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,Participants.length)));
    }

    function SelectWinner() public
    {
        require(msg.sender == Manager);
        require(Participants.length >= 5);
        uint RandomWinner = random();
        address payable Winner;
        uint indexposition = RandomWinner % Participants.length;
        Winner = Participants[indexposition];
        Winner.transfer(getBalance());
        Participants = new address payable[](0);
    }
}
