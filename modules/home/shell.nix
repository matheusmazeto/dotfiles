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

      unalias rebuild 2>/dev/null || true
      rebuild() {
        ~/.dotfiles/rebuild.sh && exec zsh
      }
    '';
    shellAliases = {
      ".." = "cd .."; # Move to the parent directory.
      v = "nvim"; # Open Neovim.
      h = "herdr"; # Open Herdr.
      q = "exit"; # Exit the current shell.
      cc = "claude"; # Start Claude Code with normal permission checks.
      ccf = "claude --dangerously-skip-permissions"; # Start Claude Code while bypassing permission checks.
      co = "codex"; # Start Codex with normal permission checks.
      cof = "codex --full-auto"; # Start Codex in full-auto mode with reduced approval barriers.

      # Git inspection
      gs = "git status"; # Show the working tree status.
      gd = "git diff"; # Show unstaged changes.
      gds = "git diff --staged"; # Show staged changes.
      gl = "git log --oneline --decorate --graph"; # Show a compact commit graph.
      gb = "git branch"; # List local branches.

      # Git staging and commits
      ga = "git add"; # Stage selected files.
      gdot = "git add ."; # Stage changes from the current directory.
      gall = "git add --all"; # Stage all additions, modifications, and deletions.
      gap = "git add --patch"; # Interactively stage selected hunks.
      gunstage = "git restore --staged"; # Unstage selected files.
      gunstageall = "git restore --staged ."; # Unstage all files.
      gc = "git commit"; # Create a commit.
      gcm = "git commit -m"; # Create a commit with a message.
      gca = "git commit --amend"; # Amend the last commit and edit its message.
      gcan = "git commit --amend --no-edit"; # Amend the last commit while keeping its message.

      # Git branches
      gsw = "git switch"; # Switch to an existing branch.
      agnew = "git switch -c"; # Create and switch to a new branch.
      gmain = "git switch main"; # Switch to the main branch.
      gdev = "git switch dev"; # Switch to the dev branch.
      gsandbox = "git switch sandbox"; # Switch to the sandbox branch.

      # Git remotes and synchronization
      gf = "git fetch"; # Fetch updates from the default remote.
      gfp = "git fetch --prune"; # Fetch updates and remove stale remote-tracking branches.
      gfa = "git fetch --all"; # Fetch updates from all remotes.
      gfap = "git fetch --all --prune"; # Fetch all remotes and prune stale references.
      gp = "git push"; # Push the current branch.
      gpl = "git pull"; # Pull and integrate changes from the configured remote.
      gpsl = "git push --force-with-lease"; # Safely force-push while checking the remote state.
      gpslnv = "git push --force-with-lease --no-verify"; # Force-push without local hooks.
      gpnv = "git push --no-verify"; # Push without local hooks.

      # Git rebase
      gr = "git rebase"; # Start a regular rebase.
      gri = "git rebase -i"; # Start an interactive rebase.
      grc = "git rebase --continue"; # Continue a paused rebase.
      gra = "git rebase --abort"; # Abort the current rebase.
      grs = "git rebase --skip"; # Skip the current rebased commit.
      grq = "git rebase --quit"; # Stop rebase bookkeeping while keeping working-tree changes.

      # Git merge
      gm = "git merge"; # Merge a branch into the current branch.
      gmnoc = "git merge --no-commit"; # Merge without creating the commit automatically.
      gmc = "git merge --continue"; # Continue a paused merge after resolving conflicts.
      gma = "git merge --abort"; # Abort the current merge.
      gmq = "git merge --quit"; # Stop merge bookkeeping while keeping working-tree changes.

      # Git undo and recovery
      gundo-soft = "git reset --soft HEAD~1"; # Undo the last commit and keep changes staged.
      gundo = "git reset HEAD~1"; # Undo the last commit and keep changes unstaged.
      grevert-last = "git revert HEAD"; # Create a new commit that reverts the last commit.

      # Git cherry-pick
      gcp = "git cherry-pick"; # Apply one or more commits to the current branch.
      gcpc = "git cherry-pick --continue"; # Continue a paused cherry-pick.
      gcpa = "git cherry-pick --abort"; # Abort the current cherry-pick.
      gcps = "git cherry-pick --skip"; # Skip the current cherry-picked commit.
      gcpq = "git cherry-pick --quit"; # Stop cherry-pick bookkeeping while keeping working-tree changes.
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
