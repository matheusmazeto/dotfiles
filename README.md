# dotfiles

Configuração pessoal do macOS com Nix, nix-darwin, Home Manager e Homebrew.

## Organização

As configurações são separadas em dois contextos:

- `modules/darwin/` contém configurações do sistema aplicadas pelo nix-darwin,
  como opções do macOS, Homebrew, aplicativos, usuários e scripts de ativação.
- `modules/home/` contém configurações do usuário aplicadas pelo Home Manager,
  como pacotes de terminal, Git, SSH, Zsh, Starship, uv e links para os
  dotfiles.

Em resumo, `darwin` configura o Mac e `home` configura o ambiente do usuário.
Os arquivos `configuration.nix` e `home.nix` são os pontos de entrada que
importam esses módulos.

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

Depois que o bootstrap terminar, abra um novo terminal. Para aplicar alterações
futuras de qualquer pasta, use:

```sh
rebuild
```

A função executa `~/.dotfiles/rebuild.sh` e inicia um novo shell somente depois
que o rebuild termina com sucesso. Se o comando ainda não existir na sessão
atual, execute uma vez:

```sh
~/.dotfiles/rebuild.sh
exec zsh
```

O rebuild remove pacotes e aplicativos do Homebrew que não estejam declarados
em `modules/darwin/homebrew.nix`.

### Ditado global com OpenSuperWhisper

O OpenSuperWhisper transforma voz em texto no aplicativo que estiver em foco,
incluindo terminal, VS Code, navegador, Slack e ChatGPT. Ele é instalado e
mantido pelo Homebrew junto com o restante da configuração.

Depois de aplicar o `rebuild`:

1. Abra o OpenSuperWhisper pelo Launchpad ou pela busca do macOS.
2. Autorize o microfone e a acessibilidade quando o macOS solicitar.
3. Baixe o modelo local `Parakeet v3`.
4. Escolha `Português` como idioma principal. Use `Auto Detect` apenas se
   alternar frequentemente entre gravações inteiras em português e inglês.
5. Selecione o modo `Hold to record`.
6. Configure `Right Option` como atalho de gravação.
7. Em `Initial prompt` ou no dicionário personalizado, adicione termos que
   aparecem nos seus prompts, por exemplo: `Claude Code, Codex, OpenCode,
   OpenSuperWhisper, WezTerm, nix-darwin, Home Manager, Homebrew, useEffect,
   TypeScript, React`.

O `Parakeet v3` é a opção rápida para o uso diário e suporta português e
inglês. Se a precisão dos nomes técnicos não for suficiente, baixe também o
`Whisper V3 Large` e compare. Ele tende a ser mais preciso, mas pode ser mais
lento e consumir mais memória. O `Parakeet v2` não é recomendado porque é
focado em inglês.

O OpenSuperWhisper usa modelos locais. Não é necessário configurar uma chave da
OpenAI nem uma API: o aplicativo faz a transcrição no Mac. O nome Whisper se
refere à tecnologia de reconhecimento de voz, não a uma dependência da API da
OpenAI.

8. Teste em um campo simples do TextEdit antes de usar no terminal. Se a
   gravação funcionar mas o texto não aparecer, confirme `System Settings >
   Privacy & Security > Accessibility` e ative o OpenSuperWhisper. Verifique
   também `Input Monitoring`, se o aplicativo estiver listado, e reinicie o
   OpenSuperWhisper depois de alterar as permissões.

`Right Option` é a recomendação inicial porque deixa `Command-Space` livre para
o Raycast e não disputa os atalhos de entrada de texto que já estão configurados
no macOS. Segure a tecla enquanto fala e solte para inserir o texto no cursor.
Se o layout do teclado atribuir caracteres especiais ao `Right Option`, use
`Right Control` como segunda opção.

O processamento local é o padrão, mas o aplicativo ainda precisa das
permissões de microfone e acessibilidade para capturar a fala e inserir o texto.

Se o texto for transcrito mas não for inserido automaticamente, pressione
`Command-V` em um campo de texto para testar se ele foi copiado para o
clipboard. Isso diferencia um problema de transcrição de um problema de
permissão ou auto-paste.

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
rebuild
```

O script `rebuild.sh` já é versionado com permissão de execução. Ele mantém
`~/.dotfiles` apontando para este repositório e aplica a configuração do
nix-darwin e do Home Manager. Não é necessário executar `chmod` manualmente.
