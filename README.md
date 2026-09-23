# Dotfiles para macOS Apple Silicon

Este repositório configura um Mac pessoal novo com Nix, nix-darwin, Home Manager
e Homebrew. O host `personal` em `flake.nix` usa `aarch64-darwin`; Macs Intel não
são suportados. O bootstrap exige macOS 14 ou mais recente por causa dos
aplicativos declarados. A avaliação deste perfil foi feita no macOS 26.6.2;
versões anteriores ainda precisam de teste prático. As versões de Nixpkgs,
nix-darwin e Home Manager vêm do `flake.lock`.

## Comece por aqui

1. Siga o [guia de instalação do Mac](docs/install-macos.md), na ordem indicada.
2. Para preparar o acesso ao GitHub, siga o [guia de SSH](docs/ssh-github.md).
3. Se quiser memória local para Codex e Pi, siga o [guia opcional de AI Memory](docs/ai-memory.md) depois do primeiro rebuild.

No primeiro Mac, a instalação do perfil é feita com `./bootstrap.sh`. Em
rebuilds futuros, use `rebuild`. O argumento `--user`, se fornecido, é o **nome
curto da conta local do macOS**. O login do GitHub aparece no endereço do
repositório; `--git-name` e `--git-email` definem o autor dos commits. Não use o
login do GitHub como `--user`, a menos que ele também seja o nome da conta
local.

## O que é gerenciado

| Parte | Fonte no repositório | Resultado |
| --- | --- | --- |
| Sistema, aplicativos e fórmulas | `modules/darwin/` | nix-darwin e Homebrew |
| Shell, Git, SSH, ferramentas e VS Code | `modules/home/` | Home Manager |
| WezTerm, Neovim e Herdr | `home/.config/` e `common/home/files.nix` | Links editáveis no diretório do usuário |
| Ghostty | `personal/home.nix` | Home Manager gera `~/.config/ghostty/config` |
| Instruções e skills de IA | `personal/ai/` | Links para Codex, Pi e clientes compatíveis |
| Identidade desta máquina | `~/.config/dotfiles/machine.env` | Arquivo local, fora do Git |

`common/` compõe a base reutilizável; `personal/` compõe este perfil. O
repositório não guarda chaves SSH privadas, autenticação dos aplicativos,
sessões dos agentes, estado do Herdr nem dados do AI Memory.

## Decisões importantes

- **Homebrew limpa aplicativos não declarados.** A política
  `homebrew.onActivation.cleanup = "zap"` é intencional. Antes de aplicar este
  perfil em um Mac que já tenha aplicativos, revise
  `modules/darwin/homebrew.nix`.
- **Os aplicativos Homebrew não têm versão fixa no flake.** Nixpkgs e módulos
  são fixados por `flake.lock`, mas um Mac novo recebe as versões disponíveis
  dos casks e fórmulas no dia do bootstrap. Revise mudanças desses aplicativos
  antes de um rebuild importante.
- **WezTerm e Ghostty coexistem.** Ambos são instalados como casks. WezTerm
  mantém sua configuração Lua; o Ghostty recebe tema, fonte, tamanho e janela
  equivalentes para um teste lado a lado. Nenhum terminal é removido ou
  definido como padrão. Veja [como comparar](docs/install-macos.md#comparar-os-terminais).
- **AI Memory é opcional.** Seu binário e dados locais ficam fora do Nix e do
  repositório. O [guia separado](docs/ai-memory.md) usa o método nativo
  recomendado pelo projeto e os instaladores oficiais das integrações.
- **Docker Desktop está declarado.** O repositório não contém Dockerfile nem
  serviços Compose. Depois do primeiro rebuild, abra o aplicativo e valide o
  daemon e o Compose conforme o [roteiro](docs/install-macos.md#verificacao-final).

Para criar skills pessoais, consulte [personal/ai/README.md](personal/ai/README.md).
