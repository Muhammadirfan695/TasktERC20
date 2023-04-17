// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;
library SafeMath {
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
       if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint);
    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint);
    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint amount) external returns (bool);
    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint);
    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint amount) external returns (bool);
    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint amount);
    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint amount);
    
}
contract ERC20 {
   using SafeMath for uint256;
   IERC20 public token;
    uint256  public  tokenPrice;
      uint public totalSupply;
      uint256 public constant tokenPerEth = 100;
      mapping(address => uint) public balanceOf;
      mapping(address => mapping(address => uint)) public allowance;
      string public name = "Test";
      string public symbol = "TEST";
      uint8 public decimals = 18;

       function transfer(address recipient, uint amount) external returns (bool){
           balanceOf[msg.sender] -= amount;
           balanceOf[recipient] += amount;
        //    emit Transfer(msg.sender, recipient, amount);
           return true;
       }

 
// function buy() public payable {
//     require(msg.value >= tokenPrice); // check that enough Ether is sent
//     uint tokens = msg.value / tokenPrice; // calculate the number of tokens to be purchased
//     require(address(this).balance >= msg.value); // check that the contract has enough Ether
//     require(balanceOf[msg.sender] + tokens <= totalSupply); // check that the total token supply will not be exceeded
//     balanceOf[msg.sender] += tokens; // update the user's token balance
//     payable(msg.sender).transfer(msg.value); // transfer the Ether to the contract
//     // emit TokenPurchase(msg.sender, tokens, msg.value); // emit an event to notify of the purchase
// }
  
// function buy(uint256 _value) public payable {
//     require(msg.value == _value); // check that the correct amount of Ether is sent
//     uint256 tokens = _value.div(tokenPrice); // calculate the number of tokens to be purchased
//     require(balanceOf[msg.sender].add(tokens) <= totalSupply); // check that the total token supply will not be exceeded
//     balanceOf[msg.sender] = balanceOf[msg.sender].add(tokens); // update the user's token balance
//     payable(msg.sender).transfer(_value); // transfer the Ether to the contract
//     // emit TokenPurchase(msg.sender, tokens, _value); // emit an event to notify of the purchase
// }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        // emit Approval(msg.sender, spender, amount);
        return true;
    }
    function transferFrom(
        address sender,
        address recipient, 
        uint256 amount
    ) external returns (bool){
     allowance[sender][msg.sender] -= amount;
     balanceOf[sender] -= amount;
     balanceOf[recipient] += amount;
        // emit Transfer(sender, recipient, amount);
        return true;
}
  function mint(uint amount) external {
      balanceOf[msg.sender] += amount;
      totalSupply += amount;
    //   emit Transfer(address(0), msg.sender, amount);
  }
  function burn(uint amount) external{
         balanceOf[msg.sender] -= amount;
      totalSupply -= amount;
    //   emit Transfer(msg.sender,address(0), amount);
  }
}




//     function buy() public payable {
//     require(msg.value > 0, " send some eth to pay token");
//     address user = msg.sender;
//     uint256 ethAmount = msg.value;
//     uint256 tokenAmount = ethAmount * tokenPerEth;

//     payable(msg.sender).trasfer(user, tokenAmount);
//     // require(sent, "Failed");
//     emit BuyToken(user, ethAmount, tokenAmount);

// }
