pragma solidity ^0.7.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract HashedTimeLocked {
    uint256 public startTime;
    uint256 public lockTime = 10 minutes;
    string public secret; //
    bytes32 public secretHash =
        0xfabc158879c351adcbfec2bb04a7cbb883f4a555973dac13fe610424639e30f9;
    address public recipient;
    address public sender;
    uint256 public tokenAmount;
    IERC20 public token;

    constructor(
        address _recipient,
        address _token,
        uint256 _tokenAmount
    ) {
        recipient = _recipient;
        sender = msg.sender;
        tokenAmount = _tokenAmount;
        token = IERC20(_token);
    }

    function deposit() external {
        startTime = block.timestamp;
        token.transferFrom(msg.sender, address(this), tokenAmount);
    }

    function withdraw(string memory _secret) external {
        require(
            keccak256(abi.encodePacked(_secret)) == secretHash,
            "Invalid Secret"
        );
        secret = _secret;
        token.transfer(recipient, tokenAmount);
    }

    function refund() external {
        require(
            block.timestamp > startTime + lockTime,
            "Can't withdraw before locktime"
        );
        token.transfer(sender, tokenAmount);
    }
}

// NOTE: to avoid major bug
//keep in mind the HTLC contract deployed on blockchain
// where the secret's owner will be token recipient
// lock time should be less than that of the HTLC for the user who waits for the secret's owner to withdraw first to get secret
// as it will avoid Secret's owner to withdraw recieving token right before withdrawal time & also get hold of his original token
