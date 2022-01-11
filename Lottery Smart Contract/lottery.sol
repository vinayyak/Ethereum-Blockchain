//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    
                                       // declaring the state variables
    address payable[] public players; //dynamic array of type address for the players participating in the lottery
    address public manager; 
    
    
    
    constructor(){                       // declaring the constructor
        
        manager = msg.sender;           // initializing the owner to the address that deploys the contract
    }
    
   
    receive () payable external{            // declaring the receive() function that is necessary to receive ETH
         
        require(msg.value == 0.1 ether);   // each player sends exactly 0.1 ETH
        players.push(payable(msg.sender)); // appending the player to the players array
    }
    
         // returning the contract's balance in wei (units of ETH)

    function getBalance() public view returns(uint){
        
        require(msg.sender == manager);       // only the manager is allowed to call it
        return address(this).balance;
    }
    
         // helper function that produces and returns a large random integer

    function random() internal view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    
    
                                    // selecting the winner
    function pickWinner() public{
        
        require(msg.sender == manager);
        require (players.length >= 3); // only the manager can pick a winner if there are at least 3 players in the lottery
        
        uint r = random();
        address payable winner;
        
     
        uint index = r % players.length;    // computing a random index of the array
    
        winner = players[index];           // this is the winner
        
                                         // transferring the entire contract's balance to the winner
        winner.transfer(getBalance());
        
                                           // resetting the lottery for the next round
        players = new address payable[](0);
    }

}

