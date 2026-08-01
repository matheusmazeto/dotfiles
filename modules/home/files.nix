{ config, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  ai = "${dotfiles}/ai";
in

{
  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";
  home.file.".config/opencode/opencode.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/opencode/opencode.json";

  # Shared AI instructions. Claude Code expects CLAUDE.md, while Codex and
  # OpenCode expect AGENTS.md, so all three links point to the same source.
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${ai}/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${ai}/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${ai}/AGENTS.md";

  # Shared skills are kept in one versioned directory and exposed through the
  # common convention plus each tool's own global discovery directory.
  home.file.".agents/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${ai}/skills";
  home.file.".config/opencode/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${ai}/skills";
  home.file.".claude/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${ai}/skills";

  # Expose every personal skill to Codex without replacing its own skills.
  # Existing real files/directories are left untouched; only missing entries
  # and symlinks previously managed by this setup are created or refreshed.
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
