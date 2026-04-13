{
  config,
  nixpkgs,
  home-manager,
  ...
}: let
  # Fetches files and directories from ./hosts and checks if a configuration.nix
  # file exists inside of them
  avaliableHosts = builtins.filter (
    content_name:
      builtins.pathExists ./hosts + "/" + content_name + "/configuration.nix"
  ) (builtins.attrNames (builtins.readDir ./hosts));

  pkgs = import nixpkgs {inherit system;};
  inherit (pkgs) lib;
in {
}
