{ user, ... }:

{
  nix-homebrew = {
    enable = true;
    inherit user;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    brews = [
      "herdr"
      "pi-coding-agent"
      "librsvg"
      "nvm"
    ];
    casks = [
      "ghostty"
      "wezterm"
      "visual-studio-code"
      "claude-code"
      "codex"
      "google-chrome"
      "chatgpt"
      "bitwarden"
      "raycast"
      "opensuperwhisper"
      "discord"
      "docker-desktop"
      "bruno"
      "obsidian"
    ];
  };
}
