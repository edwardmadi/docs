#!/usr/bin bash

# Pre-requisites:
# - foundry (https://getfoundry.sh/)
# - rsync (https://github.com/WayneD/rsync)
# - pnpm (https://pnpm.io)
# - sd (https://github.com/chmln/sd)

# Strict mode: https://gist.github.com/vncsna/64825d5609c146e80de8b1fd623011ca
set -euo pipefail

# Define the reference directory
docs=docs/contracts/v2/reference/core

# Delete the current V2 reference
find $docs -type f -name "*.md" -delete

# cd into sablierhq/v2-core
cd repos/v2-core

# Auto-generate the V2 reference with Forge
forge doc

# Go back to the root
cd ../../

# Copy over the auto-generated files
rsync --archive \
--exclude "README.md" \
--exclude "SUMMARY.md" \
--exclude "SablierV2NFTDescriptor.sol" \
repos/v2-core/docs/src/src/* \
$docs

# Move all Markdown files one level up
find $docs -type f -name "*.md" -execdir mv {} .. \;

# Delete empty *.sol directories
find $docs -type d -empty -delete

# Update the hyperlinks to use the directory structure of this website
sd "src/abstracts/.*\.sol" $docs/abstracts $(find $docs -type f -name "*.md")
sd "src/interfaces/.*\.sol" $docs/interfaces $(find $docs -type f -name "*.md")
sd "src/.*\.sol" $docs $(find $docs -type f -name "*.md")

# Update the hyperlinks for the interface NatSpec references, e.g. {ISablierV2Lockup}
sd "\{I(\w+)\}" "[I\$1]($docs/interfaces/interface.I\$1.md)" $(find $docs -type f -name "*.md")

# Update the hyperlinks for the contract NatSpec references, e.g. {SablierV2LockupLinear}
# Note: this assumes that no abstract contracts will be caught by the regex
sd "\{SablierV2(\w+)\}" "[SablierV2\$1]($docs/contract.SablierV2\$1.md)" $(find $docs -type f -name "*.md")

# Format the docs with Prettier
pnpm prettier --loglevel silent --write $docs

# Remove the italic asterisks added by `forge doc`: https://github.com/foundry-rs/foundry/issues/4540
sd --string-mode "\*" "" $(find $docs -type f -name "*.md")

# Re-format the docs with Prettier
pnpm prettier --loglevel silent --write $docs

# Reorder the contracts in the sidebar
contract=$docs/contract.SablierV2LockupLinear.md
echo "$(echo -en '---\nsidebar_position: 1\n---\n'; cat $contract)" > $contract

contract=$docs/contract.SablierV2LockupPro.md
echo "$(echo -en '---\nsidebar_position: 2\n---\n'; cat $contract)" > $contract

contract=$docs/contract.SablierV2Comptroller.md
echo "$(echo -en '---\nsidebar_position: 3\n---\n'; cat $contract)" > $contract