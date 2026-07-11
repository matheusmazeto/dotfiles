# dotfiles

Configuração pessoal do macOS com Nix, nix-darwin, Home Manager e Homebrew.

## Instalação em um Mac novo

Requisitos:

- Mac com Apple Silicon;
- usuário do macOS chamado `th3g3ntl3man`;
- conexão com a internet;
- acesso de administrador.

A configuração usa `/Users/th3g3ntl3man` como diretório pessoal. Crie esse
usuário ao configurar o macOS para que todos os caminhos sejam aplicados no
local correto.

### 1. Instalar as Command Line Tools do Xcode

Execute um dos comandos:

```sh
xcode-select --install
```

```sh
git -v
```

Se necessário, o macOS abrirá a instalação. Conclua antes de continuar.

### 2. Clonar o repositório

```sh
mkdir -p ~/Documents/github
git clone https://github.com/matheusmazeto/dotfiles.git ~/Documents/github/dotfiles
cd ~/Documents/github/dotfiles
```

### 3. Executar o bootstrap

```sh
./bootstrap.sh
```

O script instala o Determinate Nix, cria `~/.dotfiles`, confirma o usuário do
macOS e aplica a configuração. Autorize o uso de `sudo` quando solicitado.

Se o bootstrap falhar durante a instalação do Nix, consulte
[Troubleshooting do bootstrap](#troubleshooting-do-bootstrap).

### 4. Configurar o acesso SSH ao GitHub

Gere uma chave usando o e-mail da conta do GitHub:

```sh
ssh-keygen -t ed25519 -C "mgmazeto@gmail.com"
```

Pressione Enter para usar o caminho padrão `~/.ssh/id_ed25519`. Em seguida,
adicione a chave ao `ssh-agent` e copie a chave pública:

```sh
eval "$(ssh-agent -s)"
/usr/bin/ssh-add --apple-use-keychain ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub
```

Abra [GitHub SSH keys](https://github.com/settings/ssh/new), cole a chave no
campo **Key** e salve. Depois, configure este clone para usar SSH e teste a
conexão:

```sh
cd ~/Documents/github/dotfiles
git remote set-url origin git@github.com:matheusmazeto/dotfiles.git
ssh -T git@github.com
```

### 5. Instalar o Python

Abra um novo terminal e execute:

```sh
uv python install
```

O uv instalará a versão estável mais recente e usará somente versões de Python
gerenciadas por ele.

### 6. Verificar a instalação

```sh
nix --version
node --version
pnpm --version
bun --version
uv --version
uv python list --only-installed
```

## Troubleshooting do bootstrap

Use estas etapas somente se o bootstrap falhar durante a instalação do Nix.

### 1. Tentar o desinstalador

Se o arquivo existir, execute:

```sh
sudo /nix/nix-installer uninstall
```

### 2. Remover os dados restantes

Se o erro continuar:

1. Abra o **Disk Utility**.
2. Localize o volume APFS **Nix Store**.
3. Clique com o botão direito e selecione **Delete APFS Volume**.
4. Abra o **Keychain Access**.
5. Procure por **Nix Store** e remova **Encrypted volume password**, caso
   exista.

### 3. Instalar o Determinate Nix manualmente

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
  | sh -s -- install --no-confirm
```

Alternativa: [Determinate Nix Installer](https://determinate.systems/nix-installer/).

Abra um novo terminal e tente novamente:

```sh
cd ~/Documents/github/dotfiles
./bootstrap.sh
```

## Aplicar alterações futuras

```sh
cd ~/.dotfiles
./rebuild.sh
```
