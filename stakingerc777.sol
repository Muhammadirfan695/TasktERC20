// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC777 {
    function burn(uint256 amount, bytes calldata data) external;
    function send(address recipient, uint256 amount , bytes memory  data) external;                                                                                  
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    function transfer(address recipient, uint amount) external returns (bool);
}

contract ReferralSystem {
      struct UserInfo {
        address referrer;
        // uint256 start;
        // uint256 maxDeposit;
        uint256 totalDeposit;
        // uint256 totalDepositAmount;
        // uint256 teamNum;
        uint256 directsNum;
        // uint256 maxDirectDeposit;
        // uint256 teamTotalDeposit;
        // uint256 totalStake_100;
        // uint256 totalStake_200;
        // uint256 totalStake_400;
        // uint256 totalStake_600;
    }
    address public owner;
    ERC777 public token;

    address public defaultRefer; 
    // mapping(address => uint256) public referrals;
    // mapping(uint256 => uint256) public referralRewards; 
    uint256 public totalUser; 
     mapping(address => UserInfo) public userInfo;
    mapping(address => mapping(uint256 => address[])) public teamUsers;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address =>uint256)) public refferalls;
    address[] public referralsList;
    
 
    uint256 private constant referDepth = 6;
    constructor(address _token) {
        owner = msg.sender;
        defaultRefer = 0x352eCa551729265f2011E0c772a3CbBc32a220Fb;
    }


  function register(address _referral) public {
        require(userInfo[_referral].totalDeposit > 0 || _referral == defaultRefer, "invalid refer");
        UserInfo storage user = userInfo[msg.sender];
        require(user.referrer == address(0), "referrer bonded");
        user.referrer = _referral;
        userInfo[user.referrer].directsNum = userInfo[user.referrer].directsNum.add(1);
        _updateTeamNum(msg.sender);
        totalUser = totalUser.add(1);
       
    }

    function _updateTeamNum(address _user) public {
        UserInfo storage user = userInfo[_user];
        address upline = user.referrer;
        for(uint256 i = 0; i < referDepth; i++){
            if(upline != address(0)){
                userInfo[upline].teamNum = userInfo[upline].teamNum.add(1);
                teamUsers[upline][i].push(_user);
                if(upline == defaultRefer) break;
                upline = userInfo[upline].referrer;
            }else{
                break;
            }
        }
    }}

// function stake(uint256 amount, address refferal) external{
//        uint256 refferalPercentage = (refferal);
//        uint256 refferalAmount = amount * refferalPercentage /100;
//        if(refferalAmount > 0){
//           token.send(refferal, refferalAmount, "");
//           refferalls[refferal][msg.sender] += refferalAmount;
//           if(refferalls[refferal][msg.sender]  == refferalAmount){
//               referralsList.push(msg.sender);

//           }
//     }
// }}











//   function stake(uint256 amount, address referral) external {
//         require(amount > 0, "Amount must be greater than zero");
//         require(referral != msg.sender, "Referral cannot be yourself");

//         uint256 referralPercent = _getReferralPercent(referral);

//         uint256 referralAmount = amount * referralPercent / 100;
//         if (referralAmount > 0) {
//             _token.send(referral, referralAmount, "");
//             referrals[referral][msg.sender] += referralAmount;
//             if (referrals[referral][msg.sender] == referralAmount) {
//                 referralsList.push(msg.sender);
//             }
//         }
//    function stake(uint256 amount, address referrer) external {
       
//         token.send(address(this), amount, "");
        
//         for (uint256 i = 1; i <= 6; i++) {
//             if (referrer == address(0)) break;
//             referrals[msg.sender] = i;
//             // token.send(address(this), referrer, amount * referralRewards[i] / 100);
//             token.send(address(this), amount * referralRewards[i] / 100, abi.encodePacked(referrer));
//             referrer = getReferrer(referrer);
//         }
//     }
    
//     function getReferrer(address user) internal view returns (address) {

//         for (uint256 i = 1; i < referrals[user]; i++) {
//             user = getReferrer(user);
//         }
//         return user;
//     }
    
// }

// create a smart ERC777 token staking refferal baseSystem 1st level 5% defult address then rgister ,2nd level 3%, 3rd level 2%, 4th level 1% , 5th level 0.5% and 6 level 0.5 in solidity
// token.send(address(this), referrer, new bytes(0));
// bytes memory data = abi.encodePacked(someData);
// token.send(address(this), referrer, data);
























    // function setReferrer(address referrerAddress) public {
    //     require(referrals[msg.sender] == 0, "Referrer can only be set once");
    //     require(referrerAddress != address(0), "Referrer cannot be 0x0");
    //     require(referrerAddress != msg.sender, "Cannot refer yourself");
    //     require(referrals[referrerAddress] > 0, "Referrer must have at least one referral");
    //     //  referrer[msg.sender] = uint256(referrerAddress);
    //     referrer[msg.sender] = uint256(uint160(referrerAddress));
    // }


    // function withdraw(uint256 amount) public {
    //     require(msg.sender == owner, "Only owner can withdraw");
    //     require(amount <= token.balanceOf(address(this)), "Insufficient balance");

    //     token.send(owner, amount, "");
    // }
// }

// by defualt address staking refferal system smart contract no hard coded value
// stakig refferalsystem base smart contract defult address direct stak amount then  in ERC777 token 
// level 1 to 5%
//  level 2 to 3% 
// level 3  to  2%
// level 4 to 1% 
// level 5 to 0.5% 
// level 6 to 0.5%




// function findReferrer(address _user) public view returns (address) {
//     address currentReferrer = referrer[_user];
//     for (uint256 i = 0; i < referralLevels; i++) {
//         if (currentReferrer == address(0)) {
//             break;
//         }
//         currentReferrer = address(uint160(referrer[currentReferrer])); // cast uint256 to address
//     }
//     return currentReferrer;
// }
