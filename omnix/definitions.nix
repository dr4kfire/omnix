{lib, ...}: {
  options = {
    host = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };

    users = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };

    packages = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };

    omnix = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };
}
