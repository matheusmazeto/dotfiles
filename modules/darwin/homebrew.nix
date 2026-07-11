{ user, ... }:

{
  nix-homebrew = {
    enable = true;
    inherit user;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    brews = [
      "herdr"
      "nvm"
    ];
    casks = [
      "wezterm"
      "visual-studio-code"
      "claude-code"
      "google-chrome"
      "chatgpt"
      "bitwarden"
      "raycast"
    ];
  };
}
