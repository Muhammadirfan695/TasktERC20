 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
   
}
 contract A  {
   
function transferTokenBalance( IERC20 token,address _to,  uint256 _amount) external {
    require(token.balanceOf(tx.origin) >= _amount, "Insufficient balance");
    token.transferFrom( tx.origin , _to, _amount);
    }
}




































//  from erc token approve token  contract A only Hold the token but trasferToken contract B code in solidity  


































