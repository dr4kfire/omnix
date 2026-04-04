{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./system/default.nix
    ./modules/default.nix
    ./desktop-env/default.nix
  ];
}
