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


    WorkflowStatus internal currentWorkflowStatus = WorkflowStatus.RegisteringVoters;
    uint private winningProposalId;
    mapping(address => Voter) voters;
    address[] private registeredAddress;
    Proposal[] private proposals;

    function addVoter(address _address) public onlyOwner {
        require(currentWorkflowStatus == WorkflowStatus.RegisteringVoters, "Autorize Voter is no loonger possible");
        bool alreadyisRegistered = isRegistered(_address);
        require(!alreadyisRegistered, "Voter already registered");
        registeredAddress[registeredAddress.length] = _address;
        voters[_address] = Voter(true, false, 0);
        emit VoterRegistered(_address);
    }

    function removeVoter(address _address) public onlyOwner {
        require(currentWorkflowStatus == WorkflowStatus.RegisteringVoters, "Autorize Voter is no loonger possible");
        voters[_address].isRegistered = false;
    }

    function getWinner() public view returns (Proposal memory) {
        require(currentWorkflowStatus == WorkflowStatus.VotesTallied, "Votes are not tallied");
        require(winningProposalId >= 0, "No winner can be found");
        return proposals[winningProposalId];
    } 

    function isRegistered(address _address) public view returns (bool) {
        return voters[_address].isRegistered;
    }
   
    function startProposalsRegistration() public onlyOwner {
        require(currentWorkflowStatus == WorkflowStatus.RegisteringVoters, "Autorize Voter is no loonger possible");
        changeWorkflowStatus(currentWorkflowStatus, WorkflowStatus.ProposalsRegistrationStarted);
    }

    function addProposal(string memory _description) public {
        require(currentWorkflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "The proposal session has not started");
        proposals.push(Proposal(_description, 0));
    }

    function stopProposalsRegistration() public onlyOwner {
        require(registeredAddress.length > 0, "Nobody has registered");
        require(currentWorkflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "Proposals Registration is not started");
        changeWorkflowStatus(currentWorkflowStatus, WorkflowStatus.ProposalsRegistrationEnded);
    }

    function startVotingSession() public onlyOwner {
        require(currentWorkflowStatus == WorkflowStatus.ProposalsRegistrationEnded, "Proposals Registration is not ended");
        changeWorkflowStatus(currentWorkflowStatus, WorkflowStatus.VotingSessionStarted);
    }

    function voteForProposal(uint proposalIndex) public {
        require(currentWorkflowStatus == WorkflowStatus.VotingSessionStarted, "Proposals Registration is not started");
        bool alreadyisRegistered = isRegistered(msg.sender);
        require(alreadyisRegistered, "Voter not registered");
        require(!voters[msg.sender].hasVoted, "You have already voted");
        voters[msg.sender] = Voter(true, true, proposalIndex);
        emit Voted(msg.sender, proposalIndex);
    }

    function endVotingSession() public onlyOwner {
        require(currentWorkflowStatus == WorkflowStatus.VotingSessionStarted, "Proposals Registration is not started");
        changeWorkflowStatus(currentWorkflowStatus, WorkflowStatus.VotingSessionEnded);
    }

    function count() public onlyOwner {
        require(currentWorkflowStatus == WorkflowStatus.VotingSessionEnded, "Proposals Registration is not ended");
        changeWorkflowStatus(currentWorkflowStatus, WorkflowStatus.VotesTallied);

        uint[] memory proposalCount;
        for (uint index = 0 ; index < registeredAddress.length; index++) {
            if(voters[registeredAddress[index]].isRegistered) {
                uint votedProposalId = voters[registeredAddress[index]].votedProposalId;
                proposalCount[votedProposalId] = proposalCount[votedProposalId] + 1;
            }
        }

        int maxIndexFound = findMaxIntoArray(proposalCount);
        if(maxIndexFound > 0) {
            winningProposalId = uint(maxIndexFound);
        }
    }

    function changeWorkflowStatus(WorkflowStatus _previousStatus, WorkflowStatus _newStatus) private onlyOwner {
        currentWorkflowStatus = _newStatus;
        emit WorkflowStatusChange(_previousStatus, _newStatus);
    }

    function findMaxIntoArray(uint[] memory _array) private pure returns(int)  {
        uint maxValue = 0;
        int maxIndex = -1;
        for (uint index = 0 ; index < _array.length; index++) {
            if(_array[index] > maxValue) {
                maxValue = _array[index];
            }
        }
        return maxIndex;
    }
}