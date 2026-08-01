{ ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    initContent = ''
      bindkey '^f' autosuggest-accept

      export NVM_DIR="$HOME/.nvm"
      if [ -s /opt/homebrew/opt/nvm/nvm.sh ]; then
        . /opt/homebrew/opt/nvm/nvm.sh
      fi
    '';
    shellAliases = {
      ".." = "cd ..";
      v = "nvim";
      h = "herdr";
      rebuild = "~/.dotfiles/rebuild.sh";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude";
      ccf = "claude --dangerously-skip-permissions";
      co = "codex";
      cof = "codex --full-auto";
    };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      style = "compact";
      inline_height = 20;
      enter_accept = false;
      filter_mode = "directory";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      command_timeout = 1000;
      add_newline = false;
      format = "$directory$git_branch$git_state$git_status$cmd_duration$line_break$character";

      directory.style = "blue";

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };

      git_status = {
        style = "cyan";
        stashed = "≡";
      };

      git_state = {
        style = "bright-black";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
    };
  };
}
