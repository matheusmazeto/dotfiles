# AI Memory opcional para Codex e Pi

Instale AI Memory somente depois do [primeiro setup do Mac](install-macos.md).
O projeto recomenda o binário nativo do release para Apple Silicon. Ele e seus
dados locais ficam fora destes dotfiles. Este guia usa o tarball, um LaunchAgent
do próprio projeto e os comandos oficiais `install-mcp` e `install-hooks`, sem
script de instalação próprio. Consulte o
[guia oficial para macOS](https://github.com/akitaonrails/ai-memory/blob/main/docs/macos.md)
e a [documentação de instalação](https://github.com/akitaonrails/ai-memory/blob/main/docs/install.md)
antes de instalar uma versão futura.

## 1. Baixe e inicialize

```sh
mkdir -p "$HOME/Applications/ai-memory"
cd "$HOME/Applications/ai-memory"
curl -fsSL -O https://github.com/akitaonrails/ai-memory/releases/latest/download/ai-memory-macos-aarch64.tar.gz
tar -xzf ai-memory-macos-aarch64.tar.gz
./ai-memory init
```

O padrão no macOS guarda dados em `~/Library/Application Support/ai-memory`.
`init` prepara os dados, mas não inicia o servidor. Mantenha o binário e a
pasta `hooks/` extraída em um caminho estável; as integrações apontam para ele.
O fluxo básico de captura, busca e handoff funciona sem chave de API ou
provedor de LLM. Resumos enriquecidos e busca semântica são opcionais; veja os
[provedores aceitos](https://github.com/akitaonrails/ai-memory/blob/main/docs/llm-providers.md)
se decidir ativá-los depois.

## 2. Inicie o servidor local no login

O tarball inclui `packaging/launchd/com.github.akitaonrails.ai-memory.plist`.
Execute a partir de `~/Applications/ai-memory`:

```sh
mkdir -p "$HOME/Library/Logs/ai-memory" "$HOME/Library/LaunchAgents"
AI_MEMORY_BIN="$HOME/Applications/ai-memory/ai-memory"
sed -e "s|__AI_MEMORY_BIN__|$AI_MEMORY_BIN|" \
  -e "s|__HOME__|$HOME|" \
  packaging/launchd/com.github.akitaonrails.ai-memory.plist \
  > "$HOME/Library/LaunchAgents/com.github.akitaonrails.ai-memory.plist"
launchctl bootstrap "gui/$(id -u)" \
  "$HOME/Library/LaunchAgents/com.github.akitaonrails.ai-memory.plist"
launchctl print "gui/$(id -u)/com.github.akitaonrails.ai-memory"
```

O servidor usa por padrão `127.0.0.1:49374`. Mantenha esse endereço local.
Para um teste temporário, em vez do LaunchAgent, execute
`./ai-memory serve --transport http --bind 127.0.0.1:49374` e deixe esse
Terminal aberto. Os próximos comandos precisam de um servidor ativo.

## 3. Instale as integrações oficiais

Em outro Terminal, no mesmo diretório do binário:

```sh
cd "$HOME/Applications/ai-memory"
./ai-memory install-mcp --client codex --apply
./ai-memory install-hooks --agent codex --capture-mode allowlist --apply
./ai-memory install-hooks --agent pi --apply
./ai-memory status
```

Os comandos com `--apply` escrevem nas configurações locais dos agentes. Se
você já tiver ajustes pessoais, revise esses arquivos antes e depois da
instalação. O projeto informa que os instaladores guardam backups datados dos
arquivos alterados. Reinicie Codex e Pi depois. O MCP do Codex em
`~/.codex/config.toml` é compartilhado pelo Codex App e CLI, segundo a
[documentação oficial de MCP](https://developers.openai.com/codex/mcp/).
Confira os hooks do Codex com `/hooks`, conforme a
[documentação oficial de hooks](https://developers.openai.com/codex/hooks/).
No Pi, o instalador gera uma extensão em `~/.pi/agent/extensions`, que cuida da
integração; não há um `install-mcp --client pi` separado para este fluxo.

O modo `allowlist` evita capturar projetos sem o marcador `.ai-memory.toml`.
Ele é uma preferência local compartilhada pelos hooks nativos; o comando do
Pi gera a extensão com o modo configurado no passo anterior, conforme a
[referência de captura](https://github.com/akitaonrails/ai-memory/blob/main/docs/marker-file.md).
Para habilitar um projeto
existente, o helper destes dotfiles pode criar o marcador:

```sh
ai-memory-project "$HOME/Documents/projects/meu-projeto" projects meu-projeto
```

Revise o conteúdo do projeto antes de permitir captura. O marcador deve ser
versionado apenas quando toda a equipe concordar com essa escolha; caso
contrário, mantenha-o local. O AI Memory também oferece
`ai-memory run codex` para lançar o Codex CLI em um fluxo gerenciado; a
integração acima cobre o Codex aberto diretamente e o aplicativo de desktop.

As skills compartilhadas ficam em [`personal/ai/`](../personal/ai/README.md),
fora do banco do AI Memory. A primeira versão integra Codex e o perfil único
do Pi, `~/.pi/agent`. A configuração do Claude Code presente nestes dotfiles
não é alterada por este procedimento.
