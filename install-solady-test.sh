#!/bin/bash

downloadTest() {
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
}

if [ -d "test" ]; then
  downloadTest "test";
elif [ -d "Test" ]; then
  downloadTest "Test";
elif [ -d "tests" ]; then
  downloadTest "tests";
elif [ -d "Tests" ]; then
  downloadTest "Tests";
else
  test_dir=$(find . | grep -v '^./lib' | grep -i '\.t\.sol$' | sort | head -n 1 | xargs -r dirname | cut -d'/' -f2)
  if [ -n "$test_dir" ]; then
    downloadTest "$test_dir";
  else
    test_dir=$(find . | grep -v '^./lib' | grep -i 'Test\.sol$' | sort | head -n 1 | xargs -r dirname | cut -d'/' -f2)
    if [ -n "$test_dir" ]; then
      downloadTest "$test_dir";
    else
      mkdir "test";
      downloadTest "test";
    fi
  fi
fi
