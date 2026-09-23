#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Uso: new-ai-memory-project.sh DIRETORIO [WORKSPACE] [PROJETO]

Cria .ai-memory.toml em um diretório existente.
WORKSPACE padrão: learning para ~/Documents/learning/* e projects para ~/Documents/projects/*.
USAGE
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" || $# -lt 1 || $# -gt 3 ]]; then
  usage
  [[ $# -ge 1 ]] || exit 0
  [[ ${1:-} == "-h" || ${1:-} == "--help" ]] && exit 0
  exit 2
fi

directory=$(cd -- "$1" 2>/dev/null && pwd) || {
  echo "Diretório não encontrado: $1" >&2
  exit 1
}
home_dir=${HOME}
workspace=${2:-}
project=${3:-"$(basename "$directory")"}

case "$directory/" in
  "$home_dir/Documents/learning/"*) default_workspace="learning" ;;
  "$home_dir/Documents/projects/"*) default_workspace="projects" ;;
  *) default_workspace="" ;;
esac
if [[ -z "$workspace" ]]; then
  workspace=$default_workspace
fi
if [[ -z "$workspace" ]]; then
  echo "Informe WORKSPACE para diretórios fora de ~/Documents/learning ou ~/Documents/projects." >&2
  exit 2
fi

for value_name in workspace project; do
  value=${!value_name}
  if [[ ! "$value" =~ ^[a-z0-9][a-z0-9._-]*$ ]]; then
    echo "$value_name inválido: $value" >&2
    exit 2
  fi
done

marker="$directory/.ai-memory.toml"
content=$(printf 'workspace = "%s"\nproject = "%s"\n' "$workspace" "$project")
if [[ -e "$marker" ]]; then
  if printf '%s' "$content" | cmp -s - "$marker"; then
    echo "Marcador já está configurado: $marker"
    exit 0
  fi
  echo "Marcador existente com conteúdo diferente: $marker" >&2
  exit 1
fi

umask 077
printf '%s' "$content" > "$marker"
echo "Marcador criado: $marker"
