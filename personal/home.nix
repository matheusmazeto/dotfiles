{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  ai = "${dotfiles}/personal/ai";
in

{
  # AI instructions and skills are personal in this repository. The future
  # work repository can omit this module or provide its own version.
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/personal/home/.claude/settings.json";

  home.file.".claude/rules/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${ai}/AGENTS.md";
  home.file.".codex/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${ai}/AGENTS.md";
  home.file.".pi/agent/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${ai}/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${ai}/AGENTS.md";

  home.file.".agents/skills".source = config.lib.file.mkOutOfStoreSymlink "${ai}/skills";
  home.file.".config/opencode/skills".source = config.lib.file.mkOutOfStoreSymlink "${ai}/skills";
  home.file.".claude/skills".source = config.lib.file.mkOutOfStoreSymlink "${ai}/skills";

  programs.ghostty = {
    enable = true;
    # The Ghostty application is installed as a Homebrew cask alongside WezTerm.
    package = null;
    enableZshIntegration = true;
    settings = {
      theme = "Rose Pine Moon";
      font-family = "Hack Nerd Font";
      font-size = 15;
      window-width = 140;
      window-height = 40;
      background-opacity = 0.8;
      background-blur = 50;
    };
  };
}
