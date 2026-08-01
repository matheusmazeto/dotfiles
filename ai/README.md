# Configuração de IA

Esta pasta é a fonte versionada da configuração compartilhada dos agentes de IA.

## Instruções globais

`AGENTS.md` contém regras pessoais compartilhadas pelo Codex, OpenCode e Claude
Code. O Home Manager cria links para esse arquivo usando o nome esperado por
cada ferramenta:

- `~/.codex/AGENTS.md` para o Codex;
- `~/.config/opencode/AGENTS.md` para o OpenCode;
- `~/.claude/CLAUDE.md` para o Claude Code.

O Claude Code usa o nome `CLAUDE.md`, enquanto Codex e OpenCode usam
`AGENTS.md`. O conteúdo continua centralizado neste repositório.

## Skills compartilhadas

As skills ficam em `skills/`, com uma pasta para cada skill e um arquivo
`SKILL.md` obrigatório. O Home Manager cria links dessa pasta para o local
comum `~/.agents/skills/` e para os locais específicos usados pelo Codex,
OpenCode e Claude Code.

A pasta comum funciona como uma fonte neutra para as skills compartilhadas.
Os links específicos tornam a descoberta explícita e evitam depender de uma
versão da ferramenta procurar automaticamente na pasta comum.

## Configuração específica de cada ferramenta

Configurações que apenas uma ferramenta entende devem ficar futuramente em uma
pasta `codex/`, `opencode/` ou `claude/`. Orientações compartilhadas devem
ficar em `AGENTS.md` ou em uma skill compartilhada, em vez de serem copiadas
entre as ferramentas.

As configurações específicas mantêm os caminhos esperados por cada ferramenta
dentro de `home/`:

- `home/.claude/settings.json` contém as preferências do Claude Code;
- `home/.codex/config.toml` é o ponto de entrada para opções exclusivas do Codex;
- `home/.config/opencode/opencode.json` é o ponto de entrada para opções exclusivas do OpenCode.
