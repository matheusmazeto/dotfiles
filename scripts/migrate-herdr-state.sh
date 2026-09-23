#!/usr/bin/env bash
set -euo pipefail

home_dir=${HOME:?HOME precisa estar definido}
dotfiles_dir=${DOTFILES_DIR:-"$home_dir/.dotfiles"}
source_dir="$dotfiles_dir/home/.config/herdr"

command -v python3 >/dev/null 2>&1 || {
  echo "Python 3 não encontrado. Aplique o rebuild antes da migração." >&2
  exit 1
}

python3 - "$home_dir" "$source_dir" <<'PY'
import os
import shutil
import sys
import time
from pathlib import Path

home_dir, source_dir = map(Path, sys.argv[1:])
source_dir = source_dir.resolve(strict=True)
source_config = source_dir / "config.toml"
config_root = home_dir / ".config"
managed_path = config_root / "herdr"

if not source_config.is_file():
    raise SystemExit(f"Config do Herdr não encontrada: {source_config}")

def copy_runtime(target: Path) -> None:
    for source in source_dir.iterdir():
        if source.name == "config.toml" or source.is_socket():
            continue

        destination = target / source.name
        if destination.exists() or destination.is_symlink():
            raise FileExistsError(f"Destino já existe, nada foi sobrescrito: {destination}")
        if source.is_symlink():
            destination.symlink_to(os.readlink(source))
        elif source.is_dir():
            shutil.copytree(source, destination, symlinks=True)
        elif source.is_file():
            shutil.copy2(source, destination)
        else:
            raise RuntimeError(f"Tipo de arquivo não suportado: {source}")

def make_stage() -> Path:
    stage = config_root / f".herdr-migration-{time.time_ns()}"
    stage.mkdir()
    copy_runtime(stage)
    return stage

config_root.mkdir(parents=True, exist_ok=True)

if managed_path.is_symlink():
    if managed_path.resolve(strict=True) != source_dir:
        raise SystemExit(
            f"{managed_path} aponta para outra configuração; migração cancelada sem alterações."
        )

    stage = make_stage()
    backup = config_root / f".herdr-dotfiles-link-{time.time_ns()}"
    managed_path.rename(backup)
    try:
        stage.rename(managed_path)
    except Exception:
        backup.rename(managed_path)
        raise
    print(f"Estado do Herdr copiado para {managed_path}")
    print(f"Link anterior preservado em {backup}")
    print("O Home Manager criará o link de config.toml no próximo rebuild.")
    raise SystemExit(0)

if managed_path.exists():
    if not managed_path.is_dir():
        raise SystemExit(f"{managed_path} existe e não é um diretório; nada foi alterado.")

    existing_config = managed_path / "config.toml"
    if existing_config.is_symlink() and existing_config.resolve(strict=True) == source_config:
        print(f"Herdr já usa configuração compartilhada em {managed_path}")
        raise SystemExit(0)
    if existing_config.exists() or existing_config.is_symlink():
        raise SystemExit(
            f"{existing_config} já existe e não aponta para a configuração do dotfiles; nada foi sobrescrito."
        )

    stage = make_stage()
    for entry in stage.iterdir():
        entry.rename(managed_path / entry.name)
    stage.rmdir()
    print(f"Estado do Herdr preservado em {managed_path}")
    print("O Home Manager criará o link de config.toml no próximo rebuild.")
    raise SystemExit(0)

stage = make_stage()
stage.rename(managed_path)
print(f"Diretório do Herdr preparado em {managed_path}")
print("O Home Manager criará o link de config.toml no próximo rebuild.")
PY
