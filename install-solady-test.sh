mkdir -p test;
mkdir -p test/utils;

curl -o test/utils/TestPlus.sol https://raw.githubusercontent.com/Vectorized/solady/main/test/utils/TestPlus.sol;
curl -o test/utils/Brutalizer.sol https://raw.githubusercontent.com/Vectorized/solady/main/test/utils/Brutalizer.sol;

echo "// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import \"forge-std/Test.sol\";
import \"./TestPlus.sol\";

contract SoladyTest is Test, TestPlus {
    /// @dev Alias for \`_hem\`.
    function _bound(uint256 x, uint256 min, uint256 max) internal pure virtual override returns (uint256) {
        return _hem(x, min, max);
    }
}" > test/utils/SoladyTest.sol;
