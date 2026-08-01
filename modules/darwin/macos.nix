{ ... }:

{
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = false;  # keep the menu bar visible
      AppleShowAllExtensions = true;
      "com.apple.swipescrolldirection" = false;
    };
    # Configure macOS global keyboard shortcuts.
    #
    # Symbolic hotkey IDs 60 and 61 control input-source switching, which uses
    # Control-Space by default. Disable both so the shortcut can be reassigned
    # to Spotlight (ID 64). In the parameters below, 49 is the Space key code
    # and 262144 is the Control modifier mask.
    #
    # Command-Space is intentionally left unassigned by macOS so Raycast can
    # use it as its global hotkey.
    CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
      "60".enabled = false;
      "61".enabled = false;
      "64" = {
        enabled = true;
        value = {
          type = "standard";
          parameters = [ 32 49 262144 ];
        };
      };
    };
    dock = {
      autohide = false;
      persistent-apps = [
        "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
        "/System/Applications/Calendar.app"
        "/System/Applications/Notes.app"
        "/System/Applications/App Store.app"
        "/System/Applications/System Settings.app"
        "/Applications/Google Chrome.app"
        "/Applications/WezTerm.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/ChatGPT.app"
      ];
    };
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    screencapture.target = "clipboard";    # save screenshots to clipboard
    trackpad.Clicking = true;              # tap to click
  };

}
