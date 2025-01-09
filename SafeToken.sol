// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// ERC-20 INTERFACE
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract SafeToken is IERC20 {

// Store these variables on the blockchain
    uint256 private _totalSupply;
    string public name;
    string public symbol;
    uint8 public decimal;

    // Key-value pair of balances
    mapping (address => uint256) public  _balances;
    // Key-value pair of allowances
    mapping (address => mapping (address => uint256)) _allowed;

    constructor () {
        name = "SafeToken";
        symbol = "SAFE";
        decimal = 18;
        _totalSupply = 10000001 * 10 ** decimal;
        _balances[0x90d09F9851dCED120c76c072f9D0A83968a1B2E3] = _totalSupply;
        emit Transfer(address(0), 0x90d09F9851dCED120c76c072f9D0A83968a1B2E3, _totalSupply);
    }

    function totalSupply() external view override returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address account) external view override  returns (uint256){
        return _balances[account];
    }
    function transfer(address recipient, uint256 amount) external override  returns (bool){
        require(amount <= _balances[msg.sender]);
        require(recipient != address(0));
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) external view override returns (uint256){
        return _allowed[owner][spender];
    }
    function approve(address spender, uint256 amount) external override  returns (bool){
        require(spender != address(0));

        _allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint256 amount) external override  returns (bool){
        require(sender != address(0));
        require(amount <= _balances[sender]);
        require(amount <= _allowed[sender][msg.sender]);

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        _allowed[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);
        return true;

    }


}
