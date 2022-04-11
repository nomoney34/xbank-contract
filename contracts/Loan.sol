// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Loan {
    address payable public lender;
    address payable public borrower;

    address public xcoin;

    uint public collateral;
    uint public payoff;
    uint public dueDate;

    constructor (address payable _lender, address payable _borrower, address _xcoin, uint _collateral, uint _payoff, uint loanPeriod){
        lender = _lender;
        borrower = _borrower;
        xcoin = _xcoin;
        collateral = _collateral;
        payoff = _payoff;
        dueDate = block.timestamp + loanPeriod;

    }

    function payLoan() public payable {
        require(block.timestamp <= dueDate, "Prea tarziu, acum iti vrem si casa si nevasta.");
        require(msg.value == payoff, "The amount sent is too low, be careful as we might require your soul as payment.");

        require(IERC20(xcoin).transfer(borrower, collateral));

        selfdestruct(lender);
    }

    function repossess() public {
        require(block.timestamp > dueDate, "Date hasn't been yet due.");
        require(IERC20(xcoin).transfer(lender, collateral));

        selfdestruct(lender);
    }
}