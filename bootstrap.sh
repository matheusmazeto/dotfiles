#!/usr/bin/env bash
# Configures a fresh Apple Silicon Mac. After this, use `rebuild`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

usage() {
  cat <<'EOF'
Usage: ./bootstrap.sh [options]

Options:
  --user USER       macOS short username (defaults to the current account)
  --git-name NAME   Git commit author name (not the GitHub login)
  --git-email MAIL  Git commit author email
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

echo "==> Step 1: check this Mac and collect its identity"
if [[ "$(uname -s)" != Darwin || "$(uname -m)" != arm64 ]]; then
  echo "This configuration requires macOS on Apple Silicon (arm64)." >&2
  exit 1
fi
MACOS_VERSION="$(sw_vers -productVersion)"
MACOS_MAJOR="${MACOS_VERSION%%.*}"
if [[ ! "$MACOS_MAJOR" =~ ^[0-9]+$ ]] || (( MACOS_MAJOR < 14 )); then
  echo "This profile requires macOS 14 or later (found $MACOS_VERSION)." >&2
  exit 1
fi
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Install the Xcode Command Line Tools first: xcode-select --install" >&2
  exit 1
fi

REAL_USER="$(id -un)"
USER_NAME="${USER_NAME:-$REAL_USER}"
if [[ "$USER_NAME" != "$REAL_USER" ]]; then
  echo "--user must be the current macOS account ($REAL_USER), not a GitHub login." >&2
  exit 1
fi
if [ -z "$GIT_NAME" ]; then
  read -r -p "    Git author name: " GIT_NAME
fi
if [ -z "$GIT_EMAIL" ]; then
  read -r -p "    Git author email: " GIT_EMAIL
fi

if [[ -z "$GIT_NAME" || -z "$GIT_EMAIL" || "$GIT_EMAIL" != *@* ]]; then
  echo "Provide a Git author name and a valid-looking Git email." >&2
  exit 1
fi

if [[ -e "$HOME/.dotfiles" && ! -L "$HOME/.dotfiles" ]]; then
  echo "$HOME/.dotfiles already exists and is not a symlink; no files were replaced." >&2
  exit 1
fi

case "$USER_NAME$GIT_NAME$GIT_EMAIL" in
  *$'\n'*|*$'\r'*)
    echo "    Identity values cannot contain line breaks." >&2
    exit 1
    ;;
esac

echo "==> Step 2: Determinate Nix"
if command -v nix >/dev/null 2>&1; then
  echo "    nix already installed, skipping"
else
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install --no-confirm
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

echo "==> Step 3: symlink this repo to ~/.dotfiles"
# Home Manager resolves editable configuration through this link.
ln -sfn "$DIR" "$HOME/.dotfiles"

echo "==> Step 4: configure this machine"

CONFIG_DIR="$HOME/.config/dotfiles"
CONFIG_FILE="$CONFIG_DIR/machine.env"
mkdir -p "$CONFIG_DIR"
{
  printf 'export DOTFILES_USER=%q\n' "$USER_NAME"
  printf 'export DOTFILES_GIT_NAME=%q\n' "$GIT_NAME"
  printf 'export DOTFILES_GIT_EMAIL=%q\n' "$GIT_EMAIL"
} > "$CONFIG_FILE"
chmod 600 "$CONFIG_FILE"
echo "    Saved machine-local settings to $CONFIG_FILE."

echo "==> Step 5: first darwin-rebuild switch (pinned to nix-darwin-26.05)"
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
  switch --impure --flake "$HOME/.dotfiles#personal"
# If this still fails with "nix: command not found", open a new terminal
# (Determinate adds nix to new shells' PATH) and re-run ./bootstrap.sh.

echo "==> Done. Use ./rebuild.sh for future changes."
