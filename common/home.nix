{ ... }:

{
  imports = [
    ../modules/home/development.nix
    ../modules/home/shell.nix
    ./home/files.nix
  ];
}
