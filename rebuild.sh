#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
CONFIG_FILE="$HOME/.config/dotfiles/machine.env"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Machine settings are missing. Run ./bootstrap.sh first." >&2
  exit 1
fi
# shellcheck disable=SC1090
. "$CONFIG_FILE"
exec sudo env \
  DOTFILES_USER="$DOTFILES_USER" \
  DOTFILES_GIT_NAME="$DOTFILES_GIT_NAME" \
  DOTFILES_GIT_EMAIL="$DOTFILES_GIT_EMAIL" \
  darwin-rebuild switch --impure --flake ~/.dotfiles#personal
