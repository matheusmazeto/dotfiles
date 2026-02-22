#!/usr/bin/env bash
set -euo pipefail

log() { printf "\n==> %s\n" "$*"; }

# 1) Xcode Command Line Tools (necessário pro brew / git / compilações)
if ! xcode-select -p >/dev/null 2>&1; then
  log "Instalando Xcode Command Line Tools..."
  xcode-select --install || true
  log "Quando terminar a instalação, rode este script novamente."
  exit 0
fi

# 2) Homebrew
if ! command -v brew >/dev/null 2>&1; then
  log "Instalando Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 3) Carrega brew no shell atual e garante shellenv no .zprofile
BREW_PREFIX="$(brew --prefix)"
ZPROFILE="${ZDOTDIR:-$HOME}/.zprofile"

if ! grep -q 'brew shellenv' "$ZPROFILE" 2>/dev/null; then
  log "Adicionando brew shellenv no $ZPROFILE..."
  {
    echo ""
    echo "eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\""
  } >> "$ZPROFILE"
fi

eval "$("${BREW_PREFIX}/bin/brew" shellenv)"

# 4) Instala tudo do Brewfile
log "Atualizando Homebrew..."
brew update

log "Instalando apps e pacotes via Brewfile (brew bundle)..."
brew tap homebrew/bundle >/dev/null 2>&1 || true
brew bundle --file "${BASH_SOURCE%/*}/Brewfile"

# 5) Stow (symlinks dos dotfiles)
if command -v stow >/dev/null 2>&1; then
  log "Aplicando stow..."
  (cd "${BASH_SOURCE%/*}" && stow .)
fi

# 6) SSH key + config (cria só se não existir)
SSH_KEY="$HOME/.ssh/id_ed25519"
SSH_CONFIG="$HOME/.ssh/config"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ ! -f "$SSH_KEY" ]; then
  log "Gerando SSH key (ed25519)..."
  ssh-keygen -t ed25519 -C "mgmazeto@gmail.com" -f "$SSH_KEY"
fi

log "Adicionando key ao Keychain (macOS)..."
ssh-add --apple-use-keychain "$SSH_KEY" >/dev/null 2>&1 || true

if [ ! -f "$SSH_CONFIG" ] || ! grep -q 'IdentityFile ~/.ssh/id_ed25519' "$SSH_CONFIG"; then
  log "Criando/atualizando ~/.ssh/config..."
  cat > "$SSH_CONFIG" <<'EOF'
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
  chmod 600 "$SSH_CONFIG"
fi

# 7) NVM: instala Node LTS (carrega nvm via brew)
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"

if [ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ]; then
  # shellcheck disable=SC1090
  . "$BREW_PREFIX/opt/nvm/nvm.sh"
  log "Instalando Node LTS via nvm..."
  nvm install --lts
else
  log "NVM não carregou agora. Abra um novo terminal e rode: nvm install --lts"
fi

log "Pronto!"
log "Recomendo abrir um novo terminal e validar:"
log "  brew list"
log "  bun -v"
log "  node -v"
log "  cat ~/.ssh/id_ed25519.pub"
