#!/usr/bin/env bash
# Takes a fresh Mac from nothing to a built nix-darwin config.
# Run this once. After it finishes, use `rebuild` for later changes.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

usage() {
  cat <<'EOF'
Usage: ./bootstrap.sh [options]

Options:
  --user USER       macOS username
  --git-name NAME   Git author name
  --git-email MAIL  Git author email
  -h, --help        show this help

Missing values are requested interactively.
EOF
}

USER_NAME=""
GIT_NAME=""
GIT_EMAIL=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --user)
      [ "$#" -ge 2 ] || { echo "Missing value for --user" >&2; exit 1; }
      USER_NAME="$2"
      shift 2
      ;;
    --git-name)
      [ "$#" -ge 2 ] || { echo "Missing value for --git-name" >&2; exit 1; }
      GIT_NAME="$2"
      shift 2
      ;;
    --git-email)
      [ "$#" -ge 2 ] || { echo "Missing value for --git-email" >&2; exit 1; }
      GIT_EMAIL="$2"
      shift 2
      ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

echo "==> Step 1: Determinate Nix"
if command -v nix >/dev/null 2>&1; then
  echo "    nix already installed, skipping"
else
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install --no-confirm
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

echo "==> Step 2: symlink this repo to ~/.dotfiles"
# home.nix resolves its mkOutOfStoreSymlink paths through ~/.dotfiles, so this
# has to exist before the first switch or the build will fail to find them.
ln -sfn "$DIR" ~/.dotfiles

echo "==> Step 3: configure this machine"
# Do this before any sudo call: sudo resets $USER.
REAL_USER="$(whoami)"
USER_NAME="${USER_NAME:-$REAL_USER}"

read -r -p "    macOS username [$USER_NAME]: " VALUE
USER_NAME="${VALUE:-$USER_NAME}"
if [ -z "$GIT_NAME" ]; then
  read -r -p "    Git author name: " GIT_NAME
fi
if [ -z "$GIT_EMAIL" ]; then
  read -r -p "    Git author email: " GIT_EMAIL
fi

case "$USER_NAME$GIT_NAME$GIT_EMAIL" in
  *$'\n'*|*$'\r'*)
    echo "    Identity values cannot contain line breaks." >&2
    exit 1
    ;;
esac

escape_shell_string() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//\'/\\\'}"
  printf '%s' "$value"
}

CONFIG_DIR="$HOME/.config/dotfiles"
CONFIG_FILE="$CONFIG_DIR/machine.env"
mkdir -p "$CONFIG_DIR"
{
  printf "export DOTFILES_USER='%s'\n" "$(escape_shell_string "$USER_NAME")"
  printf "export DOTFILES_GIT_NAME='%s'\n" "$(escape_shell_string "$GIT_NAME")"
  printf "export DOTFILES_GIT_EMAIL='%s'\n" "$(escape_shell_string "$GIT_EMAIL")"
} > "$CONFIG_FILE"
chmod 600 "$CONFIG_FILE"
echo "    Saved machine-local settings to $CONFIG_FILE."

echo "==> Step 4: first darwin-rebuild switch (pinned to nix-darwin-26.05)"
# darwin-rebuild doesn't exist yet on a fresh machine, so run it straight
# from the flake this once. After this, rebuild.sh works normally.
# This fetches the darwin-rebuild tool from the nix-darwin-26.05 release branch,
# not the exact flake.lock revision. The system config it applies is still pinned
# by this repo's flake.lock.
# sudo resets PATH to a secure default that excludes /nix/.../bin, so a
# freshly installed `nix` would not be found under sudo even though it's
# on PATH here. Resolve the absolute path first and invoke that instead.
NIX_BIN="$(command -v nix)"
# "personal" is the flake host label for this repository.
sudo env \
  DOTFILES_USER="$USER_NAME" \
  DOTFILES_GIT_NAME="$GIT_NAME" \
  DOTFILES_GIT_EMAIL="$GIT_EMAIL" \
  "$NIX_BIN" run github:nix-darwin/nix-darwin/nix-darwin-26.05#darwin-rebuild -- \
  switch --impure --flake ~/.dotfiles#personal
# If this still fails with "nix: command not found", open a new terminal
# (Determinate adds nix to new shells' PATH) and re-run ./bootstrap.sh.

echo "==> Done. Use ./rebuild.sh for future changes."
