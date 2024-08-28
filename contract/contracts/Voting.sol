//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

pragma solidity >=0.8.2 <0.9.0;

interface ICandidate {
    struct Candidate {
        uint256 candidateId;
        string name;
        address account;
        uint256 age;
        uint256 votes;
        bool isApproved;
        bool isSelected;
    }

    function getCandidates() external view returns (Candidate[] memory);
    function updateVoting(uint256 id) external;
    function approveCandidate(uint256 id) external;
}

contract Voting {
  using Counters for Counters.Counter;
   Counters.Counter public voterId;

    ICandidate candidateContract;

    address public votingOrganizer;

    struct Voter {
        uint256 voterId;
        string name;
        string bio;
        uint256 age;
        address account;
        bool isVoted;
        uint256 votingTime;
        string image;
        string ipfs;
    }

    Voter[] public voters;
    address[] isVotedVoters;
    event VotedCandidate(string message,uint256 candidateId);
    event ApproveCandidate(string message,uint256 candidateId);


       modifier isAlreadyVoter(){
        address user = msg.sender;
        bool isRegister = false;
        for (uint256 i = 0; i < voters.length; i++) {
            if (voters[i].account != user) {
                continue;
            } else {
                isRegister = true;
                break;
            }
        }

        require(isRegister == true, "Voter not registered");
    _;
   }

    modifier isRegisterVoter() {
        address user = msg.sender;
        bool isRegister = false;
        for (uint256 i = 0; i < voters.length; i++) {
            if (voters[i].account != user) {
                continue;
            } else {
                isRegister = true;
                break;
            }
        }

        require(isRegister == false, "Already registered as voter");
        _;
    }

    modifier isVoted() {
        address user = msg.sender;
        bool isVoted = false;
        for (uint256 i = 0; i < voters.length; i++) {
            if (voters[i].account != user) {
                continue;
            } else {
                if (voters[i].isVoted == true) {
                    isVoted = true;
                    break;
                }
            }
        }

        require(isVoted == false, "Voter has already voted!");
        _;
    }

    constructor(address _candidateContract)   {
        votingOrganizer=msg.sender;
        candidateContract = ICandidate(_candidateContract);
    }

    function registerVoter(
        string memory _name,
        string memory _bio,
        uint256 _age
    ) public isRegisterVoter {
        require(_age >= 18, "Person with age below 18 cannot be a voter");
        bool _isVoted = false;
        uint256 timestamp = block.timestamp;
           voterId.increment();
          uint256 _id=voterId.current();
        Voter memory newVoter = Voter(
            _id,
            _name,
            _bio,
            _age,
            msg.sender,
            _isVoted,
            timestamp,
            "",
            ""   
        );
        voters.push(newVoter);
    }

    function approveCandidate(uint256 id) public payable  {
      require(votingOrganizer == msg.sender, "Only the organizer can approve the candidate");

    ICandidate.Candidate[] memory candidates = candidateContract.getCandidates();
    require(id < candidates.length, "Candidate does not exist.");

    candidateContract.approveCandidate(id);
    emit ApproveCandidate("Successfully approved the candidate.", id);
    }

    function getCandidateLength() public view returns(uint256){
    ICandidate.Candidate[] memory candidates = candidateContract.getCandidates();
    return candidates.length;    }

//Vote Candidate
    function voteCandidate(uint256 id) public isAlreadyVoter isVoted {
   
    ICandidate.Candidate[] memory candidates = candidateContract.getCandidates();
    require(id < candidates.length, "Candidate does not exist.");
    
    // Ensure candidate is approved before voting
    require(candidates[id].isApproved, "Candidate is not approved for voting.");

    candidateContract.updateVoting(id);  
    updateVotingStatus();  

    emit VotedCandidate("Successfully voted to candidate.", id);
  
    }

//Update Voting Status
    function updateVotingStatus() private  {
        for (uint256 i = 0; i < voters.length; i++) {
            if (voters[i].account == msg.sender) {
                voters[i].isVoted=true;
            } 
        }
        isVotedVoters.push(msg.sender);
    }

    function getVoterData(uint256 id) external view returns(Voter memory){
        return voters[id];
   }

   function getCandidateContractAddress() public view returns (address) {
    return address(candidateContract);
}
}
