{
  description = "
    OMNix is an all-in-one flake based configuration for NixOS based systems!
    It provides basic tools for customization, default configs and works out of the box!
    ";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {...}: let
    nixConfigs = import ./omnix/hosts-builder.nix;
  in {
    inherit (nixConfigs) nixosConfigurations;
  };
}
