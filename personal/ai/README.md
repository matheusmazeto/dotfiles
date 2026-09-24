# Configuração pessoal de IA

Esta pasta contém instruções e skills portáteis para Codex, Pi, Claude Code e
OpenCode. O conteúdo é público; não armazene contexto privado, credenciais ou
dados de sessão aqui. Revise o material antes de replicá-lo em outro
repositório.

## Instruções

`AGENTS.md` contém regras compartilhadas pelas ferramentas. O Home Manager cria
os links esperados:

- `~/.codex/AGENTS.md`;
- `~/.pi/agent/AGENTS.md`;
- `~/.config/opencode/AGENTS.md`;
- `~/.claude/rules/AGENTS.md`.

Claude Code 2.1.277 ou mais recente lê `AGENTS.md` do projeto diretamente no
modo padrão `claude-md-or-agents-md`, desde que não haja `CLAUDE.md` ou
`CLAUDE.local.md` no projeto ou em seus diretórios ancestrais. O Home Manager
também disponibiliza este mesmo arquivo em `~/.claude/rules/AGENTS.md` como
regra pessoal do Claude para todos os projetos. Assim, a fonte continua sendo
um `AGENTS.md`, sem criar um `CLAUDE.md` de compatibilidade.

## Skills

Crie cada skill em `skills/nome-da-skill/SKILL.md`. Use o formato portátil da
especificação Agent Skills e descreva no campo `description` quando a skill
deve ser usada. O Home Manager expõe a mesma pasta em `~/.agents/skills`, que
é descoberta pelo Codex e pelo Pi; também mantém os caminhos nativos do Claude
Code e do OpenCode para uso futuro. Não copie skills para diretórios separados.

`code-review/` revisa mudanças de código. `tutor/` conduz estudos com quiz no
chat e progresso em Markdown. Adicione novas skills somente quando houver um
fluxo reutilizável que você queira compartilhar entre agentes.
