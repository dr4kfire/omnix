{
  description = "OMNIX configuration";

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
      name: builtins.pathExists (./hosts + "/${name}/configuration.nix")
    ) (builtins.attrNames (builtins.readDir ./hosts));
  in {
    nixosConfigurations = lib.listToAttrs (map (host: {
        name = host;
        value = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # 1. Load base defaults
            ./defaults/default.nix
            # 2. Load host specific config (automatically overrides defaults)
            ./hosts/${host}/configuration.nix
            # 3. Load HM
            home-manager.nixosModule
          ];
          specialArgs = {inherit pkgs;};
        };
      })
      hostDirs);
  };
}
