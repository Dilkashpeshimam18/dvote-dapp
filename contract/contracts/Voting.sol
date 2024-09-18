//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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

    function updateVoting(uint256 id) external returns (address);

    function approveCandidate(uint256 id) external;
    function deleteCandidate(address _candidate) external;
}

contract Dvote {
    using Counters for Counters.Counter;
    Counters.Counter public voterId;

    ICandidate candidateContract;
    IERC20 public dvoteCoin;

    address public votingOrganizer;
    bool public votingEnded = false;

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
        address votedTo;
    }

    Voter[] public voters;
    address[] isVotedVoters;
    uint256 public totalEthCollected = 0;

    event VotedCandidate(string message, uint256 candidateId);
    event ApproveCandidate(string message, uint256 candidateId);
    event EthTransferredToTopCandidate(
        string message,
        address topCandidate,
        uint256 amount
    );
    event RegisterVoter(string message, uint256 voterId);

    modifier isAlreadyVoter() {
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
        bool voted = false;
        for (uint256 i = 0; i < voters.length; i++) {
            if (voters[i].account != user) {
                continue;
            } else {
                if (voters[i].isVoted == true) {
                    voted = true;
                    break;
                }
            }
        }

        require(voted == false, "Voter has already voted!");
        _;
    }

    modifier hasEnoughDvoteCoin() {
        require(
            dvoteCoin.balanceOf(msg.sender) >= 1 * 10**18,
            "You need at least 1 dvoteCoin to vote."
        );
        _;
    }

    constructor(address _candidateContract, address _dvoteCoinAddress) {
        votingOrganizer = msg.sender;
        candidateContract = ICandidate(_candidateContract);
        dvoteCoin = IERC20(_dvoteCoinAddress);
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
        uint256 _id = voterId.current();
        Voter memory newVoter = Voter(
            _id,
            _name,
            _bio,
            _age,
            msg.sender,
            _isVoted,
            timestamp,
            "",
            "",
            address(0) // Default value for votedTo
        );
        voters.push(newVoter);
        emit RegisterVoter("Voter registered successfully", _id);
        uint256 contractBalance = dvoteCoin.balanceOf(address(this));
        require(
            contractBalance >= 1 * 10**18,
            "Insufficient contract balance."
        );
        require(
            dvoteCoin.transfer(msg.sender, 1 * 10**18),
            "Failed to transfer dvoteCoin to voter"
        );
    }

    //aprove candidate
    function approveCandidate(uint256 id) public payable {
        require(
            votingOrganizer == msg.sender,
            "Only the organizer can approve the candidate"
        );

        ICandidate.Candidate[] memory candidates = candidateContract
            .getCandidates();
        require(id < candidates.length, "Candidate does not exist.");

        candidateContract.approveCandidate(id);
        emit ApproveCandidate("Successfully approved the candidate.", id);
    }

    function getCandidateLength() public view returns (uint256) {
        ICandidate.Candidate[] memory candidates = candidateContract
            .getCandidates();
        return candidates.length;
    }

    //Vote Candidate
    function voteCandidate(uint256 id) public isAlreadyVoter isVoted {
        ICandidate.Candidate[] memory candidates = candidateContract
            .getCandidates();
        require(id < candidates.length, "Candidate does not exist.");

        // Ensure candidate is approved before voting
        require(
            candidates[id].isApproved,
            "Candidate is not approved for voting."
        );
        require(
            dvoteCoin.transferFrom(msg.sender, address(this), 1 * 10**18),
            "Failed to transfer dvoteCoin for voting"
        );

        address candidateAddress = candidateContract.updateVoting(id);
        updateVotingStatus(candidateAddress);

        emit VotedCandidate("Successfully voted to candidate.", id);
    }

    //Update Voting Status
    function updateVotingStatus(address _votedTo) private {
        for (uint256 i = 0; i < voters.length; i++) {
            if (voters[i].account == msg.sender) {
                voters[i].isVoted = true;
                voters[i].votedTo = _votedTo; // Update the votedTo field
            }
        }
        isVotedVoters.push(msg.sender);
    }

    function getVoterData(address _user) external view returns (Voter memory) {
        Voter memory singleVoter;
        for (uint256 i = 0; i < voters.length; i++) {
            if (voters[i].account == _user) {
                singleVoter = voters[i];
            }
        }

        return singleVoter;
    }

    function getCandidateContractAddress() public view returns (address) {
        return address(candidateContract);
    }

    function resetContract(address _candidate) public {
        require(
            msg.sender == votingOrganizer,
            "Only the organizer can reset the contract."
        );
        require(votingEnded, "Voting is still ongoing.");

        // Reset voters and isVotedVoters arrays
        delete voters;
        delete isVotedVoters;

        // Reset voterId counter
        voterId.reset();
        candidateContract.deleteCandidate(_candidate);

        // Reset the votingEnded flag
        votingEnded = false;
    }

    function transferTokenToTopCandidate() public {
        require(
            msg.sender == votingOrganizer,
            "Only the organizer can execute this."
        );
        require(
            totalEthCollected > 0,
            "No ETH collected from candidate registration."
        );

        ICandidate.Candidate[] memory candidates = candidateContract
            .getCandidates();
        require(candidates.length > 0, "No candidates available.");

        address topCandidate = address(0);
        uint256 highestVote = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].votes > highestVote) {
                highestVote = candidates[i].votes;
                topCandidate = candidates[i].account;
            }
        }

        require(topCandidate != address(0), "No top candidate found.");

        uint256 totalBalance = address(this).balance;
        require(totalBalance > 0, "Insufficient contract balance.");
        uint256 halfBalance = totalBalance / 2;
        payable(topCandidate).transfer(halfBalance);

        // Transfer all the ETH in the contract to the top candidate
        votingEnded = true; // Set voting as ended

        emit EthTransferredToTopCandidate(
            "Successfully transferred ETH to the top candidate.",
            topCandidate,
            totalBalance
        );

        resetContract(topCandidate);
    }

    function checkContractBalance() public view returns (uint256) {
        return dvoteCoin.balanceOf(address(this));
    }

    receive() external payable {
        totalEthCollected += msg.value; // Track the ETH collected
    }
}
