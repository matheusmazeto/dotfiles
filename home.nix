{ user, ... }:

{
  imports = [
    ./common/home.nix
    ./personal/home.nix
  ];

  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
}
