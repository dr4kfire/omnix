{lib, ...}: {
  options.users = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };

  options.host = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };
}
