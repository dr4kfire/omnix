{
  inputs,
  nixpkgs,
  home-manager,
  ...
}: let
  # List of names of directories that are valid hosts configs
  avaliableHosts = builtins.filter (
    content_name:
      builtins.pathExists ../hosts + "/" + content_name + "/configuration.nix"
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
            {
              nixpkgs.overlays = [];
              _module.args = {
                inherit inputs;
              };
            }
            (import home-manager.nixosModule)
            (import ../hosts/${host}/configuration.nix)
          ];
          specialArgs = {inherit pkgs;};
        };
      }
    ];
  in
    builtins.listToAttrs (builtins.concatMap hosts_map) avaliableHosts;
}
