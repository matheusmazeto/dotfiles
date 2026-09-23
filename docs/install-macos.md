# Instalação do zero em um Mac Apple Silicon

Este roteiro prepara uma conta pessoal nova no macOS 14 ou mais recente. Use
uma conta com permissão de administrador e uma sessão nativa Apple Silicon,
sem Rosetta.
Tenha conexão com a internet e acesso à sua conta do GitHub. O primeiro
rebuild instala aplicativos e pode pedir a senha de administrador.

## 1. Instale as ferramentas da Apple

No Terminal do macOS:

```sh
xcode-select --install
```

Espere a instalação terminar. Depois confirme:

```sh
xcode-select -p
uname -m
```

O segundo comando deve mostrar `arm64`.

## 2. Configure o SSH do GitHub

Siga [o guia de SSH](ssh-github.md) até receber a mensagem de autenticação no
teste `ssh -T git@github.com`. A chave fica no Mac, não neste repositório.

## 3. Clone o repositório

```sh
mkdir -p "$HOME/Documents/github"
git clone git@github.com:matheusmazeto/dotfiles.git "$HOME/Documents/github/dotfiles"
cd "$HOME/Documents/github/dotfiles"
```

Se estiver usando um fork, substitua o endereço acima. O nome de usuário no
endereço do GitHub identifica o dono do repositório; ele não muda a conta local
do macOS.

## 4. Revise o perfil e aplique

Antes do primeiro switch, confira `modules/darwin/homebrew.nix` e remova do
perfil qualquer aplicativo que não queira instalar. A limpeza Homebrew está
configurada como `zap`: em um Mac já usado, aplicativos Homebrew não declarados
podem ser removidos. Em um Mac novo, evite abrir VS Code, Herdr ou outros
aplicativos gerenciados antes do primeiro rebuild, pois arquivos de
configuração já criados por eles podem ocupar os caminhos do Home Manager.

Execute:

```sh
./bootstrap.sh --git-name "Seu Nome" --git-email "seu-email@example.com"
```

O script detecta o nome curto da conta atual do macOS com `id -un`. O argumento
opcional `--user` só aceita essa mesma conta. `--git-name` é o nome exibido nos
commits e `--git-email` é o endereço de autoria. Para manter seu e-mail privado
no GitHub, use o endereço `noreply` da sua conta. Se omitir nome ou e-mail, o
script pergunta no Terminal. Esses dados são salvos em
`~/.config/dotfiles/machine.env`, fora do repositório.

O bootstrap instala Determinate Nix quando necessário, aponta `~/.dotfiles`
para este clone e aplica o host `personal` com nix-darwin e Home Manager. Se
`~/.dotfiles` já for um diretório real, o script interrompe sem substituí-lo.
`flake.lock` fixa as dependências do sistema; o comando inicial do
`darwin-rebuild` vem do ramo `nix-darwin-26.05`.
O Hack Nerd Font é instalado em `/Library/Fonts/Nix Fonts` pelo nix-darwin
para ficar disponível nos dois terminais e nos demais aplicativos do macOS.

## 5. Complete os aplicativos e ferramentas

Abra um novo terminal depois do switch. Instale o Node LTS uma vez por Mac:

```sh
nvm-setup
node --version
```

O NVM vem do Homebrew, mas a versão do Node é gerenciada pelo próprio NVM.
Ela não é reinstalada em cada rebuild.
A fórmula Homebrew do Pi traz Node como dependência própria; o NVM mantém uma
versão LTS separada para projetos interativos.

Abra os aplicativos que exigem login e autentique cada um: Codex, Claude Code,
ChatGPT, Bitwarden, VS Code e os demais que você usar. Para o Codex CLI:

```sh
codex login
```

Use o login com ChatGPT. O Home Manager vincula as instruções e a skill de
exemplo do [perfil de IA](../personal/ai/README.md). O Pi usa somente
`~/.pi/agent`; não há perfil `~/.pi/learning` neste setup.

Use Claude Code 2.1.277 ou mais recente para suporte nativo a `AGENTS.md`. O
Home Manager disponibiliza as instruções pessoais em
`~/.claude/rules/AGENTS.md`; nos projetos, o Claude lê `AGENTS.md` diretamente
no modo padrão `claude-md-or-agents-md`, se não houver `CLAUDE.md` ou
`CLAUDE.local.md` no caminho do projeto. Confira essa opção em `/config`. Após
instalar ou atualizar o Claude Code, abra uma nova sessão para validar o
carregamento.

O OpenSuperWhisper pede permissões de microfone e acessibilidade quando você
o abre. O modelo e os atalhos permanecem nas preferências do aplicativo.

### Verificação final

```sh
readlink "$HOME/.dotfiles"
git config --global --get user.name
git config --global --get user.email
command -v nix
command -v darwin-rebuild
brew list --cask ghostty wezterm
command -v herdr
command -v codex
claude --version
command -v pi
```

Abra Docker Desktop, espere o serviço inicializar e então valide:

```sh
docker info
docker compose version
```

`docker info` valida o daemon, enquanto `docker compose version` confirma o
plugin Compose. Este repositório instala Docker Desktop, mas não declara
containers do projeto.

### Comparar os terminais

WezTerm e Ghostty são instalados juntos. A configuração Lua do WezTerm está em
`home/.config/wezterm/wezterm.lua`; a configuração do Ghostty fica em
`personal/home.nix` e é gerada em `~/.config/ghostty/config`. Os dois usam
Rose Pine Moon, Hack Nerd Font, tamanho 15, 140×40, opacidade 0,8 e blur no
macOS. O WezTerm centraliza a janela inicial por Lua; não há equivalente
declarado no Ghostty. O comportamento da barra de abas precisa ser conferido
no aplicativo. Não há atalho personalizado criado para Ghostty; teste o
prefixo Ctrl+B do Herdr nos dois terminais.

Para avaliar velocidade e fluidez, abra ambos com o mesmo shell, projeto e
fluxo de Herdr, Codex e Pi. Teste copiar e colar, redimensionamento e sessões.
Meça dez aberturas frias e dez aquecidas até o prompt utilizável por terminal;
compare mediana e variação. Nenhuma migração é necessária para fazer o teste.
[Referência oficial do Ghostty](https://ghostty.org/docs/config/reference).

## Rebuilds e mudanças de identidade

Depois do primeiro switch, aplique mudanças do repositório com:

```sh
rebuild
```

O comando atualiza o link `~/.dotfiles` para o clone atual e só reinicia o
shell se o rebuild terminar bem. Também é possível rodar `./rebuild.sh`.
Para alterar nome ou e-mail do Git nesta máquina, execute `./bootstrap.sh`
novamente com os novos valores. Isso reaplica o sistema. O arquivo
`machine.env.example` documenta o formato dos dados locais.

Se você já usava uma versão antiga destes dotfiles que vinculava o diretório
inteiro do Herdr, preserve o estado **antes** do primeiro rebuild com a versão
atual:

```sh
DOTFILES_DIR="$PWD" bash scripts/migrate-herdr-state.sh
```

Esse passo é apenas para uma instalação existente. Ele copia sessões e logs
para `~/.config/herdr`, mantém o link antigo como backup e deixa o Home Manager
gerenciar apenas `config.toml`. Em um Mac novo, pule esta etapa.

Para instalar a memória local dos agentes, continue no
[guia opcional de AI Memory](ai-memory.md).

## Se algo falhar

- Se `nix` não aparecer após a instalação, abra um novo Terminal e execute
  `./bootstrap.sh` novamente.
- Se o Home Manager relatar que um arquivo já existe, confira o caminho exato,
  preserve o conteúdo e só então decida como conciliar a configuração local.
- Se o switch falhar, confira `id -un`, `uname -m`, o acesso ao repositório e
  `~/.config/dotfiles/machine.env`. O sistema só é atualizado quando o switch
  termina.
