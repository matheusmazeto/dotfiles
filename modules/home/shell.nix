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
      ".." = "cd .."; # Move to the parent directory.
      v = "nvim"; # Open Neovim.
      h = "herdr"; # Open Herdr.
      rebuild = "~/.dotfiles/rebuild.sh"; # Rebuild the nix-darwin and Home Manager configuration.
      q = "exit"; # Exit the current shell.
      add = "git add ."; # Stage all changes in the current repository.
      push = "git push"; # Push the current branch to its configured remote.
      pull = "git pull"; # Pull and integrate changes from the configured remote.
      m = "git switch main"; # Switch to the main branch.
      cc = "claude"; # Start Claude Code with normal permission checks.
      ccf = "claude --dangerously-skip-permissions"; # Start Claude Code while bypassing permission checks.
      co = "codex"; # Start Codex with normal permission checks.
      cof = "codex --full-auto"; # Start Codex in full-auto mode with reduced approval barriers.
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
