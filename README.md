# dotfiles

Watch the walkthrough: https://youtu.be/5N-okeDdIuI

My personal Mac setup, managed with nix-darwin and home-manager.
One repo, one command, and a fresh Mac ends up configured the same way every time.

## Contributing / Using This Repo

These are my personal dotfiles, shared publicly so people can read them, learn from them, and fork them freely.
Feature requests and pull requests are not accepted here, and PRs are auto-closed.
If you find a bug, please open a GitHub Issue using the bug report template.

## What you get

Running the switch builds:

- System settings (dark mode, key repeat, dock, Finder, trackpad)
- Homebrew apps (casks and CLI tools)
- Nix user packages (ripgrep, fd, fzf, jq, lazygit, Neovim, Hack Nerd Font)
- Shell (zsh, aliases, starship prompt)
- Editor (Neovim config with the rose-pine moon theme)
- Terminal (WezTerm config with the rose-pine moon theme)
- Agent configs (Claude, Codex, opencode all share one AGENTS.md)

## Prerequisites

- Apple Silicon Mac, by default.
- Intel Mac: change one line.
  In `configuration.nix`, set `nixpkgs.hostPlatform = "x86_64-darwin";` (the comment right there tells you the same thing).

## Fresh-machine setup

On a brand new Mac, from a bare clone of this repo:

```sh
git clone https://github.com/kunchenguid/dotfiles.git
cd dotfiles
```

Before you run it: review "Make it yours" below.
Change the host label or CPU architecture if needed, and read the Homebrew cleanup warning.
`bootstrap.sh` applies the config to your machine, so do this first.

```sh
./bootstrap.sh
```

`bootstrap.sh` does four things, in order:

1. Installs Determinate Nix, if it isn't already installed.
2. Symlinks this repo to `~/.dotfiles`.
   This has to happen before the first build, because `home.nix` points at config files through `~/.dotfiles`.
3. Checks the `user` configured in `flake.nix` against your actual macOS username, and offers to fix it for you if they differ.
4. Runs the first `darwin-rebuild switch`.
   It fetches the `darwin-rebuild` tool from the nix-darwin 26.05 release branch, then applies this repo's locked flake config.

After that, `darwin-rebuild` exists and you're on the normal workflow below.

### Validate without applying

Once Nix is installed (`bootstrap.sh` step 1 handles that), you can check that the config builds without touching your system - handy when you have edited something:

```sh
nix flake check --no-build
nix build .#darwinConfigurations.mac.system --dry-run
```

If you renamed the host label in "Make it yours", substitute your label for `mac` in these commands.

## Daily use

Edit the config files in place, then apply:

```sh
./rebuild.sh
```

The equivalent command, useful when running the rebuild directly, is:

```sh
sudo darwin-rebuild switch --flake ~/.dotfiles#mac
```

The `#mac` suffix matters. It selects the `mac` configuration declared in
`flake.nix`; without it, `darwin-rebuild` may try to use the computer's
hostname as the configuration name.

After a rebuild, open a new terminal so the shell configuration is loaded.

## Node.js, nvm, pnpm, and Bun

This setup uses two different package managers for two different jobs:

- Homebrew installs `nvm`.
- `nvm` installs and selects the latest Node.js LTS release.
- Nix installs `pnpm` and `bun` as user packages.
- Zsh loads nvm automatically from `/opt/homebrew/opt/nvm/nvm.sh`.

The nvm setup runs during the system activation step, after Homebrew has
installed the `nvm` formula. This is important because Home Manager alone can
run before Homebrew has finished installing it.

To apply the setup:

```sh
sudo darwin-rebuild switch --flake ~/.dotfiles#mac
```

Then verify the result in a new terminal:

```sh
nvm current
node --version
pnpm --version
bun --version
```

The expected Node version is the current LTS line, not necessarily the latest
current release. To inspect installed Node versions:

```sh
nvm ls
```

To manually select the LTS version:

```sh
source /opt/homebrew/opt/nvm/nvm.sh
nvm install --lts
nvm alias default "lts/*"
nvm use default
```

If an old `stable` alias was created previously, remove it with:

```sh
nvm unalias stable
nvm alias node "lts/*"
nvm alias default "lts/*"
nvm use default
```

The quotes around `lts/*` are required in Zsh so the `*` is passed to nvm
instead of being interpreted as a filesystem wildcard.

## Atuin

Atuin is enabled through Home Manager with Zsh integration:

- compact history interface;
- 20 lines of inline history results;
- Enter selects the result without immediately accepting it;
- history filtering is scoped to the current directory.

Its configuration lives in `home.nix` under `programs.atuin`. It does not need
to be added manually to `home.packages`.

## Starship

Starship is enabled through Home Manager and loaded by Zsh. The prompt shows:

- the current directory;
- Git branch, state, and working tree status;
- stash information;
- command duration;
- different prompt symbols for success, errors, and Vim command mode.

Its configuration lives in `home.nix` under `programs.starship`.

## Troubleshooting

If the flake cannot find the configuration, make sure the command includes the
host label:

```sh
sudo darwin-rebuild switch --flake ~/.dotfiles#mac
```

If `nvm` is not available in the current shell, load it manually:

```sh
source /opt/homebrew/opt/nvm/nvm.sh
```

If Node is still pointing to the old `stable` alias, reset the aliases:

```sh
nvm install --lts
nvm alias default "lts/*"
nvm alias node "lts/*"
nvm unalias stable
nvm use default
```

## Make it yours

This repo is mine.
If you clone it, review these before you run `bootstrap.sh`:

- **Username**: run `./bootstrap.sh` (it detects your macOS username and offers to set it) OR change the single `user = "kunchen"` line in `flake.nix`.
  Everything else (`configuration.nix`, `home.nix`, home directory paths) is threaded from that one variable.
- **Host label** `"mac"`, in three places: `flake.nix` (the `darwinConfigurations."mac"` name), `rebuild.sh:5` (the `#mac` at the end of the flake reference), and `bootstrap.sh`'s first-switch command (also `#mac`).
  All three have to match.
- **CPU architecture**, `hostPlatform` in `configuration.nix` (see Prerequisites above).

**Git identity:** this config deliberately does not set your git name or email.
Git will stop your first commit and tell you to set them (`git config --global user.name "Your Name"` and `git config --global user.email you@example.com`).
If you'd rather manage that declaratively, add this back to `home.nix` with your own identity:

```nix
programs.git = {
  enable = true;
  settings.user = {
    name = "Your Name";
    email = "you@example.com";
  };
};
```

**Homebrew cleanup warning:** `configuration.nix` sets `homebrew.onActivation.cleanup = "zap"`.
That means every time you switch, Homebrew removes any package or cask on your machine that isn't listed in the `brews` and `casks` arrays in `configuration.nix`.
If you already have Homebrew stuff installed that isn't in that list, the first switch will uninstall it.
Read through `brews` and `casks` before you run `bootstrap.sh` or `rebuild.sh` for the first time, and add anything you want to keep.

**About `herdr`:** it's in the `brews` list.
It's a real public Homebrew formula (`brew info herdr` finds it in homebrew-core, no tap needed), so it will install fine.
If you don't use it, just remove it from `brews` in your copy.

**Heads-up:**

- `home/AGENTS.md` is my personal agent policy, and `home.nix` installs it for Claude, Codex, and opencode.
  If you clone this repo, you'd silently inherit my agent instructions - edit or delete `home/AGENTS.md` if you don't want that.
- The `cc` and `co` shell aliases run Claude and Codex with normal permissions.
  The `ccf` and `cof` aliases are the high-agency shortcuts: `claude --dangerously-skip-permissions` and `codex --full-auto`.
  They're convenient, but intentionally separate so you have to opt in.

## Repo tour

- `flake.nix` - the entry point.
  Wires up nixpkgs, nix-darwin, home-manager, and nix-homebrew, and declares the `mac` machine.
- `configuration.nix` - system-level config: macOS defaults, Homebrew.
- `home.nix` - user-level config: shell, packages, prompt, and the symlinks described below.
- `rebuild.sh` - re-applies the config after the first switch.
  Run this every time you make a change.
- `home/` - the actual config files that get symlinked into place (Neovim, WezTerm, herdr, Claude settings, the shared `AGENTS.md`).

## How the symlinks work

The files under `home/` are the real files - editing them here is editing your live config, no rebuild needed to see the change in your editor.
`home.nix` uses `mkOutOfStoreSymlink` to point paths like `~/.config/nvim` straight at `home/.config/nvim` in this repo, so the two never drift out of sync.
You only run `./rebuild.sh` when you change something that isn't just a symlinked file, like a package list or a system default.

## Notes

The first time you launch `nvim`, it bootstraps [lazy.nvim](https://github.com/folke/lazy.nvim) by cloning plugins from GitHub.
That needs network access once; after that it's offline.
Neovim and WezTerm both use the rose-pine moon theme.
Neovim keeps italics off and uses a transparent background on macOS, Windows, and WSL so it matches the terminal setup.

## License

This repo is licensed under MIT No Attribution.
See `LICENSE`.
