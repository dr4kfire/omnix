{
  config,
  lib,
  ...
}: {
  imports = [
    # choose your overrides here or leave blank for the default
  ];

  config.var = {
    hostname = "omnixipad";
    username = "catnip";

    # Change this to match this configs location if it is not in the default location
    configDirecotry =
      "/home/"
      + config.var.username
      + "/.config/omnix";

    keyboardLayout = "pl";

    location = "Warsaw";
    timeZone = "Europe/Warsaw";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "pl_PL.UTF-8";

    git = {
      username = "catnip";
      email = "147838547+dr4kfire@users.noreply.github.com";
    };

    autoUpgrade = false;
    autoGarbageColletor = true;
  };

  # Do not touch this
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };
}
