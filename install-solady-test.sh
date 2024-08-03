downloadTest() {
  mkdir -p "$1";
  mkdir -p "$1/utils";

  curl -o "$1/utils/TestPlus.sol" https://raw.githubusercontent.com/Vectorized/solady/main/test/utils/TestPlus.sol;
  curl -o "$1/utils/Brutalizer.sol" https://raw.githubusercontent.com/Vectorized/solady/main/test/utils/Brutalizer.sol;

  echo "// SPDX-License-Identifier: MIT
  pragma solidity ^0.8.4;

  import \"forge-std/Test.sol\";
  import \"./TestPlus.sol\";

  contract SoladyTest is Test, TestPlus {
      /// @dev Alias for \`_hem\`.
      function _bound(uint256 x, uint256 min, uint256 max) internal pure virtual override returns (uint256) {
          return _hem(x, min, max);
      }
  }" > "$1/utils/SoladyTest.sol";

  forge fmt;
}

if [ -d "test" ]; then
  downloadTest("test")
elif [ -d "tests" ]; then
  downloadTest("tests")
else
  echo "No test directory found"
fi
