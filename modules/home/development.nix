{
  config,
  pkgs,
  gitName,
  gitEmail,
  ...
}:

{
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep # fast search
    fd # fast find
    fzf # fuzzy finder
    zoxide # frecency-based directory navigation
    jq # json on the command line
    lazygit
    neovim
    bun
    pnpm
    uv
    python3
    ruff
    ty
    basedpyright
    rust-analyzer
    rustfmt
    clippy
    nixd
    nixfmt-rfc-style
    shellcheck
    shfmt
    lua-language-server
    stylua
    marksman
    vtsls
    vscode-langservers-extracted
    prettier
    astro-language-server
    tailwindcss-language-server
    # the font everything renders in
    nerd-fonts.hack
  ];

  fonts.fontconfig.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    NVM_DIR = "${config.home.homeDirectory}/.nvm";
    # Keep project Python environments independent from Apple's system Python.
    UV_PYTHON_PREFERENCE = "only-managed";
  };

  # Add user-installed executables, including uv-managed Python, to PATH.
  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  programs.git = {
    enable = true;
    settings.user = {
      name = gitName;
      email = gitEmail;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."github.com" = {
      HostName = "github.com";
      User = "git";
      IdentityFile = "~/.ssh/id_ed25519";
      IdentitiesOnly = true;
      AddKeysToAgent = "yes";
      UseKeychain = "yes";
    };
  };

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        mhutchie.git-graph
        eamodio.gitlens
        ms-python.python
        ms-toolsai.jupyter
      ];
      userSettings = {
        "editor.fontFamily" = "Hack Nerd Font";
        "editor.fontSize" = 14;
        "editor.formatOnSave" = true;
        "terminal.integrated.defaultProfile.osx" = "zsh";
        "workbench.browser.openLocalhostLinks" = false;
      };
    };
  };
}
