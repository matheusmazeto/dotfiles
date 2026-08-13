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
modules/darwin/  módulos de macOS, Homebrew e ativação
modules/home/    módulos de shell, desenvolvimento e Git
home/            arquivos de configuração editáveis
ai/              instruções e skills pessoais para ferramentas de IA
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

Para Macs Intel, altere `nixpkgs.hostPlatform` em
`modules/darwin/system.nix` para `x86_64-darwin` antes do primeiro bootstrap.

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

## OpenSuperWhisper

Depois do primeiro rebuild, abra o aplicativo e autorize microfone e
acessibilidade quando solicitado. O modelo e os atalhos são configurações do
aplicativo e não ficam armazenados neste repositório.

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
