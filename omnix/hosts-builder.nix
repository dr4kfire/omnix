{
  inputs,
  nixpkgs,
  home-manager,
  ...
}: let
  # List of names of directories that are valid hosts configs
  availableHosts = builtins.filter (
    content_name:
      builtins.pathExists (../hosts + "/" + content_name + "/configuration.nix")
  ) (builtins.attrNames (builtins.readDir ../hosts));
in {
  # Special argument that nix builder will use to determine which config to build
  nixosConfigurations = let
    hosts_map = host: let
      host_conf = import ../hosts/${host}/configuration.nix;
      system = host_conf.config.host.system;
      pkgs = import nixpkgs {inherit system;};
    in [
      {
        name = host;
        value = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # Import OMNix option definitions (host, users, packages, omnix)
            (import ./definitions.nix)

            # Core module: translates OMNix options into actual NixOS config
            (import ./core.nix)

            # OMNix system scripts (e.g. omnix-menu)
            (import ./scripts/default.nix)

            {
              nixpkgs.overlays = [];
              _module.args = {
                inherit inputs;
              };
            }

            # Home Manager integration (modern flake output)
            home-manager.nixosModules.home-manager

            # The host's own configuration
            (import ../hosts/${host}/configuration.nix)
          ];
          specialArgs = {inherit pkgs;};
        };
      }
    ];
  in
    builtins.listToAttrs (builtins.concatMap hosts_map availableHosts);
}
