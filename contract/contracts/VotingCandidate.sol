//SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

pragma solidity >=0.8.2 <0.9.0;

contract DvoteCandidate {
    using Counters for Counters.Counter;

    Counters.Counter public candidateId;
    address public votingOrganizer;

    struct Candidate {
        uint256 candidateId;
        string name;
        address account;
        uint256 age;
        uint256 votes;
        bool isApproved;
        bool isSelected;
    }

    modifier isAlreadyCandidate() {
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
    event CandidateCreated(
        string name,
        address account,
        uint256 age,
        uint256 votes
    );
    event CandidateDeleted(string message, address candidateAddress);
    IERC20 public dvoteCoin;

    constructor(address _dvoteCoinAddress) {
        dvoteCoin = IERC20(_dvoteCoinAddress);
        votingOrganizer = msg.sender;
    }

    function createCandidate(
        string memory _name,
        uint256 _age,
        address payable votingContractAddress
    ) public payable isAlreadyCandidate {
        require(_age >= 18, "Person with age below 18 cannot be a candidate");
        require(
            msg.value == 0.001 ether,
            "0.001 ether is required to be a candidate."
        );

        uint256 initialVote = 0;
        bool isSelected = false;
        address _account = msg.sender;
        candidateId.increment();
        uint256 _id = candidateId.current();
        bool isApproved = false;
        Candidate memory newCandidate = Candidate(
            _id,
            _name,
            _account,
            _age,
            initialVote,
            isApproved,
            isSelected
        );

        candidates.push(newCandidate);
        emit CandidateCreated(_name, _account, _age, initialVote);
        (bool success, ) = votingContractAddress.call{value: msg.value}("");
        require(success, "Transfer to voting contract failed");
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

    function getCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }

    function getApprovedCandidates() public view returns (Candidate[] memory) {
        uint256 approvedCount = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].isApproved) {
                approvedCount++;
            }
        }

        Candidate[] memory approvedCandidates = new Candidate[](approvedCount);
        uint256 count = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].isApproved) {
                approvedCandidates[count] = candidates[i];
                count++;
            }
        }

        return approvedCandidates;
    }

    function updateVoting(uint256 id) public returns (address) {
        require(
            candidates[id].isApproved,
            "This candidate is not yet approved to be voted."
        );
        candidates[id].votes++;
        return candidates[id].account; // Return the candidate's account address
    }

    function approveCandidate(uint256 id) public {
        require(
            candidates[id].isApproved == false,
            "Candidate is already approved."
        );

        candidates[id].isApproved = true;
    }

    function getCandidateData(uint256 id)
        external
        view
        returns (Candidate memory)
    {
        return candidates[id];
    }

    function deleteCandidate(address _candidate) external {
        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].account == _candidate) {
                candidates[i] = candidates[candidates.length - 1];
                candidates.pop();

                break;
            }
        }
        emit CandidateDeleted("Candidate Deleted>>", _candidate);
    }
}
