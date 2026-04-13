{
  nixpkgs,
  home-manager,
  ...
}: let
  system = "x86_64-linux";

  pkgs = import nixpkgs {inherit system;};
  inherit (pkgs) lib;

  hosts = builtins.filter (
    name:
      builtins.pathExists ./hosts + "/" + name + "/configuration.nix"
  ) (builtins.attrNames (builtins.readDir ./hosts));
in {
}
