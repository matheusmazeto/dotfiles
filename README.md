homebrew, bun, stow, fzf, git, nvm, starship, zoxide, alacritty, font-jetbrains-mono-nerd-font

```shell
git clone https://github.com/matheusmazeto/dotfiles
```

```shell
cd ~/dotfiles
```

```shell
stow .
```

```shell
chmod +x ~/dotfiles/bootstrap.sh
```

```shell
git clone https://github.com/matheusmazeto/dotfiles ~/dotfiles
bash ~/dotfiles/bootstrap.sh
cd ~/dotfiles
brew bundle
```

```shell
bash -lc 'git clone https://github.com/matheusmazeto/dotfiles ~/dotfiles && bash ~/dotfiles/bootstrap.sh'
```

```shell
cd ~/dotfiles
brew bundle
```

```json
{
  "description": "Fix backtick and tilde key",
  "manipulators": [
    {
      "type": "basic",
      "from": {
        "key_code": "non_us_backslash"
      },
      "to": [
        { "key_code": "grave_accent_and_tilde" }
      ]
    }
  ]
}
```
