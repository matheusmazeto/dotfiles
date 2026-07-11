{ ... }:

{
  imports = [
    ./modules/darwin/system.nix
    ./modules/darwin/macos.nix
    ./modules/darwin/homebrew.nix
    ./modules/darwin/activation.nix
  ];
}
