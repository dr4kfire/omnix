{
  pkgs,
  lib,
  ...
}: let
  root = ./.;
  entries = builtins.attrNames (builtins.readDir root);
  dirs = builtins.filter (n: builtins.pathExists (root + "/" + n + "/default.nix")) entries;

  loadModule = dir: let
    m = import (root + "/" + dir + "/default.nix") {inherit pkgs lib;};
  in
    if m == null
    then {
      enabled = false;
      config = {};
    }
    else m;

  modulesAttr = lib.listToAttrs (map (d: {
      name = d;
      value = loadModule d;
    })
    dirs);

  #                              name:
  enabledModules = lib.filterAttrs (_: val: val.enabled) modulesAttr;
  enabledConfigs = lib.attrValues enabledModules;

  mergedConfig = lib.foldl' (acc: m:
    lib.recursiveUpdate acc (
      if builtins.hasAttr "config" m
      then m.config
      else {}
    )) {}
  enabledConfigs;
in {
  modules = modulesAttr;
  configuration = mergedConfig;
}
