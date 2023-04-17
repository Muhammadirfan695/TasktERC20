// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract StakingRewards {
    uint256 public rewardRate;
    mapping(address => uint) public stakedTokens;
    mapping(address => uint) public stakedTimestamps;

    function stake(uint _amount) public {
        require(_amount > 0);
        stakedTokens[msg.sender] = _amount;
        stakedTimestamps[msg.sender] = block.timestamp;
    }

    function calculateReward() public view returns (uint) {
        uint reward = 0;
        uint stakeDuration = block.timestamp - stakedTimestamps[msg.sender];
        reward = stakedTokens[msg.sender] * stakeDuration * rewardRate;
        return reward;
    }

    // function redeem() public {
    //     require(stakedTokens[msg.sender] > 0);
    //     uint reward = calculateReward();
    //     msg.sender.transfer(reward);
    //     stakedTokens[msg.sender] = 0;
    //     stakedTimestamps[msg.sender] = 0;
    // }
}
