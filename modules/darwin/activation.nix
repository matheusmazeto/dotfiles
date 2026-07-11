{ user, ... }:

let
  vscodeSettings = builtins.toFile "vscode-settings.json" (builtins.toJSON {
    "editor.fontFamily" = "Hack Nerd Font";
    "editor.fontSize" = 14;
    "editor.formatOnSave" = true;
    "terminal.integrated.defaultProfile.osx" = "zsh";
  });
in

{
  system.activationScripts.postActivation.text = ''
    sudo -u ${user} -H /bin/zsh -lc '
      export NVM_DIR="$HOME/.nvm"
      mkdir -p "$NVM_DIR"
      . /opt/homebrew/opt/nvm/nvm.sh
      nvm install --lts
      nvm alias default "lts/*"
      nvm use default

      mkdir -p "$HOME/Library/Application Support/Code/User"
      install -m 644 ${vscodeSettings} \
        "$HOME/Library/Application Support/Code/User/settings.json"
    '
  '';
}
