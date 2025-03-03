// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Congress {
    function deleteMatchesId(uint256, uint256) external;
    function updateGuardMatchId(uint256, int256) external;
    function insertMatchesId(uint256, uint256) external;
    function updateGuardId(uint256, uint256) external;
    function updateFarmerId(uint256, uint256) external;
}

interface UsingProperty {
    function getPropertyType_Matchmaking(uint256) external view returns (uint256);
    function getPropertyTypeLength() external view returns (uint256);
    function updateTradingStatus(uint256, bool) external;
    function updateOwnershipStatus(uint256, uint256) external;
    function checkTradeable(uint256) external view returns (uint256);
}

contract Matchmaking {
    Congress public congress;
    UsingProperty public property;

    uint256 public floatOffset = 1000;
    uint256 public matchMakingThreshold = 500;
    uint256 public matchMakingInterval = 1800;
    uint256 public matchesConfirmThreshold = 2;

    struct Match {
        uint256 id;
        uint256[] visitedOwners;
        uint256[] visitedProperties;
        uint256[] visitedTradeable;
        bool[] confirmed;
        int256[] visitedPriorities;
        uint256[] confirmation;
        uint256 visitedCount;
        string result;
    }

    Match[] public matches;

    constructor(address _congressAddress, address _propertyAddress) {
        require(_congressAddress != address(0), "Invalid Congress address");
        require(_propertyAddress != address(0), "Invalid Property address");

        congress = Congress(_congressAddress);
        property = UsingProperty(_propertyAddress);
    }

    function getMatchMaking(uint256 m_Id)
        external
        view
        returns (
            int256[] memory,
            uint256[] memory,
            uint256[] memory,
            uint256[] memory,
            uint256[] memory,
            uint256,
            string memory
        )
    {
        Match storage m = matches[m_Id];
        return (
            m.visitedPriorities,
            m.visitedOwners,
            m.visitedProperties,
            m.visitedTradeable,
            m.confirmation,
            m.visitedCount,
            m.result
        );
    }

    function getMatchMakingConfirmed(uint256 m_Id, uint256 s_Id) external view returns (bool) {
        return matches[m_Id].confirmed[s_Id];
    }

    function updateConfirmation(uint256 m_Id, uint256 s_Id, uint256 confirmation) external {
        require(m_Id < matches.length, "Invalid match ID");
        require(confirmation == 0 || confirmation == 1, "Invalid confirmation value");

        uint256 s_Index;
        for (uint256 i = 0; i < matches[m_Id].visitedOwners.length; i++) {
            if (matches[m_Id].visitedOwners[i] == s_Id) {
                s_Index = i;
                break;
            }
        }
        matches[m_Id].confirmation[s_Index] = confirmation;
        matches[m_Id].confirmed[s_Index] = true;
    }

    function getMatchMakingLength() external view returns (uint256) {
        return matches.length;
    }

    function gameCoreMatchingInit(uint256 _matchId, uint256 _visitedCount, string memory _result) external {
        matches.push();
        matches[_matchId].id = _matchId;
        matches[_matchId].visitedCount = _visitedCount;
        matches[_matchId].result = _result;
    }

    function gameCoreMatchingDetail(uint256 _matchId, int256 _priority, uint256 _owner, uint256 _property) external {
        require(_matchId < matches.length, "Invalid match ID");

        Match storage m = matches[_matchId];

        m.visitedPriorities.push(_priority);
        m.visitedOwners.push(_owner);
        m.visitedProperties.push(_property);

        for (uint256 i = 0; i < m.visitedOwners.length; i++) {
            m.confirmation.push(1);
            m.confirmed.push(false);
            property.updateTradingStatus(m.visitedProperties[i], true);
        }

        for (uint256 k = 0; k < m.visitedOwners.length - 1; k++) {
            congress.insertMatchesId(m.visitedOwners[k], _matchId);
        }

        for (uint256 l = 0; l < m.visitedProperties.length; l++) {
            m.visitedTradeable.push(property.checkTradeable(m.visitedProperties[l]));
        }
    }
}
