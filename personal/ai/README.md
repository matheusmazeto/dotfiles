# Configuração pessoal de IA

Esta pasta contém instruções e skills genéricas para Codex e Pi. O conteúdo é
público e portátil; não armazene contexto privado, credenciais ou dados de
sessão aqui. Revise o material antes de replicá-lo em outro repositório.

## Instruções

`AGENTS.md` contém regras compartilhadas pelas ferramentas. O Home Manager cria
os links esperados:

- `~/.codex/AGENTS.md`;
- `~/.pi/agent/AGENTS.md`;
- `~/.config/opencode/AGENTS.md`;
- `~/.claude/CLAUDE.md`.

## Skills

Crie cada skill em `skills/nome-da-skill/SKILL.md`. Use o formato portátil da
especificação Agent Skills e descreva no campo `description` quando a skill
deve ser usada. O Home Manager expõe a mesma pasta em `~/.agents/skills`, que
é descoberta pelo Codex e pelo Pi; também mantém os caminhos nativos do Claude
Code e do OpenCode para uso futuro. Não copie skills para diretórios separados.

`code-review/` é o único exemplo inicial. Adicione novas skills somente quando
houver um fluxo reutilizável que você queira compartilhar entre agentes.
