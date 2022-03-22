// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable{


    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    event VoterRegistered(address voterAddress); 
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted (address voter, uint proposalId);


    WorkflowStatus private currentWorkflowStatus = WorkflowStatus.RegisteringVoters;
    uint private winningProposalId;
    mapping(address => Voter) private voters;
    address[] private registeredAddress;
    Proposal[] public proposals;

    function authorize(address _address) external onlyOwner {
        require(currentWorkflowStatus == WorkflowStatus.RegisteringVoters, "Autorize Voter is no loonger possible");
        bool alreadyisRegistered = isRegistered(_address);
        require(!alreadyisRegistered, "Voter already registered");
        registeredAddress.push(_address);
        voters[_address] = Voter(true, false, 0);
        emit VoterRegistered(_address);
    }

    function removeVoter(address _address) external onlyOwner {
        require(currentWorkflowStatus == WorkflowStatus.RegisteringVoters, "Autorize Voter is no loonger possible");
        voters[_address].isRegistered = false;
    }

    function getWinner() external view returns (Proposal memory) {
        require(currentWorkflowStatus == WorkflowStatus.VotesTallied, "Votes are not tallied");
        require(winningProposalId >= 0, "No winner can be found");
        return proposals[winningProposalId];
    } 

    function isRegistered(address _address) private view returns (bool) {
        return voters[_address].isRegistered;
    }
   
    function startProposalsRegistration() external onlyOwner {
        require(currentWorkflowStatus == WorkflowStatus.RegisteringVoters, "Autorize Voter is no loonger possible");
        changeWorkflowStatus(currentWorkflowStatus, WorkflowStatus.ProposalsRegistrationStarted);
    }

    function addProposal(string memory _description) external {
        require(isRegistered(msg.sender), "Unauthorized User");
        require(currentWorkflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "The proposal session has not started");
        proposals.push(Proposal(_description, 0));
        emit ProposalRegistered(proposals.length);
    }

    function stopProposalsRegistration() external onlyOwner {
        require(registeredAddress.length > 0, "Nobody has registered");
        require(currentWorkflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "Proposals Registration is not started");
        changeWorkflowStatus(currentWorkflowStatus, WorkflowStatus.ProposalsRegistrationEnded);
    }

    function startVotingSession() external onlyOwner {
        require(currentWorkflowStatus == WorkflowStatus.ProposalsRegistrationEnded, "Proposals Registration is not ended");
        changeWorkflowStatus(currentWorkflowStatus, WorkflowStatus.VotingSessionStarted);
    }

    function voteForProposal(uint proposalId) external {
        require(currentWorkflowStatus == WorkflowStatus.VotingSessionStarted, "Proposals Registration is not started");
        require(isRegistered(msg.sender), "Voter not registered");
        require(!voters[msg.sender].hasVoted, "You have already voted");
        require(proposalId < proposals.length, "Unknow proposalId");
        voters[msg.sender] = Voter(true, true, proposalId);
        proposals[proposalId].voteCount = proposals[proposalId].voteCount + 1;
        emit Voted(msg.sender, proposalId);
    }

    function endVotingSession() external onlyOwner {
        require(currentWorkflowStatus == WorkflowStatus.VotingSessionStarted, "Proposals Registration is not started");
        changeWorkflowStatus(currentWorkflowStatus, WorkflowStatus.VotingSessionEnded);
    }

    function count() external onlyOwner {
        require(currentWorkflowStatus == WorkflowStatus.VotingSessionEnded, "Proposals Registration is not ended");

        int maxIndexFound = findMaxIntoArray(proposals);
        if(maxIndexFound > 0) {
            winningProposalId = uint(maxIndexFound);
            changeWorkflowStatus(currentWorkflowStatus, WorkflowStatus.VotesTallied);
        }
    }

    function changeWorkflowStatus(WorkflowStatus _previousStatus, WorkflowStatus _newStatus) private onlyOwner {
        currentWorkflowStatus = _newStatus;
        emit WorkflowStatusChange(_previousStatus, _newStatus);
    }

    function findMaxIntoArray(Proposal[] memory _array) private pure returns(int)  {
        uint maxValue = 0;
        int maxIndex = -1;
        for (uint index = 0 ; index < _array.length; index++) {
            if(_array[index].voteCount > maxValue) {
                maxValue = _array[index].voteCount;
                maxIndex = int(index);
            }
        }
        return maxIndex;
    }

    function getVote(address _address) external view returns(uint){
        return voters[_address].votedProposalId;
    }
}