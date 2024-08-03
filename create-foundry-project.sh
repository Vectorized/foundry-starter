forge init --force;

forge install vectorized/solady --shallow;

rm -rf .github;
mkdir .github;
cp lib/solady/.github/issue_template.md .github/issue_template.md;
cp lib/solady/.github/pull_request_template.md .github/pull_request_template.md;
mkdir .github/workflows;

echo "name: ci

on:
  pull_request:
    branches: [main]
    paths:
      - '**.sol'
      - '**.yml'
  push:
    branches: [main]
    paths:
      - '**.sol'
      - '**.yml'
jobs:
  tests:
    name: Forge Testing
    runs-on: ubuntu-latest

    strategy:
      matrix:
        profile: [regular,intense]

    steps:
      - uses: actions/checkout@v4

      - name: Install Foundry
        uses: foundry-rs/foundry-toolchain@v1
        with:
          version: nightly

      - name: Install Dependencies
        run: forge install

      - name: Run Tests with \${{ matrix.profile }}
        run: >
          ( [ \"\${{ matrix.profile }}\" = \"regular\" ] &&
            forge test
          ) ||
          ( [ \"\${{ matrix.profile }}\" = \"intense\" ] &&
            forge test --fuzz-runs 10000
          )

  codespell:
    runs-on: \${{ matrix.os }}
    strategy:
      matrix:
        os:
          - ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Run codespell
        uses: codespell-project/actions-codespell@v2.0
        with:
          check_filenames: true
          ignore_words_list: usera
          skip: ./.git,package-lock.json,ackee-blockchain-solady-report.pdf,EIP712Mock.sol
" > .github/workflows/ci.yml;


echo "name: ci

on:
  pull_request:
    branches: [main]
    paths:
      - '**.sol'
      - '**.yml'
  push:
    branches: [main]
    paths:
      - '**.sol'
      - '**.yml'
jobs:
  tests:
    name: Forge Testing
    runs-on: ubuntu-latest

    strategy:
      matrix:
        profile: [regular,intense]

    steps:
      - uses: actions/checkout@v4

      - name: Install Foundry
        uses: foundry-rs/foundry-toolchain@v1
        with:
          version: nightly

      - name: Install Dependencies
        run: forge install

      - name: Run Tests with \${{ matrix.profile }}
        run: >
          ( [ \"\${{ matrix.profile }}\" = \"regular\" ] &&
            forge test
          ) ||
          ( [ \"\${{ matrix.profile }}\" = \"intense\" ] &&
            forge test --fuzz-runs 5000
          )

  codespell:
    runs-on: \${{ matrix.os }}
    strategy:
      matrix:
        os:
          - ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Run codespell
        uses: codespell-project/actions-codespell@v2.0
        with:
          check_filenames: true
          ignore_words_list: usera
          skip: ./.git,package-lock.json,ackee-blockchain-solady-report.pdf,EIP712Mock.sol
" > .github/workflows/ci.yml;

echo "name: ci-super-intense

on:
  workflow_dispatch:

jobs:
  tests:
    name: Forge Testing super intense
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        profile: [super-intense-0,super-intense-1]

    steps:
      - uses: actions/checkout@v4

      - name: Install Foundry
        uses: foundry-rs/foundry-toolchain@v1
        with:
          version: nightly

      - name: Install Dependencies
        run: forge install

      - name: Run Tests with \${{ matrix.profile }}
        run: >
          ( [ \"\${{ matrix.profile }}\" = \"super-intense-0\" ] &&
            forge test --fuzz-runs 20000
          ) ||
          ( [ \"\${{ matrix.profile }}\" = \"super-intense-1\" ] &&
            forge test --fuzz-runs 200000
          )
" > .github/workflows/ci-super-intense.yml;

echo "name: ci-invariant-intense

on:
  workflow_dispatch:

jobs:
  tests:
    name: Forge Testing invariant intense
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        profile: [invariant-intense-0,invariant-intense-1,invariant-intense-2,invariant-intense-3]

    steps:
      - uses: actions/checkout@v4

      - name: Install Foundry
        uses: foundry-rs/foundry-toolchain@v1
        with:
          version: nightly

      - name: Install Dependencies
        run: forge install

      - name: Run Tests with \${{ matrix.profile }}
        run: FOUNDRY_INVARIANT_RUNS=500 FOUNDRY_INVARIANT_DEPTH=500 forge test
" > .github/workflows/ci-invariant-intense.yml;

mkdir test/utils;
cp lib/solady/test/utils/TestPlus.sol test/utils/TestPlus.sol;
cp lib/solady/test/utils/Brutalizer.sol test/utils/Brutalizer.sol;

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

echo "// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
" > src/Counter.sol;

echo "// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import \"./utils/SoladyTest.sol\";
import {Counter} from \"../src/Counter.sol\";

contract CounterTest is SoladyTest {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testSetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
" > test/Counter.t.sol;

echo "// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Script, console} from \"forge-std/Script.sol\";
import {Counter} from \"../src/Counter.sol\";

contract CounterScript is Script {
    Counter public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new Counter();

        vm.stopBroadcast();
    }
}
" > script/Counter.s.sol;

echo "# Foundry Configuration File
# Default definitions: https://github.com/gakonst/foundry/blob/b7917fa8491aedda4dd6db53fbb206ea233cd531/config/src/lib.rs#L782
# See more config options at: https://github.com/gakonst/foundry/tree/master/config

# The Default Profile
[profile.default]
evm_version = \"cancun\" # Cancun will be tested in the CI.
auto_detect_solc = false
optimizer = true
optimizer_runs = 1_000
gas_limit = 100_000_000 # ETH is 30M, but we use a higher value.

[fmt]
line_length = 100 # While we allow up to 120, we lint at 100 for readability.

[profile.default.fuzz]
runs = 256

[invariant]
depth = 15
runs = 10
" > foundry.toml;

echo "
# NodeJS files
node_modules/
coverage
coverage.json
typechain

# Hardhat files
cache/
artifacts/
cache/
out/

# Ignore Environment Variables!
.env
.env.prod

# Ignore all vscode settings
.vscode/

# Ignore all jetbrain settings
.idea/

# Ignore flattened files
flattened.txt
broadcast
# Coverage
lcov.info

# Woke testing
.wake
pytypes
__pycache__/
*.py[cod]
.hypothesis/
wake-coverage.cov
" > .gitignore;

forge fmt;
