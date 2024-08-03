forge init --force;

forge install vectorized/solady --shallow;

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
