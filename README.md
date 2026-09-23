# Dotfiles para macOS

Configuração declarativa de macOS usando Nix, nix-darwin, Home Manager e
Homebrew.

Este repositório é parametrizável por máquina. O código versionado não depende
de um nome de usuário ou de uma identidade Git específica. Esses dados ficam
em `~/.config/dotfiles/machine.env`, um arquivo local fora do repositório e
gerado pelo bootstrap.

## Organização

```text
common/          composição da base reutilizável
personal/        composição específica deste computador pessoal
modules/darwin/  módulos de macOS e Homebrew
modules/home/    módulos de shell, desenvolvimento e Git
home/            arquivos de configuração editáveis
personal/ai/     instruções e skills pessoais para ferramentas de IA
```

O `flake.nix` expõe o host `personal`. A base comum fica em `common/` e o
perfil deste repositório fica em `personal/`. O futuro repositório de trabalho
terá a mesma organização, mas com `work/` no lugar de `personal/`.

Os dois repositórios serão independentes. Quando uma melhoria comum for
testada neste repositório e também fizer sentido no trabalho, ela será
replicada manualmente no `common/` do repositório de trabalho. Essa duplicação
é intencional para evitar uma dependência do ambiente pessoal no computador da
empresa.

## Requisitos

- macOS Apple Silicon;
- usuário local com permissão de administrador;
- Command Line Tools do Xcode;
- conexão com a internet;
- acesso aos repositórios e aplicativos que serão instalados.

O host atual atende Macs Apple Silicon. Macs Intel não são suportados por esta
configuração, que também depende de caminhos do Homebrew em `/opt/homebrew`.

## Instalação em uma máquina nova

### 1. Instalar as Command Line Tools

```sh
xcode-select --install
```

### 2. Clonar o repositório

Use o endereço do seu repositório:

```sh
mkdir -p ~/Documents/github
git clone <endereco-do-repositorio> ~/Documents/github/dotfiles
cd ~/Documents/github/dotfiles
```

### 3. Configurar e aplicar

O bootstrap aceita os dados como argumentos:

```sh
./bootstrap.sh \
  --user "seu-usuario-do-macos" \
  --git-name "Seu Nome" \
  --git-email "seu-email@example.com"
```

Se algum argumento não for informado, o script perguntará interativamente.

Por exemplo, para configurar usando o usuário atual e responder apenas às
perguntas restantes:

```sh
./bootstrap.sh
```

O script irá:

1. instalar o Determinate Nix, se necessário;
2. criar `~/.dotfiles` apontando para este repositório;
3. gerar `~/.config/dotfiles/machine.env` com o usuário e a identidade Git da máquina;
4. aplicar o host `personal` com nix-darwin;
5. deixar o comando `rebuild` disponível após abrir um novo terminal.

O arquivo `machine.env` contém dados específicos da máquina e não faz parte do
repositório. O arquivo `machine.env.example` mostra o formato esperado.

Depois de abrir um novo terminal, instale e selecione a versão Node LTS com
`nvm-setup`. Isso acontece uma vez por máquina e não durante cada rebuild.

Se esta máquina já usa o link antigo do diretório inteiro do Herdr, migre o
estado antes do rebuild que atualiza esse link:

```sh
DOTFILES_DIR="$PWD" bash scripts/migrate-herdr-state.sh
```

O script copia o estado local para `~/.config/herdr`, mantém o link anterior
como backup e deixa o Home Manager criar o link de `config.toml` no rebuild.

### 4. Aplicar alterações futuras

Depois da instalação, use:

```sh
rebuild
```

O comando aplica `~/.dotfiles#personal` e reinicia o shell somente quando a
aplicação termina com sucesso.

Também é possível executar diretamente:

```sh
./rebuild.sh
```

Antes de aplicar uma alteração, o script atualiza o link `~/.dotfiles` para o
clone atual. Isso permite trabalhar com o repositório em qualquer diretório.

## Identidade Git

O nome e o e-mail do Git são lidos de `machine.env` e configurados pelo Home
Manager. Para alterar esses dados nesta máquina, execute novamente:

```sh
./bootstrap.sh \
  --user "seu-usuario-do-macos" \
  --git-name "Novo Nome" \
  --git-email "novo-email@example.com"
```

Depois, aplique:

```sh
rebuild
```

A configuração de SSH continua usando `~/.ssh/id_ed25519`. Chaves privadas
nunca devem ser armazenadas neste repositório.

## Homebrew

Os aplicativos e fórmulas deste perfil são declarados em
`modules/darwin/homebrew.nix`, carregado pela camada `personal/`.
Este perfil usa limpeza declarativa (`cleanup = "zap"`): aplicativos Homebrew
que não estiverem declarados podem ser removidos durante o rebuild.

Antes de adicionar ou remover aplicativos, revise esse arquivo e o resultado
do Git. Em uma futura configuração de trabalho, essa política deve ser
avaliada separadamente, especialmente se a empresa já administrar aplicativos
no Mac.

## Teste paralelo de terminais

WezTerm continua instalado e configurado. Ghostty também é instalado pelo
Homebrew e recebe configuração declarativa do Home Manager para comparação.
Abra Ghostty manualmente durante o teste; não há configuração do Dock nem do
terminal padrão neste repositório. Ghostty usa Rose Pine Moon, Hack Nerd Font,
tamanho 15, janela 140×40, opacidade 0,8 e blur 50. A centralização dinâmica
configurada no Lua do WezTerm não tem equivalente identificado no Ghostty. A
opção de esconder a barra de abas do Ghostty é documentada como compatível
apenas com Linux, então esse
detalhe deve ser verificado no macOS. [Referência de configuração do Ghostty](https://ghostty.org/docs/config/reference).

Para comparar, use o mesmo shell, projeto e fluxo de Herdr/Codex/Pi nos dois
terminais. Faça dez medições de abertura até o prompt utilizável para partidas
frias e aquecidas e compare mediana e variação. A decisão de trocar o padrão
fica para depois dessa medição prática.

## Docker Desktop

Docker Desktop é instalado pelo Homebrew. Abra o aplicativo depois do primeiro
rebuild e valide o daemon e o Compose com:

```sh
docker info
docker compose version
```

Este repositório não declara Dockerfiles nem serviços Compose.

## OpenSuperWhisper

Depois do primeiro rebuild, abra o aplicativo e autorize microfone e
acessibilidade quando solicitado. O modelo e os atalhos são configurações do
aplicativo e não ficam armazenados neste repositório.

## Codex CLI

O Codex CLI é instalado pelo Homebrew junto com o restante do perfil. Depois
do primeiro `rebuild`, abra um novo terminal e autentique a conta:

```sh
codex --login
```

Na primeira execução, escolha `Sign in with ChatGPT` e conclua o fluxo no
navegador. O arquivo `~/.codex/AGENTS.md` e as skills pessoais são vinculados
automaticamente pelo Home Manager. Use `co` para iniciar o modo interativo e
`cc` para iniciar Claude Code com as verificações normais de permissão.

## AI Memory local

O setup segue a instalação nativa recomendada pelo projeto, fora do Nix: baixe
o tarball para Apple Silicon, mantenha o binário em
`~/Applications/ai-memory/ai-memory` e deixe os dados em
`~/Library/Application Support/ai-memory`. O servidor local deve continuar
restrito a `127.0.0.1:49374`. Os detalhes e opções podem mudar entre releases;
consulte o [guia oficial para macOS](https://github.com/akitaonrails/ai-memory/blob/main/docs/macos.md).

```sh
mkdir -p ~/Applications/ai-memory
cd ~/Applications/ai-memory
curl -fsSL -O https://github.com/akitaonrails/ai-memory/releases/latest/download/ai-memory-macos-aarch64.tar.gz
tar -xzf ai-memory-macos-aarch64.tar.gz
./ai-memory init
```

Para iniciar automaticamente no login, use o template de LaunchAgent que vem
no tarball. O guia oficial mostra como substituir `__AI_MEMORY_BIN__` e
`__HOME__`, gravar o plist em `~/Library/LaunchAgents` e carregá-lo com
`launchctl`. A sequência documentada pelo projeto é:

```sh
mkdir -p ~/Library/Logs/ai-memory ~/Library/LaunchAgents
AI_MEMORY_BIN="$HOME/Applications/ai-memory/ai-memory"
sed -e "s|__AI_MEMORY_BIN__|$AI_MEMORY_BIN|" \
  -e "s|__HOME__|$HOME|" \
  packaging/launchd/com.github.akitaonrails.ai-memory.plist \
  > "$HOME/Library/LaunchAgents/com.github.akitaonrails.ai-memory.plist"
launchctl bootstrap "gui/$(id -u)" \
  "$HOME/Library/LaunchAgents/com.github.akitaonrails.ai-memory.plist"
```

Para um teste temporário, mantenha `./ai-memory serve --transport http --bind
127.0.0.1:49374` rodando em um terminal antes de instalar as integrações. A
instalação permanente inicia o mesmo servidor pelo LaunchAgent.

Com o servidor ativo, use os instaladores oficiais para os clientes que você
usa:

```sh
cd ~/Applications/ai-memory
./ai-memory install-mcp --client codex --apply
./ai-memory install-hooks --agent codex --capture-mode allowlist --apply
./ai-memory install-hooks --agent pi --apply
```

O Codex recebe MCP e hooks. A configuração MCP em `~/.codex/config.toml` é
compartilhada pelo app desktop, CLI e extensão de IDE; reinicie o cliente
depois de instalar. Consulte a documentação oficial de [MCP](https://developers.openai.com/codex/mcp/)
e [hooks](https://developers.openai.com/codex/hooks/). O Pi gera a extensão em
`~/.pi/agent/extensions`, que captura eventos e expõe as ferramentas MCP, então
não precisa de um `install-mcp` separado. Mantenha um único perfil do Pi em
`~/.pi/agent`. O `allowlist` exige um marcador `.ai-memory.toml` em cada
projeto cuja captura for autorizada. O helper `ai-memory-project` cria esse
marcador em uma pasta existente:

O AI Memory também oferece `ai-memory run codex` para iniciar o Codex CLI em um
workstream gerenciado e automatizar a integração. Essa opção é voltada ao fluxo
de lançamento gerenciado pelo CLI; a instalação acima configura os clientes
que você abre diretamente.

```sh
ai-memory-project ~/Documents/projects/subscription-manager projects subscription-manager
```

Na primeira sessão do Codex, abra `/hooks` e revise os hooks instalados. Este
procedimento cobre Codex e Pi; os arquivos de configuração do Claude Code
permanecem fora dele e inalterados. Skills e instruções compartilhadas ficam
em `personal/ai/`; `code-review` é o único exemplo inicial. Para criar outra,
adicione uma pasta com `SKILL.md` e frontmatter Agent Skills em
`personal/ai/skills/`.

## Atualização do repositório

Para receber alterações versionadas:

```sh
git pull
rebuild
```

O `git pull` apenas atualiza os arquivos do repositório. O sistema só muda
quando `rebuild` é executado.

## Troubleshooting

### Nix não encontrado

Abra um novo terminal para carregar o ambiente do Determinate Nix e execute
novamente:

```sh
./bootstrap.sh
```

### Falha no primeiro rebuild

Verifique:

- se o usuário em `machine.env` existe no macOS;
- se a arquitetura em `modules/darwin/system.nix` está correta;
- se o usuário tem permissão de administrador;
- se o repositório está acessível;
- se `machine.env` foi gerado pelo bootstrap.

### Desinstalação do Nix

Se for realmente necessário remover o Nix, use primeiro o desinstalador
fornecido pela instalação. Não remova volumes ou diretórios manualmente sem
confirmar o alvo e fazer backup dos dados importantes.
