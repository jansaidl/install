#!/bin/sh
# Based on Deno installer: Copyright 2019 the Deno authors. All rights reserved. MIT license.
# TODO(everyone): Keep this script simple and easily auditable.

set -e


if [ "$OS" = "Windows_NT" ]; then
target="win-x64"
else
case $(uname -sm) in
"Darwin x86_64") target="darwin-amd64" ;;
"Darwin arm64") target="darwin-arm64" ;;
*) target="linux-amd64" ;;
esac
fi

if [ $# -eq 0 ]; then
zcli_uri="https://github.com/zeropsio/zcli/releases/latest/download/zcli-${target}"
else
zcli_uri="https://github.com/zeropsio/zcli/releases/download/${1}/zcli-${target}"
fi

zcli_install="${ZCLI_INSTALL:-$HOME/.zerops}"
bin_dir="$zcli_install/bin"
exe="$bin_dir/zcli"

if [ ! -d "$bin_dir" ]; then
mkdir -p "$bin_dir"
fi

curl --fail --location --progress-bar --output "$exe" "$zcli_uri"
chmod +x "$exe"

echo "ZCli was installed successfully to $exe"
if command -v zcli >/dev/null; then
echo "Run 'zcli --help' to get started"
else
case $SHELL in
/bin/zsh) shell_profile=".zshrc" ;;
*) shell_profile=".bashrc" ;;
esac
echo "Manually add the directory to your \$HOME/$shell_profile (or similar)"
echo "  export ZCLI_INSTALL=\"$zcli_install\""
echo "  export PATH=\"\$ZCLI_INSTALL/bin:\$PATH\""
echo "Run '$exe --help' to get started"
fi
echo
echo "Stuck? Join our Discord https://discord.com/invite/WDvCZ54"
