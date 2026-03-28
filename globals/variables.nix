{
  config,
  lib,
  ...
}: {
  imports = [];

  config.var = {
    # CHANGEME: Where is this config located at
    configDirectory = "/home/.omnix";
  };

  # DONT TOUCH THIS - it is used to make the config.var work!
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };
}
