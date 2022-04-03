pragma solidity >=0.5.0 <0.9.0;

contract CrowdFunding{
    mapping(address=>uint) public contributors;
    address public manager;
    uint public minContribution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public nuOfContributors;

    struct Request{
        string description;
        address payable recipent;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voters;
    }
    mapping(uint=>Request) public requests;
    uint public nuOfRequests;
    constructor(uint _target,uint _deadline) public {
        target = _target;
        deadline = block.timestamp + _deadline;
        minContribution = 100 wei;
        manager = msg.sender;
    }
    modifier onlyManager() {
        require(msg.sender == manager, "Only Manager can call this function ");
        _;
    }
    function createRequest(string memory _description,address payable _recipent,uint _value) public onlyManager {
        Request storage newRequest = requests[numRequests];
        numRequests++;
        newRequest.description = _description;
        newRequest.recipent = _recipent;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;  
    }
    function voteRequest(uint _requestNo) public {
        require(contributors[msg.sender] > 0,"You must be a contributor");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.voters[msg.sender]==false,"You have already voted for this request");
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }
    function makePayment(uint _requestNo) public onlyManager{
        require(raisedAmount>=target);
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false ,"This request has been completed");
        require(thisRequest.noOfVoters > nuOfContributors / 2,"Majority does not support the request");
        thisRequest.recipent.transfer(thisRequest.value);
        thisRequest.completed = true;
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
    function refund() public {
        require(block.timestamp > deadline && raisedAmount < target,"You are not eligible for the refund"); 
        require(contributors[msg.sender]>0);
        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender] = 0 ;
    }
    
}