{ user, ... }:

{
  imports = [
    ./modules/home/development.nix
    ./modules/home/shell.nix
    ./modules/home/files.nix
  ];

  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
}
