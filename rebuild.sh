#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
if [[ -e "$HOME/.dotfiles" && ! -L "$HOME/.dotfiles" ]]; then
  echo "$HOME/.dotfiles exists and is not a symlink; rebuild cancelled." >&2
  exit 1
fi
CONFIG_FILE="$HOME/.config/dotfiles/machine.env"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Machine settings are missing. Run ./bootstrap.sh first." >&2
  exit 1
fi
# shellcheck disable=SC1090
. "$CONFIG_FILE"
if [[ "${DOTFILES_USER:-}" != "$(id -un)" || -z "${DOTFILES_GIT_NAME:-}" || -z "${DOTFILES_GIT_EMAIL:-}" ]]; then
  echo "Invalid machine identity in $CONFIG_FILE; run ./bootstrap.sh again." >&2
  exit 1
fi
ln -sfn "$DIR" "$HOME/.dotfiles"
DARWIN_REBUILD_BIN="$(command -v darwin-rebuild)"
exec sudo env \
  DOTFILES_USER="$DOTFILES_USER" \
  DOTFILES_GIT_NAME="$DOTFILES_GIT_NAME" \
  DOTFILES_GIT_EMAIL="$DOTFILES_GIT_EMAIL" \
  "$DARWIN_REBUILD_BIN" switch --impure --flake "$HOME/.dotfiles#personal"
