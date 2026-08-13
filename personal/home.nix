{ config, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  ai = "${dotfiles}/ai";
in

{
  # AI instructions and skills are personal in this repository. The future
  # work repository can omit this module or provide its own version.
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${ai}/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${ai}/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${ai}/AGENTS.md";

  home.file.".agents/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${ai}/skills";
  home.file.".config/opencode/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${ai}/skills";
  home.file.".claude/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${ai}/skills";

  # Existing real Codex skills are preserved. Only missing entries and links
  # previously managed by this setup are created or refreshed.
  home.activation.linkPersonalCodexSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    codex_skills_dir="$HOME/.codex/skills"
    mkdir -p "$codex_skills_dir"

    for skill_dir in "${ai}/skills"/*; do
      [ -d "$skill_dir" ] || continue
      skill_name="$(basename "$skill_dir")"
      target="$codex_skills_dir/$skill_name"

      if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Skipping existing Codex skill: $target"
        continue
      fi

      ln -sfn "$skill_dir" "$target"
    done
  '';
}
