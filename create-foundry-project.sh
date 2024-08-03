

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
