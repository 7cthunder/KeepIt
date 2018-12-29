pragma solidity ^0.4.0;

contract KeepIt {
    // not allow too large group size for considering the gas limit
    uint constant MAXIMUM_GROUP_SIZE = 20;
    
    uint public clockInTime;
    uint public keepDays;
    uint public groupSize;
    uint public startTime;
    bool public isStart = false;
    
    address creator;
    address[] members;
    mapping(address => bool) isMemberOfGroup;
    mapping(address => uint) deposit;
    mapping(address => uint) timesOfClockIn;
    mapping(address => uint) lastClockInTime;
    
    // params:
    // _clockInTime - The time you guys decided to clock in
    // _keepDays - how many days you guys decided to keep clock in
    // _groupSize - size of the group you want, make sure not greater than 20
    constructor (
        uint _clockInTime,
        uint _keepDays,
        uint _groupSize
    ) 
        public 
    {
        require(
            groupSize <= MAXIMUM_GROUP_SIZE,
            "Maximum group size is 20"
        );
        clockInTime = _clockInTime;
        keepDays = _keepDays;
        groupSize = _groupSize;
        creator = msg.sender;
    }
    
    // You can't join in if it has begun
    // You can't join in if it has no places left
    function join() public payable {
        require(
            !isStart,
            "You can't join this group for it has begun!"
        );
        require(
            !isMemberOfGroup[msg.sender],
            "You had joined it!"
        );
        require(
            members.length < groupSize,
            "There are no places left"
        );
        
        members.push(msg.sender);
        isMemberOfGroup[msg.sender] = true;
        deposit[msg.sender] = msg.value;
    }
    
    // You should clockIn before clockInTime
    function clockIn() public returns(bool) {
        uint nowTime = now % 1 days;
        uint clt = (clockInTime % 1 days);
        if (nowTime > clt) return false;
        uint diff = clt - nowTime;
        // maybe it will have about 1 clocks error
        if (diff < 1 hours && isMemberOfGroup[msg.sender]) {
            msg.sender.transfer(deposit[msg.sender] / keepDays);
            lastClockInTime[msg.sender] = now;
            timesOfClockIn[msg.sender] += 1;
            // when first user clock in, this group's state turn to start
            // it means no one can join this group now!
            if (!isStart) {
                isStart = true;
                startTime = now;
            }
            return true;
        }
        return false;
    }
    
    function hasClockIn() public view returns(bool) {
        uint diff = now - lastClockInTime[msg.sender];
        return diff < 23 hours;
    }
    
    function isMember() public view returns(bool) {
        return isMemberOfGroup[msg.sender];
    }
    
    // make sure you are the members of this group
    // and do it after [keepDays] days
    function close() public {
        if (isMemberOfGroup[msg.sender] &&
            now >= startTime + keepDays * 1 days
        )
        {
            address[20] memory tmp;
            uint count = 0;
            for (uint i = 0; i < members.length; ++i) {
                if (timesOfClockIn[members[i]] == keepDays) 
                    tmp[count++] = members[i];
            }
            for (uint j = 0; j < count; ++j) {
                tmp[j].transfer(address(this).balance / count);
            }
            
            selfdestruct(creator);
        }
    }
}