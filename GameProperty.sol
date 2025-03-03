// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GameProperty {

    struct UserLandConfiguration {
        uint[] id;
        int256[] crop;
        int256[] land;
    }

    struct LandType {
        uint id;
        bytes32 name;
        bytes32 img;
        uint count;
    }

    mapping(uint => UserLandConfiguration) public userLandConfigurationList;
    LandType[] public landTypeList;

    struct CropList {
        uint[] id;
        bytes32[] name;
        bytes32[] img;
        bytes32[] start;
        bytes32[] end;
        uint[] cropType;
        bool[] ripe;
        uint[] count;
    }

    mapping(uint => CropList) public cropList;

    constructor() {}

    function addCropList(
        uint u_Id,
        bytes32 _name,
        bytes32 _img,
        bytes32 _start,
        bytes32 _end,
        uint _cropType,
        bool _ripe,
        uint _count
    ) public {
        cropList[u_Id].id.push(cropList[u_Id].id.length);
        cropList[u_Id].name.push(_name);
        cropList[u_Id].img.push(_img);
        cropList[u_Id].start.push(_start);
        cropList[u_Id].end.push(_end);
        cropList[u_Id].cropType.push(_cropType);
        cropList[u_Id].ripe.push(_ripe);
        cropList[u_Id].count.push(_count);
    }

    function updateCropList(
        uint u_Id,
        uint p_Id,
        bytes32 _name,
        bytes32 _img,
        bytes32 _start,
        bytes32 _end,
        uint _cropType,
        bool _ripe,
        uint _count
    ) public {
        cropList[u_Id].name[p_Id] = _name;
        cropList[u_Id].img[p_Id] = _img;
        cropList[u_Id].start[p_Id] = _start;
        cropList[u_Id].end[p_Id] = _end;
        cropList[u_Id].cropType[p_Id] = _cropType;
        cropList[u_Id].ripe[p_Id] = _ripe;
        cropList[u_Id].count[p_Id] = _count;
    }

    function updateCropCount(uint u_Id, uint p_Id, uint _count) public {
        cropList[u_Id].count[p_Id] = _count;
    }

    function getCropList(uint u_Id) public view returns (
        uint[] memory, bytes32[] memory, bytes32[] memory, bytes32[] memory,
        bytes32[] memory, uint[] memory, bool[] memory
    ) {
        return (
            cropList[u_Id].id,
            cropList[u_Id].name,
            cropList[u_Id].img,
            cropList[u_Id].start,
            cropList[u_Id].end,
            cropList[u_Id].cropType,
            cropList[u_Id].ripe
        );
    }

    function getCropListCount(uint u_Id) public view returns (uint[] memory) {
        return cropList[u_Id].count;
    }

    function getCropListLength(uint u_Id) public view returns (uint) {
        return cropList[u_Id].id.length;
    }

    function addUserLandConfiguration(uint u_Id, uint landSize) public {
        uint difference = (landSize * landSize) - ((landSize - 1) * (landSize - 1));
        for (uint i = 0; i < difference; i++) {
            userLandConfigurationList[u_Id].id.push(userLandConfigurationList[u_Id].id.length);
            userLandConfigurationList[u_Id].land.push(-1);
            userLandConfigurationList[u_Id].crop.push(-1);
        }
    }

    function updateUserLandConfiguration(uint u_Id, uint c_Id, int256 cropId, int256 landId, bool isLand) public {
        if (isLand) {
            userLandConfigurationList[u_Id].land[c_Id] = landId;
        } else {
            userLandConfigurationList[u_Id].crop[c_Id] = cropId;
        }
    }

    function getUserLandConfiguration(uint u_Id) public view returns (int256[] memory, int256[] memory) {
        return (userLandConfigurationList[u_Id].land, userLandConfigurationList[u_Id].crop);
    }

    function moveUserLandPosition(uint u_Id, uint landSize) public {
        uint length = landSize - 1;
        for (uint i = ((length * length) - 1); i >= length; i--) {
            userLandConfigurationList[u_Id].land[i + (i / length)] = userLandConfigurationList[u_Id].land[i];
            userLandConfigurationList[u_Id].crop[i + (i / length)] = userLandConfigurationList[u_Id].crop[i];
            userLandConfigurationList[u_Id].land[i] = -1;
            userLandConfigurationList[u_Id].crop[i] = -1;
        }
    }

    function addLandType(bytes32 _name, bytes32 _img, uint _count) public {
        landTypeList.push(LandType({id: landTypeList.length, name: _name, img: _img, count: _count}));
    }

    function getLandType(uint l_Id) public view returns (bytes32, uint, bytes32, uint) {
        return (
            landTypeList[l_Id].name,
            landTypeList[l_Id].id,
            landTypeList[l_Id].img,
            landTypeList[l_Id].count
        );
    }
 function equal(string memory _a, string memory _b) public pure returns (bool) {
        return keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b));
    }

    /// @dev Finds the lexicographical comparison of two strings.
    /// @return -1 if `_a` is smaller, 1 if `_b` is smaller, 0 if they are equal.
    function compare(string memory _a, string memory _b) public pure returns (int8) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length < b.length ? a.length : b.length;

        for (uint i = 0; i < minLength; i++) {
            if (a[i] < b[i]) return -1;
            if (a[i] > b[i]) return 1;
        }
        
        if (a.length < b.length) return -1;
        if (a.length > b.length) return 1;
        return 0;
    }

    /// @dev Finds the index of the first occurrence of `_needle` in `_haystack`.
    /// @return The index if found, otherwise -1.
    function indexOf(string memory _haystack, string memory _needle) public pure returns (int) {
        bytes memory h = bytes(_haystack);
        bytes memory n = bytes(_needle);
        
        if (h.length == 0 || n.length == 0 || n.length > h.length) return -1;

        for (uint i = 0; i <= h.length - n.length; i++) {
            bool found = true;
            for (uint j = 0; j < n.length; j++) {
                if (h[i + j] != n[j]) {
                    found = false;
                    break;
                }
            }
            if (found) return int(i);
        }
        return -1;
    }
}

