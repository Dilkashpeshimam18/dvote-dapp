//SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/utils/Counters.sol";

pragma solidity >=0.8.2 <0.9.0;

contract VotingCandidate{
   using Counters for Counters.Counter;

    Counters.Counter public candidateId;

   struct Candidate{
    uint256 candidateId;
    string name;
    address account;
    uint256 age;
    uint256 votes;
    bool isApproved;
    bool isSelected;

   }

   modifier isAlreadyCandidate(){
        address user = msg.sender;
        bool isRegister = false;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].account != user) {
                continue;
            } else {
                isRegister = true;
                break;
            }
        }

        require(isRegister == false, "Already registered as candidate");
    _;
   }

   Candidate[] public candidates;
   event CandidateCreated(string name, address account, uint256 age, uint256 votes);

   function createCandidate(string memory _name, uint256 _age) public payable  isAlreadyCandidate {
    require(_age >= 18 , "Person with age below 18 cannot be a candidate");
    require(msg.value==0.01 ether,"0.01 ether is required to be a candidate.");
    uint256 initialVote=0;
    bool isSelected=false;
    address _account=msg.sender;
    candidateId.increment();
    uint256 _id=candidateId.current();
    bool isApproved=false;
    Candidate memory newCandidate=Candidate(_id,_name,_account,_age,initialVote,isApproved,isSelected);

    candidates.push(newCandidate);
    emit CandidateCreated(_name, _account, _age, initialVote);
   }

   function getCandidates() public view returns (Candidate[] memory){
    return candidates;
   }

    function getApprovedCandidates() public view returns (Candidate[] memory){
    uint256 approvedCount=0;

    for(uint i=0;i<candidates.length;i++){
        if(candidates[i].isApproved){
            approvedCount++;
        }
    }

    Candidate[] memory approvedCandidates=new Candidate[](approvedCount);
    uint256 count=0;

    for(uint i=0;i<candidates.length;i++){
        if(candidates[i].isApproved){
            approvedCandidates[count]=candidates[i];
            count++;

        }
    }

    return approvedCandidates;
    }

   function updateVoting(uint256 id) public   {
    require(candidates[id].isApproved, "This candidate is not yet approved to be voted.");
     candidates[id].votes++;

   }

   function approveCandidate(uint256 id) public {
    require(candidates[id].isApproved==false, "Candidate is already approved.");

      candidates[id].isApproved=true;
   }

   function getCandidateData(uint256 id) external view returns(Candidate memory){
   return candidates[id];
   }
}