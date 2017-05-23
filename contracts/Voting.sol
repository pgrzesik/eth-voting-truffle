pragma solidity ^0.4.6;

contract Voting {
    struct voter {
        address voterAddress;
        uint tokensBought;
        uint[] tokensUsedPerCandidate;
    }

    mapping (bytes32 => uint) public votesReceived;
    mapping (address => voter) public voterInfo;

    bytes32[] public candidateList;
    uint public totalTokens;
    uint public balanceTokens;
    uint public tokenPrice;

    function Voting(uint _totalTokens, uint _tokenPrice, bytes32[] _candidateList) {
        candidateList = _candidateList;
        totalTokens = _totalTokens;
        balanceTokens = _totalTokens;
        tokenPrice = _tokenPrice;
    }

    function totalVotesForCandidate(bytes32 candidate) constant returns (uint) {
        return votesReceived[candidate];
    }

    function voteForCandidate(bytes32 candidate, uint votesInTokens) {
        uint index = indexOfCandidate(candidate);
        if (index == uint(-1)) {
            throw;
        }

        if (voterInfo[msg.sender].tokensUsedPerCandidate.length == 0) {
            for(uint i; i < candidateList.length; i++) {
                voterInfo[msg.sender].tokensUsedPerCandidate.push(0);
            }
        }

        uint availableTokens = voterInfo[msg.sender].tokensBought - totalTokensUsed(voterInfo[msg.sender].tokensUsedPerCandidate);
        if (availableTokens < votesInTokens) {
            throw;
        }

        votesReceived[candidate] += votesInTokens;
        voterInfo[msg.sender].tokensUsedPerCandidate[index] += votesInTokens;
    }

    function buy() payable returns (uint) {
        uint tokensToBuy = msg.value / tokenPrice;
        if (tokensToBuy > balanceTokens) {
            throw;
        }
        voterInfo[msg.sender].voterAddress = msg.sender;
        voterInfo[msg.sender].tokensBought += tokensToBuy;
        balanceTokens -= tokensToBuy;
        return tokensToBuy;
    }

    function tokensSold() constant returns (uint) {
        return totalTokens - balanceTokens;
    }

    function voterDetails(address user) constant returns (uint, uint[]) {
        return (voterInfo[user].tokensBought, voterInfo[user].tokensUsedPerCandidate);
    }

    function transferTo(address account) {
        if (!account.call.value(this.balance)()) {
            throw;
        }
    }

    function allCandidates() constant returns (bytes32[]) {
        return candidateList;
    }



    function indexOfCandidate(bytes32 candidate) constant returns (uint) {
        for (uint i; i < candidateList.length; i++) {
            if (candidateList[i] == candidate){
                return i;
            }
        }
        return uint(-1);
    }

    function totalTokensUsed(uint[] _tokensUsedPerCandidate) private constant returns (uint) {
        uint total = 0;
        for (uint i; i < _tokensUsedPerCandidate.length; i++) {
            total += _tokensUsedPerCandidate[i];
        }
        return total;
    }

}