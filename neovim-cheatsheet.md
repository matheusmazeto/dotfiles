# Neovim Cheat Sheet

Colinha do fluxo diário para trabalhar com arquivos, LSP, Git, terminal e testes.

## Atalhos principais

| Ação | Atalho |
| --- | --- |
| Encontrar arquivo, como Command + P | `Espaço f` |
| Buscar texto no projeto | `Espaço s` |
| Abrir árvore de arquivos | `Espaço e` |
| Listar buffers | `Espaço b` |
| Abrir Neogit | `Espaço g` |
| Formatar agora | `Espaço cf` |
| Salvar e formatar | `Esc` |

## Começar

No terminal:

```bash
cd caminho/do/projeto
nvim
```

Abrir um arquivo diretamente:

```bash
nvim caminho/do/arquivo
```

## Modos do Neovim

| Tecla | Função |
| --- | --- |
| `Esc` | Voltar ao modo normal, salvar e formatar na sua configuração |
| `i` | Inserir antes do cursor |
| `a` | Inserir depois do cursor |
| `o` | Criar linha abaixo |
| `O` | Criar linha acima |
| `v` | Seleção por caracteres |
| `V` | Seleção por linhas |
| `Ctrl-v` | Seleção por bloco |
| `:` | Abrir comando do Neovim |

## Arquivos

### Encontrar arquivo

```text
Espaço f
```

Depois:

| Tecla | Função |
| --- | --- |
| Digitar | Filtrar arquivos |
| `Enter` | Abrir arquivo |
| `Ctrl-v` | Abrir em divisão vertical |
| `Ctrl-x` | Abrir em divisão horizontal |
| `Esc` | Cancelar |

### Oil, a árvore de arquivos

```text
Espaço e
```

| Tecla | Função |
| --- | --- |
| `j` / `k` | Mover para baixo / cima |
| `Enter` | Abrir arquivo ou pasta |
| `-` | Voltar para a pasta anterior |
| `q` | Fechar |
| `g?` | Mostrar ajuda |
| `d` | Criar diretório |
| `:rename` | Renomear |
| `:delete` | Apagar |
| `:move` | Mover |
| `:copy` | Copiar |

### Buscar texto no projeto

```text
Espaço s
```

### Buffers

```text
Espaço b
```

## Navegação

| Tecla | Função |
| --- | --- |
| `h` | Esquerda |
| `j` | Baixo |
| `k` | Cima |
| `l` | Direita |
| `w` | Próxima palavra |
| `b` | Palavra anterior |
| `e` | Final da palavra |
| `0` | Início da linha |
| `^` | Primeiro caractere da linha |
| `$` | Final da linha |
| `gg` | Início do arquivo |
| `G` | Final do arquivo |
| `50%` | Ir para metade do arquivo |
| `H` | Topo da tela |
| `M` | Meio da tela |
| `L` | Final da tela |

### Scroll

| Tecla | Função |
| --- | --- |
| `Ctrl-d` | Meia tela para baixo |
| `Ctrl-u` | Meia tela para cima |
| `Ctrl-f` | Uma tela para baixo |
| `Ctrl-b` | Uma tela para cima |
| `Ctrl-e` | Rolar uma linha para baixo |
| `Ctrl-y` | Rolar uma linha para cima |
| `zz` | Centralizar o cursor |
| `zt` | Colocar a linha no topo |
| `zb` | Colocar a linha no final |

## Edição

| Tecla | Função |
| --- | --- |
| `x` | Apagar caractere |
| `dd` | Apagar linha |
| `D` | Apagar até o final da linha |
| `dw` | Apagar palavra |
| `cc` | Substituir linha inteira |
| `C` | Substituir até o fim da linha |
| `yy` | Copiar linha |
| `p` | Colar depois |
| `P` | Colar antes |
| `u` | Desfazer |
| `Ctrl-r` | Refazer |
| `.` | Repetir último comando |
| `J` | Juntar linha com a próxima |
| `Ctrl-a` | Selecionar tudo |

Depois de selecionar:

| Tecla | Função |
| --- | --- |
| `y` | Copiar |
| `d` | Apagar |
| `c` | Substituir |
| `>` | Indentar |
| `<` | Remover indentação |

## Buscar e substituir

```vim
/palavra       " buscar para frente
?palavra       " buscar para trás
```

| Tecla | Função |
| --- | --- |
| `n` | Próximo resultado |
| `N` | Resultado anterior |
| `*` | Buscar palavra sob o cursor |

Substituir no arquivo inteiro:

```vim
:%s/antigo/novo/g
```

Com confirmação:

```vim
:%s/antigo/novo/gc
```

## Salvar e sair

Na sua configuração, `Esc` salva e formata arquivos normais.

```vim
:w          " salvar
:q          " sair
:wq         " salvar e sair
:q!         " sair sem salvar
:wa         " salvar tudo
:qa         " sair de tudo
```

## Janelas e splits

```vim
:vsplit arquivo
:split arquivo
```

| Tecla | Função |
| --- | --- |
| `Ctrl-w h` | Janela à esquerda |
| `Ctrl-w j` | Janela abaixo |
| `Ctrl-w k` | Janela acima |
| `Ctrl-w l` | Janela à direita |
| `Ctrl-w w` | Próxima janela |
| `Ctrl-w q` | Fechar janela |
| `Ctrl-w =` | Igualar tamanhos |
| `Ctrl-w _` | Maximizar altura |
| `Ctrl-w \|` | Maximizar largura |

## Tabs

```vim
:tabnew
:tabedit caminho/do/arquivo
:tabclose
```

| Tecla | Função |
| --- | --- |
| `gt` | Próxima tab |
| `gT` | Tab anterior |
| `1gt` | Primeira tab |
| `2gt` | Segunda tab |

> Um buffer é um arquivo aberto, uma janela é uma divisão e uma tab é um conjunto de janelas.

## LSP e autocomplete

| Tecla | Função |
| --- | --- |
| `gd` | Ir para definição |
| `grr` | Encontrar referências |
| `gri` | Ir para implementação |
| `K` | Mostrar documentação |
| `Espaço rn` | Renomear símbolo |
| `Espaço ca` | Ações de código |
| `[d` | Diagnóstico anterior |
| `]d` | Próximo diagnóstico |
| `Espaço d` | Mostrar diagnóstico da linha |
| `Espaço cf` | Formatar buffer |
| `Ctrl-space` | Abrir autocomplete |
| `Enter` | Aceitar sugestão |
| `Tab` | Próxima sugestão ou snippet |
| `Shift-Tab` | Sugestão anterior |

## Git

Abrir o Neogit:

```text
Espaço g
```

| Tecla | Função |
| --- | --- |
| `s` | Stage |
| `u` | Unstage |
| `x` | Descartar alteração |
| `c` | Criar commit |
| `P` | Push |
| `F` | Pull |
| `Tab` | Expandir detalhes |
| `q` | Fechar |
| `?` | Ajuda |

Fluxo de commit:

```text
Espaço + g
s          " stage
c          " commit
:wq        " salvar mensagem
P          " push
```

Mensagem sugerida:

```text
refactor(nvim): organize configuration by language
```

### Gitsigns e diffs

```vim
:Gitsigns preview_hunk
:Gitsigns stage_hunk
:Gitsigns reset_hunk
:Gitsigns toggle_current_line_blame
:DiffviewOpen
:DiffviewClose
```

Na coluna lateral:

```text
+   linha adicionada
~   linha modificada
_   linha removida
```

## Terminal dentro do Neovim

```vim
:terminal
```

Sair do modo terminal e voltar ao Neovim:

```text
Ctrl-\ Ctrl-n
```

Fechar a janela do terminal:

```text
Ctrl-w q
```

## Comandos de projeto

### Python

```bash
uv run pytest
uv run pytest -q
uv run ruff check .
uv run ruff format .
```

### Node.js e frontend

```bash
pnpm vitest
pnpm vitest run
pnpm playwright test
pnpm lint
```

### Rust

```bash
cargo test
cargo clippy
cargo fmt
```

## Fluxo diário recomendado

```text
1. Entrar na pasta do projeto
2. Executar nvim
3. Espaço + f para encontrar um arquivo
4. Editar usando i, a ou o
5. Esc para formatar e salvar
6. gd, K, grr e Espaço + ca para navegar no código
7. Espaço + s para buscar no projeto
8. Rodar os testes no terminal
9. Espaço + g para revisar o Git
10. s para stage
11. c para commit
12. P para push
```

## Emergência

```vim
:checkhealth   " verificar problemas
:Lazy          " gerenciar plugins
:q!            " sair sem salvar
```

Dentro do Neovim, pressione `Espaço` para abrir o Which-Key e ver os atalhos disponíveis.
