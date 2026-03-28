{
  config,
  lib,
  pkgs,
  ...
}: let
  entries = builtins.attrNames (builtins.readDir ../overrides);
in {
}
