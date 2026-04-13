{
  description = "" "
    OMNix is an all-in-one flake based configuration for NixOS based systems!
    It provides basic tools for customization, default configs and works out of the box!
    " "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {inherit system;};
    inherit (pkgs) lib;

    hostDirectories =
      builtins.filter
      (
        name:
          builtins.pathExists ./hosts + "/" + name + "/configuration.nix"
      ) (builtins.attrNames (builtins.readDir ./hosts));
  in {
  };
}
