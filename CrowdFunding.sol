pragma solidity >=0.5.0 <0.9.0;

contract CrowdFunding{
    mapping(address=>uint) public contributors;
    address public manager;
    uint public minContribution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public nuOfContributors;

    constructor(uint _target,uint _deadline) public {
        target = _target;
        deadline = block.timestamp + _deadline;
        minContribution = 100 wei;
        manager = msg.sender;
    }

    function sendEther() public payable{
        require(block.timestamp < deadline,"Deadline has passed");
        require(msg.value >= minContribution,"Minimum contribution is not met");
        if(contributors[msg.sender] == 0){
            nuOfContributors++;
        }
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }
    function getContractBalance() public view returns(uint) {
        return address(this).balance;
    }
}