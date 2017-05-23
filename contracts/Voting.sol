pragma solidity ^0.4.6;

contract Voting {
    struct voter {
        address voterAddress;
        uint tokensBought;
        uint[] tokensUsedPerCandidate;
    }

    mapping (bytes32 => uint8) public votesReceived;
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

    function totalVotesFor(bytes32 candidate) returns (uint8) {
        if (validCandidate(candidate) == false) {
            throw;
        }
        return votesReceived[candidate];
    }

    function voteForCandidate(bytes32 candidate) {
        if (validCandidate(candidate) == false) {
            throw;
        }
        votesReceived[candidate] += 1;
    }

    function validCandidate(bytes32 candidate) returns (bool) {
        for (uint i = 0; i < candidateList.length; i++) {
            if (candidateList[i] == candidate) {
                return true;
            }
        }
        return false;
    }
}