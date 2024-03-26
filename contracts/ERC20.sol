// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "../contracts/interface/IERC20.sol";

contract ERC20 is IERC20  {
        string name;

        string symbol;

        uint8 decimal;

        address owner; 

        uint256 totalSupply;

        mapping(address => uint256) balances;

        mapping(address => mapping(address => uint256)) allowances;

        constructor(string memory _name, string memory _symbol, uint8 _decimals){

            name = _name;

            symbol = _symbol;

            owner = msg.sender;

            decimal = _decimals;

        }

     

     function onlyOwner() private view {
        require(
            msg.sender ==owner,
            "Only Onwer can perform this transaction"
        );
    }

 
    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view  returns (uint256) {
        return balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `value`.
     */
    function transfer(
        address _to,
        uint256 _value
    ) public  returns (bool) {
        require(
            msg.sender != address(0),
            "Address zero cannot make a transfer"
        );
        require(
        balances[msg.sender] > _value,
            "You don't have enough balance"
        );
        balances[msg.sender] =balances[msg.sender] - _value;
        balances[_to] =balances[_to] + _value;
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(
        address _owner,
        address _spender
    ) public view  returns (uint256) {
        return allowances[_owner][_spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `value` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
        require(
        balances[msg.sender] >= _value,
            "You don't have enough token to allocate"
        );
        allowances[msg.sender][_spender] = _value;
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the ERC. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `value`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `value`.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        require(_from != address(0), "Address zero cannot make a transfer");
        require(_from != _to, "You can't transfer to yourself");
        require(
        allowances[_from][_to] >= _value,
            "You allocation is not enough, Message the owner for more allocations"
        );
        balances[_from] =balances[_from] - _value;
        allowances[_from][_to] =allowances[_from][_to] - _value;
        balances[_to] =balances[_to] + _value;
        return true;
    }

    /**
     * @dev Creates a `value` amount of tokens and assigns them to `account`, by transferring it from address(0).
     * Relies on the `_update` mechanism
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * NOTE: This function is not , {_update} should be overridden instead.
     */
    function mint(address _to, uint256 _value) external {

        require(_to != address(0), "Invalid address");

        require(totalSupply + _value >= totalSupply, "Overflow error");

        balances[_to] =balances[_to] + _value;

        totalSupply =totalSupply + _value;
    }
}