{lib, ...}: {
  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };

  options.main = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };
}
