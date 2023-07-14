// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";

contract CoinFlip is VRFV2WrapperConsumerBase {
    address constant linkAddress = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    address constant VRFAddress = 0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed;
    uint128 constant entryFees = 0.001 ether;
    uint32 constant callBackGasLimit = 1_000_000;
    uint16 constant numWords = 1;
    uint16 constant requestConfirmation = 3;

    event CoinFlipRequest(uint256 requested);
    event CoinFlipResult(uint256 requestId, bool didWin);

    enum CoinFlipSelection {
        HEADS,
        TAILS
    }
    CoinFlipSelection public choice;

    struct CoinFlipStatus {
        uint256 fees;
        uint256 randomWord;
        address player;
        bool didWin;
        bool fullfilled;
        CoinFlipSelection CoinFlipSelection;
    }

    constructor() payable VRFV2WrapperConsumerBase(linkAddress, VRFAddress) {}

    mapping(uint256 => CoinFlipStatus) public statuses;

    function flip(CoinFlipSelection) external payable returns (uint256) {
        require(msg.value == entryFees, "Didn't pay the minimum");

        uint256 requestId = requestRandomness(
            callBackGasLimit,
            requestConfirmation,
            numWords
        );

        statuses[requestId] = CoinFlipStatus({
            fees: VRF_V2_WRAPPER.calculateRequestPrice(callBackGasLimit),
            randomWord: 0,
            player: msg.sender,
            didWin: false,
            fullfilled: false,
            CoinFlipSelection: choice
        });

        emit CoinFlipRequest(requestId);
        return requestId;
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        require(statuses[requestId].fees > 0, "Request not found");

        statuses[requestId].fullfilled = true;
        statuses[requestId].randomWord = randomWords[0];

        CoinFlipSelection result = CoinFlipSelection.HEADS;
        if (randomWords[0] % 2 == 0) {
            result = CoinFlipSelection.TAILS;
        }

        if (statuses[requestId].CoinFlipSelection == result) {
            statuses[requestId].didWin = true;
            payable(statuses[requestId].player).transfer(entryFees * 2);
        }
        emit CoinFlipResult(requestId, statuses[requestId].didWin);
    }

    function getStatus(
        uint256 requestId
    ) public view returns (CoinFlipStatus memory) {
        return statuses[requestId];
    }
}
