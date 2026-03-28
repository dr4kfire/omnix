{
  pkgs,
  lib,
  overrides ? {},
  ...
}: let
  system = import ./system {inherit pkgs lib;};
  base = {inherit system;};
in
  lib.recursiveUpdate base overrides
