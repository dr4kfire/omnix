{
  description = "OMNIX configuration - the only NixOS config you'll ever need";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {inherit system;};
    inherit (pkgs) lib;

    hostDirs = builtins.filter (
      name:
        builtins.pathExists (./hosts + "/${name}/configuration.nix")
    ) (builtins.attrNames (builtins.readDir ./hosts));

    loadDefaults = import ./defaults/default.nix;
  in {
    nixosConfigurations = lib.listToAttrs (lib.concatMap (
        host: let
          defaults = loadDefaults {inherit pkgs lib;};
          hostConf = import ./hosts/${host}/configuration.nix {inherit pkgs lib;};
        in [
          {
            name = host;
            value = nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                defaults.configuration
                hostConf
                home-manager.nixosModule
              ];
              specialArgs = {inherit pkgs;};
            };
          }
        ]
      )
      hostDirs);
  };
}
